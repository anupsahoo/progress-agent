"""Customer Management / Customer API. Replaces the ABL programs
customer-management/customer_maint.p, customer_browse.w, customer_val.p and si_customer.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.customer import Customer, CustomerPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/customer-management/customers", tags=["Customer"])
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


def _check_references(row: Customer) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    if row.SalesRep is not None and not repo.exists("Salesrep", "SalesRep", row.SalesRep):
        raise HTTPException(422, "The Sales Rep's name you've entered must exist in the Salesrep table.")


@router.post("", response_model=Customer, status_code=201)
def create_customer(row: Customer):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "Customer already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{CustNum}", response_model=Customer)
def update_customer(CustNum: int, row: Customer, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (CustNum,))
    if not current:
        raise HTTPException(404, "Customer not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "Customer was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{CustNum}", status_code=204)
def delete_customer(CustNum: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (CustNum,)):
        raise HTTPException(404, "Customer not found.")
    return Response(status_code=204)
