"""Reporting & Batch / OrderLine API. Replaces the ABL programs
reporting-batch/order_line_maint.p, order_line_browse.w, order_line_val.p and si_order_line.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.order_line import OrderLine, OrderLinePage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/reporting-batch/order-lines", tags=["OrderLine"])
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
