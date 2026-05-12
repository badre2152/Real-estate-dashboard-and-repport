# Architecture BI — Real Estate Dashboard

## Flux de données complet

```
[Avito.ma]
    ↓ Selenium Scraper
[Bronze — JSON brut]
    ↓ ETL (real-estate-pipeline)
[PostgreSQL — staging / clean]
    ↓ bi_schema.run_bi_schema()
[PostgreSQL — bi_schema]
    ├── fact_annonce
    ├── dim_localisation
    ├── dim_caracteristiques
    └── dim_temps
    ↓ Vues SQL
[v_annonces_full | v_prix_par_ville | v_prix_par_quartier]
    ↓ Power Query (nettoyage léger)
[Modèle Power BI — Star Schema]
    ↓ DAX Measures
[4 Dashboards Interactifs]
```

---

## Modèle en étoile (Star Schema)

```
         dim_temps
         (id_temps, date_jour, annee, trimestre, mois, jour)
              │
dim_localisation ──── fact_annonce ──── dim_caracteristiques
(ville, quartier,     (prix, surface,   (nb_chambres,
 region_label,         prix_par_m2,      nb_salles_bain,
 quartier_known,       categorie_prix,   etage)
 is_grande_ville)      prix_type, lien)
```

---

## Tables & Vues disponibles

### fact_annonce
| Colonne | Type | Description |
|---------|------|-------------|
| id_annonce | SERIAL | Clé primaire |
| id_localisation | INT | FK → dim_localisation |
| id_caracteristiques | INT | FK → dim_caracteristiques |
| id_temps | INT | FK → dim_temps |
| prix | NUMERIC | Prix en MAD |
| prix_type | TEXT | `mensuel` / `journalier` |
| surface_m2 | NUMERIC | Surface |
| prix_par_m2 | NUMERIC | Prix calculé / m² |
| categorie_prix | TEXT | Très Bas / Bas / Moyen / Élevé / Luxe |
| lien | TEXT | URL Avito (UNIQUE) |

### dim_localisation
| Colonne | Type | Description |
|---------|------|-------------|
| id_localisation | SERIAL | Clé primaire |
| ville | TEXT | Ville |
| quartier | TEXT | Quartier (vide si inconnu) |
| quartier_known | BOOLEAN | TRUE si quartier réel |
| region_label | TEXT | Région administrative |
| is_grande_ville | BOOLEAN | TRUE pour les métropoles |

### dim_caracteristiques
| Colonne | Type | Description |
|---------|------|-------------|
| id_caracteristiques | SERIAL | Clé primaire |
| nb_chambres | BIGINT | Nullable |
| nb_salles_bain | BIGINT | Nullable |
| etage | TEXT | Étage (texte libre Avito) |

> ⚠️ `annee_construction` / `age_bien` supprimés — toujours NULL sur Avito (FIX #Q2)

### dim_temps
| Colonne | Type | Description |
|---------|------|-------------|
| id_temps | SERIAL | Clé primaire |
| date_jour | DATE | Date de scraping |
| annee | INT | Année |
| trimestre | INT | 1-4 |
| mois | INT | 1-12 |
| jour | INT | Jour du mois |
| jour_semaine | INT | 0=Lundi … 6=Dimanche |

---

## Connexion Power BI → PostgreSQL

```
Host     : localhost
Port     : 5432
Database : bad_2152_avito
Schema   : bi_schema
Mode     : Import (recommandé pour les performances)
```

**Tables à importer :**
- `bi_schema.v_annonces_full`
- `bi_schema.v_prix_par_ville`
- `bi_schema.v_prix_par_quartier`

---

## Lancer la base localement (Docker)

```bash
cd ../real-estate-pipeline
docker-compose up postgres -d
```

Puis dans Power BI : **Transformer les données** → actualiser la connexion.
