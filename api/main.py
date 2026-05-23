from fastapi import FastAPI
from .customer_maint import router as customer_maint_router

app = FastAPI(title='Progress Agent API')
app.include_router(customer_maint_router)
