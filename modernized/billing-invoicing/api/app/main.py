"""Billing & Invoicing service. Run: uvicorn app.main:app --reload"""
from fastapi import FastAPI

from .routers import invoice
from .routers import bill_to

app = FastAPI(title="Sports2000 Billing & Invoicing", version="1.0.0")
app.include_router(invoice.router)
app.include_router(bill_to.router)


@app.get("/health")
def health():
    return {"status": "ok", "module": "billing-invoicing"}
