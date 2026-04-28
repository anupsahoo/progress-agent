from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import List, Optional

router = APIRouter()

class Customer(BaseModel):
    customer_number: str
    name: str
    email: str
    phone: str

# Simulated database
customers_db = {}  # In-memory database for demonstration

@router.post("/customers/", response_model=Customer)
async def create_customer(customer: Customer):
    if customer.customer_number in customers_db:
        raise HTTPException(status_code=400, detail="Customer already exists")
    customers_db[customer.customer_number] = customer
    return customer

@router.get("/customers/{customer_number}", response_model=Customer)
async def find_customer(customer_number: str):
    customer = customers_db.get(customer_number)
    if not customer:
        raise HTTPException(status_code=404, detail="Customer not found")
    return customer

@router.put("/customers/{customer_number}", response_model=Customer)
async def update_customer(customer_number: str, customer: Customer):
    if customer_number not in customers_db:
        raise HTTPException(status_code=404, detail="Customer not found")
    customers_db[customer_number] = customer
    return customer

@router.delete("/customers/{customer_number}")
async def delete_customer(customer_number: str):
    if customer_number not in customers_db:
        raise HTTPException(status_code=404, detail="Customer not found")
    del customers_db[customer_number]
    return {"detail": "Customer deleted"}

@router.get("/customers/", response_model=List[Customer])
async def list_customers():
    return list(customers_db.values())
