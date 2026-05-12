# Guide de Contribution

Merci de contribuer à ce projet ! Ce guide explique comment participer efficacement.

---

## 📋 Prérequis

- Power BI Desktop ≥ December 2024 (version 2.136+)
- Accès à PostgreSQL via le pipeline [real-estate-pipeline](https://github.com/badre2152/real-estate-pipeline)
- Git configuré localement

---

## 🔄 Processus de contribution

### 1. Fork & Clone

```bash
# Fork le dépôt sur GitHub, puis :
git clone https://github.com/VOTRE_USERNAME/real-estate-bi-dashboard.git
cd real-estate-bi-dashboard
```

### 2. Créer une branche

Respectez la convention de nommage :

| Type | Branche |
|------|---------|
| Nouveau dashboard | `feature/dashboard-X` |
| Nouvelle mesure DAX | `feature/dax-nom-mesure` |
| Correction | `fix/description-courte` |
| Documentation | `docs/description-courte` |

```bash
git checkout -b feature/dashboard-prix-avance
```

### 3. Faire vos modifications

Consultez les sections ci-dessous selon votre type de contribution.

### 4. Commit

Utilisez le format **Conventional Commits** :

```
<type>: <description courte en français>

[corps optionnel — explication du pourquoi]
```

Types acceptés : `feat`, `fix`, `docs`, `refactor`, `test`

Exemples :
```bash
git commit -m "feat: ajouter mesure DAX taux de variation mensuel"
git commit -m "fix: corriger calcul prix/m² pour biens sans surface"
git commit -m "docs: mettre à jour architecture avec nouvelles vues SQL"
```

### 5. Push & Pull Request

```bash
git push origin feature/dashboard-prix-avance
```

Ouvrez une Pull Request sur GitHub vers la branche `main` en incluant :
- Description des changements
- Capture d'écran si modification visuelle
- Référence à l'issue concernée (`Closes #12`)

---

## 📐 Conventions DAX

### Nommage
- **Mesures** : `Nom En Français` (espaces autorisés, majuscule initiale)
- **Variables internes** : `snake_case`
- **Tables calculées** : `PascalCase`

### Structure d'une mesure

```dax
Nom De La Mesure =
VAR nom_variable =
    CALCULATE(
        [Mesure de base],
        FILTER(...)
    )
RETURN
    nom_variable
```

### Documentation obligatoire

Chaque mesure doit commencer par un commentaire :

```dax
-- Description : Ce que calcule la mesure
-- Table source : fact_annonce / dim_localisation / ...
-- Filtres appliqués : (si non évident)
Nom De La Mesure =
    ...
```

### Fichier cible

| Catégorie | Fichier |
|-----------|---------|
| KPIs globaux | `dax/global_kpis.dax` |
| Analyse des prix | `dax/price_analysis.dax` |
| Analyse géographique | `dax/geo_analysis.dax` |
| Tendances temporelles | `dax/trend_analysis.dax` |

Créez un nouveau fichier si la catégorie n'existe pas encore.

---

## 🗂️ Conventions Power Query

- Documentez chaque transformation dans `powerquery/transformations.md`
- Nommez les étapes en français : `Filtrer lignes vides`, `Renommer colonnes`, etc.
- N'importez jamais `ml_schema` — réservé au pipeline Machine Learning

---

## 🏗️ Structure des branches

```
main                  ← version stable, protégée
├── feature/...       ← nouvelles fonctionnalités
├── fix/...           ← corrections de bugs
└── docs/...          ← documentation uniquement
```

Les merges vers `main` se font uniquement via Pull Request.

---

## 🐛 Signaler un bug

Ouvrez une [GitHub Issue](../../issues/new) en précisant :
1. La version de Power BI utilisée
2. Le dashboard ou la mesure concernée
3. Le comportement attendu vs observé
4. Une capture d'écran si possible

---

## ❓ Questions

Ouvrez une issue avec le label `question` — toute contribution est la bienvenue !