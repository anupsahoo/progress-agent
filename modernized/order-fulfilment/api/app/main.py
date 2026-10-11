"""Order Fulfilment service. Run: uvicorn app.main:app --reload"""
from fastapi import FastAPI

from .routers import ship_to

app = FastAPI(title="Sports2000 Order Fulfilment", version="1.0.0")
app.include_router(ship_to.router)


@app.get("/health")
def health():
    return {"status": "ok", "module": "order-fulfilment"}
