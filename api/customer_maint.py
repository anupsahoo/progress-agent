from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import List, Optional

router = APIRouter()

class Customer(BaseModel):
    cust_num: int
    name: str
    address: str
    city: str
    state: str
    postal_code: str
    phone: str

# Simulated database
customers_db = {}  # In-memory database for demonstration

@router.post('/customers/', response_model=Customer)
async def create_customer(customer: Customer):
    if customer.cust_num in customers_db:
        raise HTTPException(status_code=400, detail="Customer already exists")
    customers_db[customer.cust_num] = customer
    return customer

@router.get('/customers/{cust_num}', response_model=Customer)
async def read_customer(cust_num: int):
    customer = customers_db.get(cust_num)
    if not customer:
        raise HTTPException(status_code=404, detail="Customer not found")
    return customer

@router.put('/customers/{cust_num}', response_model=Customer)
async def update_customer(cust_num: int, customer: Customer):
    if cust_num not in customers_db:
        raise HTTPException(status_code=404, detail="Customer not found")
    customers_db[cust_num] = customer
    return customer

@router.delete('/customers/{cust_num}', response_model=Customer)
async def delete_customer(cust_num: int):
    customer = customers_db.pop(cust_num, None)
    if not customer:
        raise HTTPException(status_code=404, detail="Customer not found")
    return customer

@router.get('/customers/', response_model=List[Customer])
async def list_customers():
    return list(customers_db.values())
