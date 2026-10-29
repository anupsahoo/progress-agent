"""Purchasing / PurchaseOrder API. Replaces the ABL programs
purchasing/purchase_order_maint.p, purchase_order_browse.w, purchase_order_val.p and si_purchase_order.p.
"""
from __future__ import annotations

from fastapi import APIRouter, Header, HTTPException, Query, Response

from ..models.purchase_order import PurchaseOrder, PurchaseOrderPage, PRIMARY_KEY
from ..repository import repo

router = APIRouter(prefix="/api/purchasing/purchase-orders", tags=["PurchaseOrder"])
TABLE = "PurchaseOrder"


@router.get("", response_model=PurchaseOrderPage)
def list_purchase_order(q: str = "", limit: int = Query(50, ge=1, le=500), offset: int = Query(0, ge=0)):
    """FOR EACH PurchaseOrder NO-LOCK WHERE <search> BEGINS q."""
    rows = repo.list(TABLE)
    if q:
        ql = q.lower()
        rows = [r for r in rows if any(str(r.get(f) or "").lower().startswith(ql) for f in ["POStatus"])]
    return {"items": rows[offset:offset + limit], "total": len(rows)}


@router.get("/{PONum}", response_model=PurchaseOrder)
def get_purchase_order(PONum: int):
    row = repo.get(TABLE, PRIMARY_KEY, (PONum,))
    if not row:
        raise HTTPException(404, "PurchaseOrder not found.")
    return row


def _check_references(row: PurchaseOrder) -> None:
    """VALEXP CAN-FIND rules from the schema."""
    if row.SupplierIDNum is not None and not repo.exists("Supplier", "SupplierIDNum", row.SupplierIDNum):
        raise HTTPException(422, "Supplier must exist.")


@router.post("", response_model=PurchaseOrder, status_code=201)
def create_purchase_order(row: PurchaseOrder):
    if repo.get(TABLE, PRIMARY_KEY, tuple(getattr(row, k) for k in PRIMARY_KEY)):
        raise HTTPException(409, "PurchaseOrder already exists.")
    _check_references(row)
    return repo.insert(TABLE, row.model_dump(mode="json"))


@router.put("/{PONum}", response_model=PurchaseOrder)
def update_purchase_order(PONum: int, row: PurchaseOrder, if_match: int = Header(0, alias="If-Match")):
    """EXCLUSIVE-LOCK NO-WAIT becomes an optimistic version check."""
    current = repo.get(TABLE, PRIMARY_KEY, (PONum,))
    if not current:
        raise HTTPException(404, "PurchaseOrder not found.")
    if int(current.get("version", 0)) != int(if_match):
        raise HTTPException(409, "PurchaseOrder was changed by another user.")
    _check_references(row)
    data = row.model_dump(mode="json")
    data.update({k: current[k] for k in PRIMARY_KEY})
    return repo.update(TABLE, PRIMARY_KEY, data)


@router.delete("/{PONum}", status_code=204)
def delete_purchase_order(PONum: int):
    if not repo.delete(TABLE, PRIMARY_KEY, (PONum,)):
        raise HTTPException(404, "PurchaseOrder not found.")
    return Response(status_code=204)
