"""Purchasing / POLine API. Replaces the ABL programs
purchasing/po_line_maint.p, po_line_browse.w, po_line_val.p and si_po_line.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.po_line import POLine, POLinePage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/purchasing/po-lines", tags=["POLine"])
TABLE = "POLine"


@router.get("", response_model=POLinePage)
def list_po_line(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH POLine NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["POLineStatus"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{PONum}/{Linenum}", response_model=POLine)
def get_po_line(PONum: int, Linenum: int):
    row = repo.get(TABLE, PRIMARY_KEY, (PONum, Linenum,))
    if not row:
        raise HTTPException(404, "POLine not found.")
    return row


def _check_references(row: POLine) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    if row.Itemnum is not None and not repo.exists("Item", "Itemnum", row.Itemnum):
        raise HTTPException(422, "Item must be on file")
    if row.PONum is not None and not repo.exists("PurchaseOrder", "PONum", row.PONum):
        raise HTTPException(422, "Purchase order must exist.")


@router.post("", response_model=POLine, status_code=201)
def create_po_line(row: POLine):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "POLine already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{PONum}/{Linenum}", response_model=POLine)
def update_po_line(PONum: int, Linenum: int, row: POLine, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (PONum, Linenum,))
    if not current:
        raise HTTPException(404, "POLine not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "POLine was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{PONum}/{Linenum}", status_code=204)
def delete_po_line(PONum: int, Linenum: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (PONum, Linenum,)):
        raise HTTPException(404, "POLine not found.")
    return Response(status_code=204)
