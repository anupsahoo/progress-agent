"""Reporting & Batch / Order API. Replaces the ABL programs
reporting-batch/order_maint.p, order_browse.w, order_val.p and si_order.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.order import Order, OrderPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/reporting-batch/orders", tags=["Order"])
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
