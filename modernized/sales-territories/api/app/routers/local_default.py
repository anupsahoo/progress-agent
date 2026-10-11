"""Sales & Territories / LocalDefault API. Replaces the ABL programs
sales-territories/local_default_maint.p, local_default_browse.w, local_default_val.p and si_local_default.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.local_default import LocalDefault, LocalDefaultPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/sales-territories/local-defaults", tags=["LocalDefault"])
TABLE = "LocalDefault"


@router.get("", response_model=LocalDefaultPage)
def list_local_default(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH LocalDefault NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["Country","Region1Label","Region2Label"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{LocalDefNum}", response_model=LocalDefault)
def get_local_default(LocalDefNum: int):
    row = repo.get(TABLE, PRIMARY_KEY, (LocalDefNum,))
    if not row:
        raise HTTPException(404, "LocalDefault not found.")
    return row


def _check_references(row: LocalDefault) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    return None


@router.post("", response_model=LocalDefault, status_code=201)
def create_local_default(row: LocalDefault):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "LocalDefault already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{LocalDefNum}", response_model=LocalDefault)
def update_local_default(LocalDefNum: int, row: LocalDefault, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (LocalDefNum,))
    if not current:
        raise HTTPException(404, "LocalDefault not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "LocalDefault was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{LocalDefNum}", status_code=204)
def delete_local_default(LocalDefNum: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (LocalDefNum,)):
        raise HTTPException(404, "LocalDefault not found.")
    return Response(status_code=204)
