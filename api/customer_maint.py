from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import List, Optional

router = APIRouter()

class Customer(BaseModel):
    CustNum: int
    Name: str
    Address: str
    City: str
    State: str
    PostalCode: str
    Phone: str

# In-memory database simulation
customers_db = {}  # Simulating a database with a dictionary

@router.post('/customers/', response_model=Customer)
async def create_customer(customer: Customer):
    if customer.CustNum in customers_db:
        raise HTTPException(status_code=400, detail="Customer already exists")
    customers_db[customer.CustNum] = customer
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
    if cust_num not in customers_db:
        raise HTTPException(status_code=404, detail="Customer not found")
    return customers_db.pop(cust_num)

@router.get('/customers/', response_model=List[Customer])
async def list_customers():
    return list(customers_db.values())
