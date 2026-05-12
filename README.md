# 📊 Avito Real Estate — BI Dashboard

[![PowerBI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=flat&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/license-MIT-green)](./LICENSE)

> Tableau de bord interactif pour l'analyse du marché immobilier marocain — construit sur le BI Schema du pipeline [real-estate-pipeline](https://github.com/badre2152/real-estate-pipeline).

---

## 🔗 Ecosystem

Ce dashboard fait partie d'un projet data end-to-end :

| Repo | Rôle | Lien |
|------|------|------|
| ⚙️ **real-estate-pipeline** | Upstream — Scraping → ETL → PostgreSQL | [badre2152/real-estate-pipeline](https://github.com/badre2152/real-estate-pipeline) |
| 📊 **avito-dashboards-and-repports** *(ce repo)* | Downstream — Power BI Dashboards & Reports | — |

```
real-estate-pipeline
    └──> PostgreSQL (bi_schema)
              └──> avito-dashboards-and-repports
```

> ⚠️ Ce repo nécessite que le pipeline upstream soit lancé pour alimenter la base de données.

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
│   └── architecture.md              # Documentation technique
├── screenshots/
│   └── *.png                        # Captures des dashboards
├── CHANGELOG.md
├── CONTRIBUTING.md
└── README.md
```

---

## 🔌 Connexion à la Base de Données

1. Ouvrir Power BI Desktop
2. **Obtenir des données** → PostgreSQL
3. Serveur : `localhost:5433` ⚠️ (port mappé par Docker)
4. Base : `real_estate_db`
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

## ⚙️ Prérequis

- Power BI Desktop (dernière version)
- Accès à PostgreSQL (`bi_schema`) — via le pipeline [real-estate-pipeline](https://github.com/badre2152/real-estate-pipeline)
- Docker (pour lancer la base de données localement)

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

## 👤 Auteur

**BRAHIM BADRE** — Data Engineering & Analytics

---

## ⭐ Support

Si ce projet vous a été utile, n'hésitez pas à lui donner une étoile ⭐
