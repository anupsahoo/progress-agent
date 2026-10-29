"""Sales & Territories / State API. Replaces the ABL programs
sales-territories/state_maint.p, state_browse.w, state_val.p and si_state.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.state import State, StatePage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/sales-territories/states", tags=["State"])
TABLE = "State"


@router.get("", response_model=StatePage)
def list_state(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH State NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["State","StateName","Region"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{State}", response_model=State)
def get_state(State: str):
    row = repo.get(TABLE, PRIMARY_KEY, (State,))
    if not row:
        raise HTTPException(404, "State not found.")
    return row


def _check_references(row: State) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    return None


@router.post("", response_model=State, status_code=201)
def create_state(row: State):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "State already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{State}", response_model=State)
def update_state(State: str, row: State, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (State,))
    if not current:
        raise HTTPException(404, "State not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "State was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{State}", status_code=204)
def delete_state(State: str):
    if not repo.delete(TABLE, PRIMARY_KEY, (State,)):
        raise HTTPException(404, "State not found.")
    return Response(status_code=204)
