"""Credit Management service. Run: uvicorn app.main:app --reload"""
from fastapi import FastAPI

from .routers import ref_call

app = FastAPI(title="Sports2000 Credit Management", version="1.0.0")
app.include_router(ref_call.router)


@app.get("/health")
def health():
    return {"status": "ok", "module": "credit-management"}
