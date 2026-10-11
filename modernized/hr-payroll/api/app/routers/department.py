"""HR & Payroll / Department API. Replaces the ABL programs
hr-payroll/department_maint.p, department_browse.w, department_val.p and si_department.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.department import Department, DepartmentPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/hr-payroll/departments", tags=["Department"])
TABLE = "Department"


@router.get("", response_model=DepartmentPage)
def list_department(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH Department NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["DeptCode","DeptName"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{DeptCode}", response_model=Department)
def get_department(DeptCode: str):
    row = repo.get(TABLE, PRIMARY_KEY, (DeptCode,))
    if not row:
        raise HTTPException(404, "Department not found.")
    return row


def _check_references(row: Department) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    return None


@router.post("", response_model=Department, status_code=201)
def create_department(row: Department):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "Department already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{DeptCode}", response_model=Department)
def update_department(DeptCode: str, row: Department, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (DeptCode,))
    if not current:
        raise HTTPException(404, "Department not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "Department was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{DeptCode}", status_code=204)
def delete_department(DeptCode: str):
    if not repo.delete(TABLE, PRIMARY_KEY, (DeptCode,)):
        raise HTTPException(404, "Department not found.")
    return Response(status_code=204)
