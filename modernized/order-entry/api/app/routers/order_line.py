"""Order Entry / OrderLine API. Replaces the ABL programs
order-entry/order_line_maint.p, order_line_browse.w, order_line_val.p and si_order_line.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.order_line import OrderLine, OrderLinePage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/order-entry/order-lines", tags=["OrderLine"])
TABLE = "OrderLine"


@router.get("", response_model=OrderLinePage)
def list_order_line(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH OrderLine NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["OrderLineStatus"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{Ordernum}/{Linenum}", response_model=OrderLine)
def get_order_line(Ordernum: int, Linenum: int):
    row = repo.get(TABLE, PRIMARY_KEY, (Ordernum, Linenum,))
    if not row:
        raise HTTPException(404, "OrderLine not found.")
    return row


def _check_references(row: OrderLine) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    if row.Ordernum is not None and not repo.exists("Order", "Ordernum", row.Ordernum):
        raise HTTPException(422, "Order must exist")
    if row.Itemnum is not None and not repo.exists("Item", "Itemnum", row.Itemnum):
        raise HTTPException(422, "Item must be on file")


@router.post("", response_model=OrderLine, status_code=201)
def create_order_line(row: OrderLine):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "OrderLine already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{Ordernum}/{Linenum}", response_model=OrderLine)
def update_order_line(Ordernum: int, Linenum: int, row: OrderLine, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (Ordernum, Linenum,))
    if not current:
        raise HTTPException(404, "OrderLine not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "OrderLine was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{Ordernum}/{Linenum}", status_code=204)
def delete_order_line(Ordernum: int, Linenum: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (Ordernum, Linenum,)):
        raise HTTPException(404, "OrderLine not found.")
    return Response(status_code=204)
