from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import List, Optional

router = APIRouter()

class Customer(BaseModel):
    customer_number: int
    customer_name: str
    customer_address: str
    customer_city: str
    customer_state: str
    customer_postal_code: str
    customer_phone: str

# In-memory database simulation
customers_db = {}  # customer_number -> Customer

@router.post('/customers/', response_model=Customer)
async def create_customer(customer: Customer):
    if customer.customer_number in customers_db:
        raise HTTPException(status_code=400, detail="Customer already exists")
    customers_db[customer.customer_number] = customer
    return customer

@router.get('/customers/{customer_number}', response_model=Customer)
async def read_customer(customer_number: int):
    customer = customers_db.get(customer_number)
    if not customer:
        raise HTTPException(status_code=404, detail="Customer not found")
    return customer

@router.put('/customers/{customer_number}', response_model=Customer)
async def update_customer(customer_number: int, customer: Customer):
    if customer_number not in customers_db:
        raise HTTPException(status_code=404, detail="Customer not found")
    customers_db[customer_number] = customer
    return customer

@router.delete('/customers/{customer_number}', response_model=Customer)
async def delete_customer(customer_number: int):
    if customer_number not in customers_db:
        raise HTTPException(status_code=404, detail="Customer not found")
    return customers_db.pop(customer_number)

@router.get('/customers/', response_model=List[Customer])
async def list_customers():
    return list(customers_db.values())
