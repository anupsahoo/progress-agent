"""Billing & Invoicing / BillTo API. Replaces the ABL programs
billing-invoicing/bill_to_maint.p, bill_to_browse.w, bill_to_val.p and si_bill_to.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.bill_to import BillTo, BillToPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/billing-invoicing/bill-tos", tags=["BillTo"])
TABLE = "BillTo"


@router.get("", response_model=BillToPage)
def list_bill_to(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH BillTo NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["Name","Address","Address2"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{CustNum}/{BillToID}", response_model=BillTo)
def get_bill_to(CustNum: int, BillToID: int):
    row = repo.get(TABLE, PRIMARY_KEY, (CustNum, BillToID,))
    if not row:
        raise HTTPException(404, "BillTo not found.")
    return row


def _check_references(row: BillTo) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    if row.CustNum is not None and not repo.exists("Customer", "CustNum", row.CustNum):
        raise HTTPException(422, "Customer number must be greater than zero")


@router.post("", response_model=BillTo, status_code=201)
def create_bill_to(row: BillTo):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "BillTo already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{CustNum}/{BillToID}", response_model=BillTo)
def update_bill_to(CustNum: int, BillToID: int, row: BillTo, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (CustNum, BillToID,))
    if not current:
        raise HTTPException(404, "BillTo not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "BillTo was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{CustNum}/{BillToID}", status_code=204)
def delete_bill_to(CustNum: int, BillToID: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (CustNum, BillToID,)):
        raise HTTPException(404, "BillTo not found.")
    return Response(status_code=204)
