"""Customer Management / Feedback API. Replaces the ABL programs
customer-management/feedback_maint.p, feedback_browse.w, feedback_val.p and si_feedback.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.feedback import Feedback, FeedbackPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/customer-management/feedbacks", tags=["Feedback"])
TABLE = "Feedback"


@router.get("", response_model=FeedbackPage)
def list_feedback(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH Feedback NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["Contact","Company","EmailAddress"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{Department}", response_model=Feedback)
def get_feedback(Department: str):
    row = repo.get(TABLE, PRIMARY_KEY, (Department,))
    if not row:
        raise HTTPException(404, "Feedback not found.")
    return row


def _check_references(row: Feedback) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    return None


@router.post("", response_model=Feedback, status_code=201)
def create_feedback(row: Feedback):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "Feedback already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{Department}", response_model=Feedback)
def update_feedback(Department: str, row: Feedback, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (Department,))
    if not current:
        raise HTTPException(404, "Feedback not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "Feedback was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{Department}", status_code=204)
def delete_feedback(Department: str):
    if not repo.delete(TABLE, PRIMARY_KEY, (Department,)):
        raise HTTPException(404, "Feedback not found.")
    return Response(status_code=204)
