"""HR & Payroll / Family API. Replaces the ABL programs
hr-payroll/family_maint.p, family_browse.w, family_val.p and si_family.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.family import Family, FamilyPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/hr-payroll/families", tags=["Family"])
TABLE = "Family"


@router.get("", response_model=FamilyPage)
def list_family(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH Family NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["RelativeName","Relation"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{EmpNum}/{RelativeName}", response_model=Family)
def get_family(EmpNum: int, RelativeName: str):
    row = repo.get(TABLE, PRIMARY_KEY, (EmpNum, RelativeName,))
    if not row:
        raise HTTPException(404, "Family not found.")
    return row


def _check_references(row: Family) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    if row.EmpNum is not None and not repo.exists("Employee", "EmpNum", row.EmpNum):
        raise HTTPException(422, "Employee must exist.")


@router.post("", response_model=Family, status_code=201)
def create_family(row: Family):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "Family already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{EmpNum}/{RelativeName}", response_model=Family)
def update_family(EmpNum: int, RelativeName: str, row: Family, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (EmpNum, RelativeName,))
    if not current:
        raise HTTPException(404, "Family not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "Family was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{EmpNum}/{RelativeName}", status_code=204)
def delete_family(EmpNum: int, RelativeName: str):
    if not repo.delete(TABLE, PRIMARY_KEY, (EmpNum, RelativeName,)):
        raise HTTPException(404, "Family not found.")
    return Response(status_code=204)
