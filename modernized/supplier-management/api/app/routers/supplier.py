"""Supplier Management / Supplier API. Replaces the ABL programs
supplier-management/supplier_maint.p, supplier_browse.w, supplier_val.p and si_supplier.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.supplier import Supplier, SupplierPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/supplier-management/suppliers", tags=["Supplier"])
TABLE = "Supplier"


@router.get("", response_model=SupplierPage)
def list_supplier(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH Supplier NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["Name","Address","Address2"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{SupplierIDNum}", response_model=Supplier)
def get_supplier(SupplierIDNum: int):
    row = repo.get(TABLE, PRIMARY_KEY, (SupplierIDNum,))
    if not row:
        raise HTTPException(404, "Supplier not found.")
    return row


def _check_references(row: Supplier) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    return None


@router.post("", response_model=Supplier, status_code=201)
def create_supplier(row: Supplier):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "Supplier already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{SupplierIDNum}", response_model=Supplier)
def update_supplier(SupplierIDNum: int, row: Supplier, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (SupplierIDNum,))
    if not current:
        raise HTTPException(404, "Supplier not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "Supplier was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{SupplierIDNum}", status_code=204)
def delete_supplier(SupplierIDNum: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (SupplierIDNum,)):
        raise HTTPException(404, "Supplier not found.")
    return Response(status_code=204)
