"""Aggregate human MOS listening scores into docs/mos_results.json."""
from __future__ import annotations

import csv
import json
import statistics
import sys
from collections import defaultdict
from pathlib import Path

DIMS = ("clarity", "naturalness", "pronunciation", "rhythm", "arabic_letters", "overall_mos")


def main() -> None:
    src = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).parent / "mos_scores_template.csv"
    out = Path(__file__).resolve().parent.parent.parent / "docs" / "mos_results.json"

    buckets: dict[str, dict[str, list[float]]] = defaultdict(lambda: defaultdict(list))
    listeners: set[str] = set()
    rows = 0

    with src.open("r", encoding="utf-8-sig", newline="") as f:
        reader = csv.DictReader(line for line in f if not line.lstrip().startswith("#"))
        for row in reader:
            profile = (row.get("profile") or "").strip()
            if not profile:
                continue
            rows += 1
            if row.get("listener_id"):
                listeners.add(row["listener_id"].strip())
            for dim in DIMS:
                val = (row.get(dim) or "").strip()
                if val:
                    buckets[profile][dim].append(float(val))

    if rows == 0:
        print("No score rows found; docs/mos_results.json was not written.")
        return

    summary = {"listeners": len(listeners), "rows": rows, "profiles": {}}
    for profile, dim_map in buckets.items():
        summary["profiles"][profile] = {}
        for dim, vals in dim_map.items():
            mean = statistics.mean(vals)
            std = statistics.stdev(vals) if len(vals) > 1 else 0.0
            summary["profiles"][profile][dim] = f"{mean:.2f} ± {std:.2f}"

    out.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Wrote {out} ({len(listeners)} listeners, {rows} ratings)")


if __name__ == "__main__":
    main()
