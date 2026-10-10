# Technical Audit: October 2026

## Scope

Reviewed source DAX measures, the reference BI SQL schema, Power Query documentation, and the repository presentation. The Power BI binary report was not opened in Power BI Desktop, and no live PostgreSQL data source was connected.

## Confirmed findings

### High: Geographic averages ignored report context

`Prix Moyen par Ville` and `Prix Moyen par Region` used `ALLEXCEPT`, removing filters such as listing period, category and rental frequency. These measures now reuse `[Prix Moyen]` so the visual's city or region grouping and active report filters are respected.

### Medium: Top city result was not deterministic

The `Top Ville` measure previously used `FIRSTNONBLANK` over `TOPN` without an explicit secondary sort. It now ranks by listing count and then city name, and converts the selected row to a text value. The measure respects the active selection outside the city column.

### Medium: Time intelligence requires validation in Power BI

`DATESMTD`, `DATEADD`, `DATESYTD`, and `DATESINPERIOD` currently use `v_annonces_full[date_jour]` directly. These measures should be validated against a contiguous calendar dimension and a marked date table in the Power BI model. We have not changed the live model or invented such a table in text exports.

### Medium: Daily and monthly rental prices should not be aggregated together

Base price measures are unqualified in `prix_type`. Use the included monthly or daily measures for meaningful rental-price comparisons, and state the frequency clearly when presenting price charts. We have not silently changed historical dashboard metric definitions.

### Medium: Reference schema is not an executable production migration

`docs/bi_schema_ddl.sql` describes a reference structure. Its historical configuration and field semantics should be checked against the upstream data pipeline before any real database deployment.

## Verification limits

Static repository checks can confirm that DAX references known fields, that no decorative emojis remain in source text, and that documented filter-safety changes are retained. They cannot execute DAX in a Power BI semantic model, validate relationships in the PBIX binary, confirm dashboard page counts, or verify current visual behavior.

## Release checks

1. Run source validation in CI.
2. Review DAX changed lines and references.
3. Test measures in Power BI Desktop with realistic filtering and calendar data before asserting that the dashboard itself is fully verified.
