"""Order Entry / Order API. Replaces the ABL programs
order-entry/order_maint.p, order_browse.w, order_val.p and si_order.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.order import Order, OrderPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/order-entry/orders", tags=["Order"])
TABLE = "Order"


@router.get("", response_model=OrderPage)
def list_order(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH Order NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["Carrier","Instructions","PO"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{Ordernum}", response_model=Order)
def get_order(Ordernum: int):
    row = repo.get(TABLE, PRIMARY_KEY, (Ordernum,))
    if not row:
        raise HTTPException(404, "Order not found.")
    return row


def _check_references(row: Order) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    if row.CustNum is not None and not repo.exists("Customer", "CustNum", row.CustNum):
        raise HTTPException(422, "Customer must already exist.")
    if row.WarehouseNum not in (None, 0) and not repo.exists("Warehouse", "WarehouseNum", row.WarehouseNum):
        raise HTTPException(422, "Entrer a number greater than zero")


@router.post("", response_model=Order, status_code=201)
def create_order(row: Order):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "Order already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{Ordernum}", response_model=Order)
def update_order(Ordernum: int, row: Order, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (Ordernum,))
    if not current:
        raise HTTPException(404, "Order not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "Order was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{Ordernum}", status_code=204)
def delete_order(Ordernum: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (Ordernum,)):
        raise HTTPException(404, "Order not found.")
    return Response(status_code=204)
