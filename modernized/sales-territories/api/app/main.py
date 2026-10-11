"""Sales & Territories service. Run: uvicorn app.main:app --reload"""
from fastapi import FastAPI

from .routers import salesrep
from .routers import state
from .routers import local_default

app = FastAPI(title="Sports2000 Sales & Territories", version="1.0.0")
app.include_router(salesrep.router)
app.include_router(state.router)
app.include_router(local_default.router)


@app.get("/health")
def health():
    return {"status": "ok", "module": "sales-territories"}
