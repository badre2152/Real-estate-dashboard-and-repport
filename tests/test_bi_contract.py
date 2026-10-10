"""Validate the documented DAX export without Power BI Desktop."""

from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]
DAX = ROOT / "dax"
SQL = (ROOT / "docs" / "bi_schema_ddl.sql").read_text(encoding="utf-8")


class BIContractTests(unittest.TestCase):
    def test_all_exported_dax_files_are_nonempty(self):
        files = sorted(DAX.glob("*.dax"))
        self.assertEqual(len(files), 4)
        for file in files:
            self.assertTrue(file.read_text(encoding="utf-8").strip())

    def test_dax_columns_exist_in_reference_view(self):
        source = "\n".join(p.read_text(encoding="utf-8") for p in DAX.glob("*.dax"))
        columns = set(re.findall(r"v_annonces_full\[([^\]]+)\]", source))
        view = SQL.split("CREATE OR REPLACE VIEW bi_schema.v_annonces_full AS", 1)[1].split("FROM bi_schema.fact_annonce", 1)[0]
        for column in columns:
            self.assertRegex(view, rf"\b{re.escape(column)}\b")

    def test_geographic_averages_respect_filter_context(self):
        geo = (DAX / "geo_analysis.dax").read_text(encoding="utf-8")
        price = (DAX / "price_analysis.dax").read_text(encoding="utf-8")
        self.assertRegex(geo, r"Prix Moyen par Region\s*=\s*\[Prix Moyen\]")
        self.assertRegex(price, r"Prix Moyen par Ville\s*=\s*\[Prix Moyen\]")
        self.assertNotIn("ALLEXCEPT", geo + price)

    def test_no_decorative_emoji_in_source(self):
        files = list(DAX.glob("*.dax")) + [ROOT / "README.md"]
        for file in files:
            for char in file.read_text(encoding="utf-8"):
                point = ord(char)
                self.assertFalse(0x1F000 <= point <= 0x1FAFF or 0x2600 <= point <= 0x27BF or point in (0xFE0F, 0x200D), str(file))


if __name__ == "__main__":
    unittest.main()
