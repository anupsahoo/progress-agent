"""HR & Payroll / Employee API. Replaces the ABL programs
hr-payroll/employee_maint.p, employee_browse.w, employee_val.p and si_employee.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.employee import Employee, EmployeePage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/hr-payroll/employees", tags=["Employee"])
TABLE = "Employee"


@router.get("", response_model=EmployeePage)
def list_employee(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH Employee NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["LastName","FirstName","Address"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{EmpNum}", response_model=Employee)
def get_employee(EmpNum: int):
    row = repo.get(TABLE, PRIMARY_KEY, (EmpNum,))
    if not row:
        raise HTTPException(404, "Employee not found.")
    return row


def _check_references(row: Employee) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    if row.DeptCode is not None and not repo.exists("Department", "DeptCode", row.DeptCode):
        raise HTTPException(422, "Department must exist.")


@router.post("", response_model=Employee, status_code=201)
def create_employee(row: Employee):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "Employee already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{EmpNum}", response_model=Employee)
def update_employee(EmpNum: int, row: Employee, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (EmpNum,))
    if not current:
        raise HTTPException(404, "Employee not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "Employee was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{EmpNum}", status_code=204)
def delete_employee(EmpNum: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (EmpNum,)):
        raise HTTPException(404, "Employee not found.")
    return Response(status_code=204)
