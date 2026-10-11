"""Billing & Invoicing / Invoice API. Replaces the ABL programs
billing-invoicing/invoice_maint.p, invoice_browse.w, invoice_val.p and si_invoice.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.invoice import Invoice, InvoicePage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/billing-invoicing/invoices", tags=["Invoice"])
TABLE = "Invoice"


@router.get("", response_model=InvoicePage)
def list_invoice(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH Invoice NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in [])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{Invoicenum}", response_model=Invoice)
def get_invoice(Invoicenum: int):
    row = repo.get(TABLE, PRIMARY_KEY, (Invoicenum,))
    if not row:
        raise HTTPException(404, "Invoice not found.")
    return row


def _check_references(row: Invoice) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    if row.CustNum is not None and not repo.exists("Customer", "CustNum", row.CustNum):
        raise HTTPException(422, "The Customer number entered must be a valid one.")


@router.post("", response_model=Invoice, status_code=201)
def create_invoice(row: Invoice):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "Invoice already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{Invoicenum}", response_model=Invoice)
def update_invoice(Invoicenum: int, row: Invoice, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (Invoicenum,))
    if not current:
        raise HTTPException(404, "Invoice not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "Invoice was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{Invoicenum}", status_code=204)
def delete_invoice(Invoicenum: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (Invoicenum,)):
        raise HTTPException(404, "Invoice not found.")
    return Response(status_code=204)
