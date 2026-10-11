"""HR & Payroll service. Run: uvicorn app.main:app --reload"""
from fastapi import FastAPI

from .routers import employee
from .routers import department
from .routers import benefits
from .routers import family
from .routers import time_sheet
from .routers import vacation

app = FastAPI(title="Sports2000 HR & Payroll", version="1.0.0")
app.include_router(employee.router)
app.include_router(department.router)
app.include_router(benefits.router)
app.include_router(family.router)
app.include_router(time_sheet.router)
app.include_router(vacation.router)


@app.get("/health")
def health():
    return {"status": "ok", "module": "hr-payroll"}
