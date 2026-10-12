"""HR & Payroll / TimeSheet API. Replaces the ABL programs
hr-payroll/time_sheet_maint.p, time_sheet_browse.w, time_sheet_val.p and si_time_sheet.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.time_sheet import TimeSheet, TimeSheetPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/hr-payroll/time-sheets", tags=["TimeSheet"])
TABLE = "TimeSheet"


@router.get("", response_model=TimeSheetPage)
def list_time_sheet(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH TimeSheet NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["TypeRecorded","AMTimeIn","AMTimeOut"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{EmpNum}/{DayRecorded}", response_model=TimeSheet)
def get_time_sheet(EmpNum: int, DayRecorded: str):
    row = repo.get(TABLE, PRIMARY_KEY, (EmpNum, DayRecorded,))
    if not row:
        raise HTTPException(404, "TimeSheet not found.")
    return row


def _check_references(row: TimeSheet) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    if row.EmpNum is not None and not repo.exists("Employee", "EmpNum", row.EmpNum):
        raise HTTPException(422, "Employee must exist.")


@router.post("", response_model=TimeSheet, status_code=201)
def create_time_sheet(row: TimeSheet):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "TimeSheet already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{EmpNum}/{DayRecorded}", response_model=TimeSheet)
def update_time_sheet(EmpNum: int, DayRecorded: str, row: TimeSheet, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (EmpNum, DayRecorded,))
    if not current:
        raise HTTPException(404, "TimeSheet not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "TimeSheet was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{EmpNum}/{DayRecorded}", status_code=204)
def delete_time_sheet(EmpNum: int, DayRecorded: str):
    if not repo.delete(TABLE, PRIMARY_KEY, (EmpNum, DayRecorded,)):
        raise HTTPException(404, "TimeSheet not found.")
    return Response(status_code=204)
