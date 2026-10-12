"""In-memory repository seeded from seed.json (sports2000 sample rows).
Swap for the OpenEdge SQL or PostgreSQL adapter in production; the routers do not change.
"""
from __future__ import annotations

import json
from pathlib import Path
from threading import Lock


class Repository:
    def __init__(self) -> None:
        self._lock = Lock()
        self._data: dict[str, list[dict]] = json.loads((Path(__file__).parent / "seed.json").read_text())
        for rows in self._data.values():
            for r in rows:
                r.setdefault("version", 0)

    def list(self, table: str) -> list[dict]:
        return list(self._data.get(table, []))

    def _find(self, table: str, keys: list[str], values: tuple) -> dict | None:
        for r in self._data.get(table, []):
            if all(str(r.get(k)) == str(v) for k, v in zip(keys, values)):
                return r
        return None

    def get(self, table: str, keys: list[str], values: tuple) -> dict | None:
        return self._find(table, keys, values)

    def exists(self, table: str, field: str, value) -> bool:
        return any(str(r.get(field)) == str(value) for r in self._data.get(table, []))

    def insert(self, table: str, row: dict) -> dict:
        with self._lock:
            row["version"] = 1
            self._data.setdefault(table, []).append(row)
            return row

    def update(self, table: str, keys: list[str], row: dict) -> dict:
        with self._lock:
            cur = self._find(table, keys, tuple(row[k] for k in keys))
            row["version"] = int(cur.get("version", 0)) + 1
            cur.clear()
            cur.update(row)
            return cur

    def delete(self, table: str, keys: list[str], values: tuple) -> bool:
        with self._lock:
            cur = self._find(table, keys, values)
            if not cur:
                return False
            self._data[table].remove(cur)
            return True


repo = Repository()
