# Power Query — Transformations Documentation

## Tables importées depuis `bi_schema`

Power BI se connecte directement aux **vues** du bi_schema (plus performant que les tables brutes) :

| Vue / Table | Utilisation |
|-------------|-------------|
| `v_annonces_full` | Table principale — tous les dashboards |
| `v_prix_par_ville` | Dashboard 3 (Géographique) |
| `v_prix_par_quartier` | Dashboard 3 (Géographique) — quartiers connus uniquement |

> ⚠️ Ne pas importer `ml_schema` — réservé au Machine Learning.

---

## Colonnes de `v_annonces_full`

| Colonne | Type | Notes |
|---------|------|-------|
| `id_annonce` | Integer | Clé primaire |
| `ville` | Text | Ex: "Casablanca", "Rabat" |
| `quartier` | Text | Vide si inconnu |
| `quartier_known` | Boolean | TRUE = quartier réel |
| `region_label` | Text | Ex: "Casablanca-Settat" |
| `is_grande_ville` | Boolean | TRUE pour les grandes métropoles |
| `nb_chambres` | Decimal | Nullable |
| `nb_salles_bain` | Decimal | Nullable |
| `etage` | Text | Ex: "membre depuis 2019" (texte libre) |
| `date_jour` | Date | Date de scraping |
| `annee` | Integer | Ex: 2026 |
| `trimestre` | Integer | 1-4 |
| `mois` | Integer | 1-12 |
| `titre` | Text | Titre de l'annonce |
| `prix` | Decimal | Prix en MAD |
| `prix_type` | Text | `mensuel` ou `journalier` |
| `surface_m2` | Decimal | Surface en m² |
| `prix_par_m2` | Decimal | Prix / m² |
| `categorie_prix` | Text | `Très Bas` / `Bas` / `Moyen` / `Élevé` / `Luxe` |
| `lien` | Text | URL Avito |

---

## Transformations appliquées dans Power Query

### v_annonces_full

```
1. Changer type [quartier_known] → Boolean
2. Changer type [is_grande_ville] → Boolean
3. Changer type [date_jour] → Date
4. Changer type [prix], [surface_m2], [prix_par_m2] → Decimal Number
5. Changer type [annee], [trimestre], [mois] → Integer
6. Filtrer [prix_type] ≠ "journalier_suspect" (déjà filtré par la vue)
7. Remplacer NULL dans [quartier] par "Non spécifié"
8. Créer colonne [periode_label] :
   = Text.From([annee]) & " T" & Text.From([trimestre])
9. Créer colonne [mois_label] :
   = Date.ToText([date_jour], "MMM yyyy")
```

### v_prix_par_ville

```
1. Changer types numériques : prix_moyen, prix_m2_moyen, prix_min, prix_max → Decimal
2. nb_annonces → Integer
3. Renommer [prix_m2_moyen] → [prix_par_m2_moyen] pour cohérence
```

### v_prix_par_quartier

```
1. Même transformations que v_prix_par_ville
2. Filtrer nb_annonces >= 3 (déjà fait dans la vue SQL)
```

---

## Ordre de chargement recommandé

1. `v_annonces_full` (table principale)
2. `v_prix_par_ville`
3. `v_prix_par_quartier`

---

## Colonne calculée : categorie_prix (ordre personnalisé)

Dans Power BI, créer une table de tri pour `categorie_prix` :

```
Ordre Categorie =
SWITCH(v_annonces_full[categorie_prix],
    "Très Bas", 1,
    "Bas",      2,
    "Moyen",    3,
    "Élevé",    4,
    "Luxe",     5,
    0
)
```
