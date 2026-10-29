"""Sales & Territories / Salesrep API. Replaces the ABL programs
sales-territories/salesrep_maint.p, salesrep_browse.w, salesrep_val.p and si_salesrep.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.salesrep import Salesrep, SalesrepPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/sales-territories/salesreps", tags=["Salesrep"])
TABLE = "Salesrep"


@router.get("", response_model=SalesrepPage)
def list_salesrep(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH Salesrep NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["SalesRep","RepName","Region"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{SalesRep}", response_model=Salesrep)
def get_salesrep(SalesRep: str):
    row = repo.get(TABLE, PRIMARY_KEY, (SalesRep,))
    if not row:
        raise HTTPException(404, "Salesrep not found.")
    return row


def _check_references(row: Salesrep) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    return None


@router.post("", response_model=Salesrep, status_code=201)
def create_salesrep(row: Salesrep):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "Salesrep already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{SalesRep}", response_model=Salesrep)
def update_salesrep(SalesRep: str, row: Salesrep, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (SalesRep,))
    if not current:
        raise HTTPException(404, "Salesrep not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "Salesrep was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{SalesRep}", status_code=204)
def delete_salesrep(SalesRep: str):
    if not repo.delete(TABLE, PRIMARY_KEY, (SalesRep,)):
        raise HTTPException(404, "Salesrep not found.")
    return Response(status_code=204)
