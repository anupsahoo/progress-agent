"""Inventory service. Run: uvicorn app.main:app --reload"""
from fastapi import FastAPI

from .routers import item
from .routers import inventory_trans

app = FastAPI(title="Sports2000 Inventory", version="1.0.0")
app.include_router(item.router)
app.include_router(inventory_trans.router)


@app.get("/health")
def health():
    return {"status": "ok", "module": "inventory"}
