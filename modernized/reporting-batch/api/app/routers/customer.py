"""Reporting & Batch / Customer API. Replaces the ABL programs
reporting-batch/customer_maint.p, customer_browse.w, customer_val.p and si_customer.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.customer import Customer, CustomerPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/reporting-batch/customers", tags=["Customer"])
TABLE = "Customer"


@router.get("", response_model=CustomerPage)
def list_customer(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH Customer NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["Country","Name","Address"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{CustNum}", response_model=Customer)
def get_customer(CustNum: int):
    row = repo.get(TABLE, PRIMARY_KEY, (CustNum,))
    if not row:
        raise HTTPException(404, "Customer not found.")
    return row
