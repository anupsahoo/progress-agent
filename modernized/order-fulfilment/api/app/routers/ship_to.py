"""Order Fulfilment / ShipTo API. Replaces the ABL programs
order-fulfilment/ship_to_maint.p, ship_to_browse.w, ship_to_val.p and si_ship_to.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.ship_to import ShipTo, ShipToPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/order-fulfilment/ship-tos", tags=["ShipTo"])
TABLE = "ShipTo"


@router.get("", response_model=ShipToPage)
def list_ship_to(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH ShipTo NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["Contact","Address","Address2"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{CustNum}/{ShipToID}", response_model=ShipTo)
def get_ship_to(CustNum: int, ShipToID: int):
    row = repo.get(TABLE, PRIMARY_KEY, (CustNum, ShipToID,))
    if not row:
        raise HTTPException(404, "ShipTo not found.")
    return row


def _check_references(row: ShipTo) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    if row.CustNum is not None and not repo.exists("Customer", "CustNum", row.CustNum):
        raise HTTPException(422, "Customer must exist")


@router.post("", response_model=ShipTo, status_code=201)
def create_ship_to(row: ShipTo):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "ShipTo already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{CustNum}/{ShipToID}", response_model=ShipTo)
def update_ship_to(CustNum: int, ShipToID: int, row: ShipTo, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (CustNum, ShipToID,))
    if not current:
        raise HTTPException(404, "ShipTo not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "ShipTo was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{CustNum}/{ShipToID}", status_code=204)
def delete_ship_to(CustNum: int, ShipToID: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (CustNum, ShipToID,)):
        raise HTTPException(404, "ShipTo not found.")
    return Response(status_code=204)
