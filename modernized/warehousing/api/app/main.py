"""Warehousing service. Run: uvicorn app.main:app --reload"""
from fastapi import FastAPI

from .routers import warehouse
from .routers import bin

app = FastAPI(title="Sports2000 Warehousing", version="1.0.0")
app.include_router(warehouse.router)
app.include_router(bin.router)


@app.get("/health")
def health():
    return {"status": "ok", "module": "warehousing"}
