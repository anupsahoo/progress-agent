from fastapi import FastAPI, HTTPException, APIRouter
from pydantic import BaseModel

app = FastAPI()
router = APIRouter()

class Customer(BaseModel):
    CustNum: int
    Name: str
    Address: str
    City: str
    State: str
    PostalCode: str
    Phone: str

customers_db = {}  # Simulated database

@router.get('/customers/{id}', response_model=Customer)
async def get_customer(id: int):
    customer = customers_db.get(id)
    if not customer:
        raise HTTPException(status_code=404, detail="Customer not found")
    return customer

@router.put('/customers/{id}', response_model=Customer)
async def update_customer(id: int, customer: Customer):
    if id not in customers_db:
        raise HTTPException(status_code=404, detail="Customer not found")
    customers_db[id] = customer
    return customer

app.include_router(router)