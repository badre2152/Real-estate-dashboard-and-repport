-- ============================================================
-- BI Schema DDL — real-estate-bi-dashboard
-- Source: real-estate-pipeline/src/warehouse/bi_schema.py
-- Database: bad_2152_avito
-- ============================================================

CREATE SCHEMA IF NOT EXISTS bi_schema;

-- Dimension Localisation
CREATE TABLE IF NOT EXISTS bi_schema.dim_localisation (
    id_localisation SERIAL PRIMARY KEY,
    ville           TEXT NOT NULL,
    quartier        TEXT NOT NULL DEFAULT '',
    quartier_known  BOOLEAN NOT NULL DEFAULT FALSE,
    region_label    TEXT NOT NULL DEFAULT 'Autre',
    is_grande_ville BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (ville, quartier)
);

-- Dimension Caractéristiques
CREATE TABLE IF NOT EXISTS bi_schema.dim_caracteristiques (
    id_caracteristiques SERIAL PRIMARY KEY,
    nb_chambres         BIGINT,
    nb_salles_bain      BIGINT,
    etage               TEXT NOT NULL DEFAULT ''
);
-- Note: annee_construction / age_bien supprimés (FIX #Q2 — toujours NULL sur Avito)

-- Dimension Temps
CREATE TABLE IF NOT EXISTS bi_schema.dim_temps (
    id_temps     SERIAL PRIMARY KEY,
    date_jour    DATE NOT NULL UNIQUE,
    annee        INTEGER,
    trimestre    INTEGER,
    mois         INTEGER,
    jour         INTEGER,
    jour_semaine INTEGER
);

-- Table de Faits
CREATE TABLE IF NOT EXISTS bi_schema.fact_annonce (
    id_annonce          SERIAL PRIMARY KEY,
    id_localisation     INTEGER REFERENCES bi_schema.dim_localisation(id_localisation),
    id_caracteristiques INTEGER REFERENCES bi_schema.dim_caracteristiques(id_caracteristiques),
    id_temps            INTEGER REFERENCES bi_schema.dim_temps(id_temps),
    titre               TEXT,
    prix                NUMERIC,
    prix_type           TEXT DEFAULT 'mensuel',   -- mensuel | journalier
    surface_m2          NUMERIC,
    prix_par_m2         NUMERIC,
    categorie_prix      TEXT,                     -- Très Bas | Bas | Moyen | Élevé | Luxe
    lien                TEXT UNIQUE,
    loaded_at           TIMESTAMP DEFAULT NOW()
);

-- ── Vues Power BI ──────────────────────────────────────────

-- Vue principale (utilisée comme table principale dans Power BI)
CREATE OR REPLACE VIEW bi_schema.v_annonces_full AS
SELECT
    f.id_annonce,
    l.ville, l.quartier, l.quartier_known, l.region_label, l.is_grande_ville,
    c.nb_chambres, c.nb_salles_bain, c.etage,
    t.date_jour, t.annee, t.trimestre, t.mois,
    f.titre, f.prix, f.prix_type, f.surface_m2, f.prix_par_m2,
    f.categorie_prix, f.lien
FROM bi_schema.fact_annonce f
LEFT JOIN bi_schema.dim_localisation     l ON f.id_localisation     = l.id_localisation
LEFT JOIN bi_schema.dim_caracteristiques c ON f.id_caracteristiques = c.id_caracteristiques
LEFT JOIN bi_schema.dim_temps            t ON f.id_temps            = t.id_temps
WHERE f.prix_type != 'journalier_suspect';

-- Vue prix par ville
CREATE OR REPLACE VIEW bi_schema.v_prix_par_ville AS
SELECT
    l.ville, l.region_label, f.prix_type,
    COUNT(*)                              AS nb_annonces,
    ROUND(AVG(f.prix)::numeric, 0)        AS prix_moyen,
    ROUND(AVG(f.prix_par_m2)::numeric, 0) AS prix_m2_moyen,
    MIN(f.prix)                           AS prix_min,
    MAX(f.prix)                           AS prix_max
FROM bi_schema.fact_annonce f
JOIN bi_schema.dim_localisation l ON f.id_localisation = l.id_localisation
WHERE f.prix IS NOT NULL AND f.prix_type != 'journalier_suspect'
GROUP BY l.ville, l.region_label, f.prix_type
ORDER BY prix_moyen DESC;

-- Vue prix par quartier (quartiers connus uniquement, min 3 annonces)
CREATE OR REPLACE VIEW bi_schema.v_prix_par_quartier AS
SELECT
    l.ville, l.quartier, l.region_label, f.prix_type,
    COUNT(*)                              AS nb_annonces,
    ROUND(AVG(f.prix)::numeric, 0)        AS prix_moyen,
    ROUND(AVG(f.prix_par_m2)::numeric, 0) AS prix_m2_moyen,
    MIN(f.prix)                           AS prix_min,
    MAX(f.prix)                           AS prix_max
FROM bi_schema.fact_annonce f
JOIN bi_schema.dim_localisation l ON f.id_localisation = l.id_localisation
WHERE f.prix IS NOT NULL
  AND f.prix_type != 'journalier_suspect'
  AND l.quartier_known = TRUE
GROUP BY l.ville, l.quartier, l.region_label, f.prix_type
HAVING COUNT(*) >= 3
ORDER BY l.ville, prix_moyen DESC;
