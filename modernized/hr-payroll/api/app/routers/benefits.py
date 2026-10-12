"""HR & Payroll / Benefits API. Replaces the ABL programs
hr-payroll/benefits_maint.p, benefits_browse.w, benefits_val.p and si_benefits.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.benefits import Benefits, BenefitsPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/hr-payroll/benefitses", tags=["Benefits"])
TABLE = "Benefits"


@router.get("", response_model=BenefitsPage)
def list_benefits(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH Benefits NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["HealthCare"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{EmpNum}", response_model=Benefits)
def get_benefits(EmpNum: int):
    row = repo.get(TABLE, PRIMARY_KEY, (EmpNum,))
    if not row:
        raise HTTPException(404, "Benefits not found.")
    return row


def _check_references(row: Benefits) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    if row.EmpNum is not None and not repo.exists("Employee", "EmpNum", row.EmpNum):
        raise HTTPException(422, "Employee must exist.")


@router.post("", response_model=Benefits, status_code=201)
def create_benefits(row: Benefits):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "Benefits already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{EmpNum}", response_model=Benefits)
def update_benefits(EmpNum: int, row: Benefits, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (EmpNum,))
    if not current:
        raise HTTPException(404, "Benefits not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "Benefits was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{EmpNum}", status_code=204)
def delete_benefits(EmpNum: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (EmpNum,)):
        raise HTTPException(404, "Benefits not found.")
    return Response(status_code=204)
