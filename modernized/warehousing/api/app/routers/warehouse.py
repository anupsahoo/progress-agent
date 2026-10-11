"""Warehousing / Warehouse API. Replaces the ABL programs
warehousing/warehouse_maint.p, warehouse_browse.w, warehouse_val.p and si_warehouse.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.warehouse import Warehouse, WarehousePage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/warehousing/warehouses", tags=["Warehouse"])
TABLE = "Warehouse"


@router.get("", response_model=WarehousePage)
def list_warehouse(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH Warehouse NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["WarehouseName","Country","Address"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{WarehouseNum}", response_model=Warehouse)
def get_warehouse(WarehouseNum: int):
    row = repo.get(TABLE, PRIMARY_KEY, (WarehouseNum,))
    if not row:
        raise HTTPException(404, "Warehouse not found.")
    return row


def _check_references(row: Warehouse) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    return None


@router.post("", response_model=Warehouse, status_code=201)
def create_warehouse(row: Warehouse):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "Warehouse already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{WarehouseNum}", response_model=Warehouse)
def update_warehouse(WarehouseNum: int, row: Warehouse, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (WarehouseNum,))
    if not current:
        raise HTTPException(404, "Warehouse not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "Warehouse was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{WarehouseNum}", status_code=204)
def delete_warehouse(WarehouseNum: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (WarehouseNum,)):
        raise HTTPException(404, "Warehouse not found.")
    return Response(status_code=204)
