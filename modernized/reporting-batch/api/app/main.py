"""Reporting & Batch service. Run: uvicorn app.main:app --reload"""
from fastapi import FastAPI

from .routers import customer
from .routers import order
from .routers import order_line

app = FastAPI(title="Sports2000 Reporting & Batch", version="1.0.0")
app.include_router(customer.router)
app.include_router(order.router)
app.include_router(order_line.router)


@app.get("/health")
def health():
    return {"status": "ok", "module": "reporting-batch"}
