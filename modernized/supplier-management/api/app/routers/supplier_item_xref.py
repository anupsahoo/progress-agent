"""Supplier Management / SupplierItemXref API. Replaces the ABL programs
supplier-management/supplier_item_xref_maint.p, supplier_item_xref_browse.w, supplier_item_xref_val.p and si_supplier_item_xref.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.supplier_item_xref import SupplierItemXref, SupplierItemXrefPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/supplier-management/supplier-item-xrefs", tags=["SupplierItemXref"])
TABLE = "SupplierItemXref"


@router.get("", response_model=SupplierItemXrefPage)
def list_supplier_item_xref(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH SupplierItemXref NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in [])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{SupplierIDNum}/{Itemnum}", response_model=SupplierItemXref)
def get_supplier_item_xref(SupplierIDNum: int, Itemnum: int):
    row = repo.get(TABLE, PRIMARY_KEY, (SupplierIDNum, Itemnum,))
    if not row:
        raise HTTPException(404, "SupplierItemXref not found.")
    return row


def _check_references(row: SupplierItemXref) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    if row.SupplierIDNum is not None and not repo.exists("Supplier", "SupplierIDNum", row.SupplierIDNum):
        raise HTTPException(422, "Supplier must exist.")
    if row.Itemnum is not None and not repo.exists("Item", "Itemnum", row.Itemnum):
        raise HTTPException(422, "Item must be on file.")


@router.post("", response_model=SupplierItemXref, status_code=201)
def create_supplier_item_xref(row: SupplierItemXref):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "SupplierItemXref already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{SupplierIDNum}/{Itemnum}", response_model=SupplierItemXref)
def update_supplier_item_xref(SupplierIDNum: int, Itemnum: int, row: SupplierItemXref, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (SupplierIDNum, Itemnum,))
    if not current:
        raise HTTPException(404, "SupplierItemXref not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "SupplierItemXref was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{SupplierIDNum}/{Itemnum}", status_code=204)
def delete_supplier_item_xref(SupplierIDNum: int, Itemnum: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (SupplierIDNum, Itemnum,)):
        raise HTTPException(404, "SupplierItemXref not found.")
    return Response(status_code=204)
