"""Supplier Management service. Run: uvicorn app.main:app --reload"""
from fastapi import FastAPI

from .routers import supplier
from .routers import supplier_item_xref

app = FastAPI(title="Sports2000 Supplier Management", version="1.0.0")
app.include_router(supplier.router)
app.include_router(supplier_item_xref.router)


@app.get("/health")
def health():
    return {"status": "ok", "module": "supplier-management"}
