"""Purchasing service. Run: uvicorn app.main:app --reload"""
from fastapi import FastAPI

from .routers import purchase_order
from .routers import po_line

app = FastAPI(title="Sports2000 Purchasing", version="1.0.0")
app.include_router(purchase_order.router)
app.include_router(po_line.router)


@app.get("/health")
def health():
    return {"status": "ok", "module": "purchasing"}
