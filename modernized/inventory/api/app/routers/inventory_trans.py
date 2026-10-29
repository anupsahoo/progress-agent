"""Inventory / InventoryTrans API. Replaces the ABL programs
inventory/inventory_trans_maint.p, inventory_trans_browse.w, inventory_trans_val.p and si_inventory_trans.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.inventory_trans import InventoryTrans, InventoryTransPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/inventory/inventory-transes", tags=["InventoryTrans"])
TABLE = "InventoryTrans"


@router.get("", response_model=InventoryTransPage)
def list_inventory_trans(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH InventoryTrans NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["InvType","Transtime"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{InvTransNum}", response_model=InventoryTrans)
def get_inventory_trans(InvTransNum: int):
    row = repo.get(TABLE, PRIMARY_KEY, (InvTransNum,))
    if not row:
        raise HTTPException(404, "InventoryTrans not found.")
    return row


def _check_references(row: InventoryTrans) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    if row.Itemnum is not None and not repo.exists("Item", "Itemnum", row.Itemnum):
        raise HTTPException(422, "Item must be on file.")


@router.post("", response_model=InventoryTrans, status_code=201)
def create_inventory_trans(row: InventoryTrans):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "InventoryTrans already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{InvTransNum}", response_model=InventoryTrans)
def update_inventory_trans(InvTransNum: int, row: InventoryTrans, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (InvTransNum,))
    if not current:
        raise HTTPException(404, "InventoryTrans not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "InventoryTrans was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{InvTransNum}", status_code=204)
def delete_inventory_trans(InvTransNum: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (InvTransNum,)):
        raise HTTPException(404, "InventoryTrans not found.")
    return Response(status_code=204)
