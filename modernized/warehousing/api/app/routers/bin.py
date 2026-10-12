"""Warehousing / Bin API. Replaces the ABL programs
warehousing/bin_maint.p, bin_browse.w, bin_val.p and si_bin.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.bin import Bin, BinPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/warehousing/bins", tags=["Bin"])
TABLE = "Bin"


@router.get("", response_model=BinPage)
def list_bin(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH Bin NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["BinName"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{BinNum}", response_model=Bin)
def get_bin(BinNum: int):
    row = repo.get(TABLE, PRIMARY_KEY, (BinNum,))
    if not row:
        raise HTTPException(404, "Bin not found.")
    return row


def _check_references(row: Bin) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    if row.WarehouseNum is not None and not repo.exists("Warehouse", "WarehouseNum", row.WarehouseNum):
        raise HTTPException(422, "Warehouse must exist.")
    if row.Itemnum is not None and not repo.exists("Item", "Itemnum", row.Itemnum):
        raise HTTPException(422, "Item must be on file")


@router.post("", response_model=Bin, status_code=201)
def create_bin(row: Bin):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "Bin already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{BinNum}", response_model=Bin)
def update_bin(BinNum: int, row: Bin, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (BinNum,))
    if not current:
        raise HTTPException(404, "Bin not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "Bin was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{BinNum}", status_code=204)
def delete_bin(BinNum: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (BinNum,)):
        raise HTTPException(404, "Bin not found.")
    return Response(status_code=204)
