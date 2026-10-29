"""Customer Management service. Run: uvicorn app.main:app --reload"""
from fastapi import FastAPI

from .routers import customer
from .routers import feedback

app = FastAPI(title="Sports2000 Customer Management", version="1.0.0")
app.include_router(customer.router)
app.include_router(feedback.router)


@app.get("/health")
def health():
    return {"status": "ok", "module": "customer-management"}
