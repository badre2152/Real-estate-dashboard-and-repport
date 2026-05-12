# 📊 Avito Real Estate — BI Dashboard

[![PowerBI](https://img.shields.io/badge/Power%20BI-2.136%2B-F2C811?style=flat&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=flat&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/license-MIT-green)](./LICENSE)

> Tableau de bord interactif pour l'analyse du marché immobilier marocain — construit sur le BI Schema du pipeline [real-estate-pipeline](https://github.com/badre2152/real-estate-pipeline).

---

## 🎯 Objectif

Exploiter les données du `bi_schema` (Data Warehouse) pour construire des **dashboards interactifs Power BI** permettant d'analyser :
- Les tendances du marché immobilier marocain
- La distribution géographique des prix
- L'évolution temporelle des annonces
- Les segments et types de biens

---

## 🧱 Architecture BI

```
PostgreSQL (bi_schema)
    ├── fact_annonce          ← Table de faits
    ├── dim_localisation      ← Dimension géographique
    ├── dim_caracteristiques  ← Dimension propriétés du bien
    └── dim_temps             ← Dimension temporelle
            ↓
    Power Query (nettoyage léger)
            ↓
    Modèle Power BI (Star Schema)
            ↓
    DAX Measures (KPIs)
            ↓
    4 Dashboards Interactifs
```

---

## 📊 Dashboards

| # | Dashboard | Description |
|---|-----------|-------------|
| 1 | 🌍 Vue Globale | KPIs principaux, répartition par ville, évolution temporelle |
| 2 | 💰 Analyse des Prix | Distribution, prix/m², segments immobiliers |
| 3 | 📍 Analyse Géographique | Carte des prix, classement des zones |
| 4 | 📈 Analyse des Tendances | Évolution, saisonnalité, volume |

---

## 🗂️ Structure du Projet

```
real-estate-bi-dashboard/
├── powerbi/
│   └── real_estate_dashboard.pbix   # Fichier Power BI principal
├── dax/
│   ├── global_kpis.dax              # KPIs globaux
│   ├── price_analysis.dax           # Mesures d'analyse des prix
│   ├── geo_analysis.dax             # Mesures géographiques
│   └── trend_analysis.dax           # Mesures de tendances
├── powerquery/
│   └── transformations.md           # Documentation des transformations
├── data/
│   └── samples/                     # Données d'exemple (anonymisées)
├── docs/
│   ├── architecture.md              # Documentation technique
│   └── bi_schema_ddl.sql            # Schéma DDL PostgreSQL
├── screenshots/
│   └── *.png                        # Captures des dashboards
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

---

## ⚙️ Prérequis

| Outil | Version minimale | Notes |
|-------|-----------------|-------|
| Power BI Desktop | **2.136** (December 2024) | Requis pour les DAX measures utilisées |
| PostgreSQL | 13+ | Via le pipeline real-estate-pipeline |
| Docker | 20+ | Pour lancer la base localement |

> ⚠️ Les versions antérieures à December 2024 de Power BI peuvent ne pas supporter certaines fonctions DAX utilisées dans ce projet.

---

## 🔌 Connexion à la Base de Données

1. Ouvrir Power BI Desktop
2. **Obtenir des données** → PostgreSQL
3. Serveur : `localhost:5432` ⚠️ (port mappé par Docker)
4. Base : `bad_2152_avito`
5. Importer uniquement les tables du schéma `bi_schema`

> ⚠️ Ne pas importer `ml_schema` — réservé au Machine Learning.

---

## 🔄 Filtres Interactifs

Tous les dashboards supportent les filtres croisés suivants :

- 🏙️ **Ville**
- 🏠 **Type de bien**
- 💵 **Plage de prix**
- 📐 **Surface (m²)**
- 📅 **Période**

---

## 🚀 Démarrage Rapide

```bash
# 1. Lancer la base de données
cd ../real-estate-pipeline
docker-compose up postgres -d

# 2. Ouvrir le fichier Power BI
open powerbi/real_estate_dashboard.pbix

# 3. Mettre à jour la connexion si nécessaire
# Fichier → Options → Paramètres de la source de données
```

---

## 🤝 Contribuer

Consultez [CONTRIBUTING.md](./CONTRIBUTING.md) pour les conventions de nommage DAX, le processus de Pull Request, et les guidelines de contribution.

---

## 📝 Changelog

Voir [CHANGELOG.md](./CHANGELOG.md) pour l'historique des versions.

---

## 📄 Licence

Ce projet est sous licence MIT — voir [LICENSE](./LICENSE) pour les détails.

---

## 👤 Auteur

**BRAHIM BADRE** — Data Engineering & Analytics

---

## ⭐ Support

Si ce projet vous a été utile, n'hésitez pas à lui donner une étoile ⭐