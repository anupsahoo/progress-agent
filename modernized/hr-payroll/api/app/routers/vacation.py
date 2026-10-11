"""HR & Payroll / Vacation API. Replaces the ABL programs
hr-payroll/vacation_maint.p, vacation_browse.w, vacation_val.p and si_vacation.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.vacation import Vacation, VacationPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/hr-payroll/vacations", tags=["Vacation"])
TABLE = "Vacation"


@router.get("", response_model=VacationPage)
def list_vacation(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH Vacation NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in [])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{EmpNum}/{StartDate}", response_model=Vacation)
def get_vacation(EmpNum: int, StartDate: str):
    row = repo.get(TABLE, PRIMARY_KEY, (EmpNum, StartDate,))
    if not row:
        raise HTTPException(404, "Vacation not found.")
    return row


def _check_references(row: Vacation) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    return None


@router.post("", response_model=Vacation, status_code=201)
def create_vacation(row: Vacation):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "Vacation already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{EmpNum}/{StartDate}", response_model=Vacation)
def update_vacation(EmpNum: int, StartDate: str, row: Vacation, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (EmpNum, StartDate,))
    if not current:
        raise HTTPException(404, "Vacation not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "Vacation was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{EmpNum}/{StartDate}", status_code=204)
def delete_vacation(EmpNum: int, StartDate: str):
    if not repo.delete(TABLE, PRIMARY_KEY, (EmpNum, StartDate,)):
        raise HTTPException(404, "Vacation not found.")
    return Response(status_code=204)
