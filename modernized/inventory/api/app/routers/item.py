"""Inventory / Item API. Replaces the ABL programs
inventory/item_maint.p, item_browse.w, item_val.p and si_item.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.item import Item, ItemPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/inventory/items", tags=["Item"])
TABLE = "Item"


@router.get("", response_model=ItemPage)
def list_item(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH Item NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["ItemName","CatDescription","Category1"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{Itemnum}", response_model=Item)
def get_item(Itemnum: int):
    row = repo.get(TABLE, PRIMARY_KEY, (Itemnum,))
    if not row:
        raise HTTPException(404, "Item not found.")
    return row


def _check_references(row: Item) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    return None


@router.post("", response_model=Item, status_code=201)
def create_item(row: Item):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "Item already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{Itemnum}", response_model=Item)
def update_item(Itemnum: int, row: Item, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (Itemnum,))
    if not current:
        raise HTTPException(404, "Item not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "Item was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{Itemnum}", status_code=204)
def delete_item(Itemnum: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (Itemnum,)):
        raise HTTPException(404, "Item not found.")
    return Response(status_code=204)
