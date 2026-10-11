"""Credit Management / RefCall API. Replaces the ABL programs
credit-management/ref_call_maint.p, ref_call_browse.w, ref_call_val.p and si_ref_call.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.ref_call import RefCall, RefCallPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/credit-management/ref-calls", tags=["RefCall"])
TABLE = "RefCall"


@router.get("", response_model=RefCallPage)
def list_ref_call(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH RefCall NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["CallNum","SalesRep","Parent"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{CallNum}", response_model=RefCall)
def get_ref_call(CallNum: str):
    row = repo.get(TABLE, PRIMARY_KEY, (CallNum,))
    if not row:
        raise HTTPException(404, "RefCall not found.")
    return row


def _check_references(row: RefCall) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    return None


@router.post("", response_model=RefCall, status_code=201)
def create_ref_call(row: RefCall):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "RefCall already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{CallNum}", response_model=RefCall)
def update_ref_call(CallNum: str, row: RefCall, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (CallNum,))
    if not current:
        raise HTTPException(404, "RefCall not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "RefCall was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{CallNum}", status_code=204)
def delete_ref_call(CallNum: str):
    if not repo.delete(TABLE, PRIMARY_KEY, (CallNum,)):
        raise HTTPException(404, "RefCall not found.")
    return Response(status_code=204)
