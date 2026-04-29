from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import List, Optional

router = APIRouter()

# Pydantic model for Customer
class Customer(BaseModel):
    id: int
    name: str
    email: str

# In-memory database simulation
customers_db = {
    1: Customer(id=1, name="John Doe", email="john@example.com"),
    2: Customer(id=2, name="Jane Smith", email="jane@example.com")
}

@router.get("/customers/{id}", response_model=Customer)
async def get_customer(id: int):
    """Retrieve customer details by ID."""
    customer = customers_db.get(id)
    if not customer:
        raise HTTPException(status_code=404, detail="Customer not found")
    return customer

@router.put("/customers/{id}", response_model=Customer)
async def update_customer(id: int, customer: Customer):
    """Update customer details by ID."""
    if id not in customers_db:
        raise HTTPException(status_code=404, detail="Customer not found")
    customers_db[id] = customer
    return customer

@router.get("/customers", response_model=List[Customer])
async def list_customers():
    """List all customers."""
    return list(customers_db.values())

@router.delete("/customers/{id}")
async def delete_customer(id: int):
    """Delete customer by ID."""
    if id not in customers_db:
        raise HTTPException(status_code=404, detail="Customer not found")
    del customers_db[id]
    return {"detail": "Customer deleted"}