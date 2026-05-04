import pytest
from httpx import AsyncClient
from fastapi import FastAPI
from customer_maint import router

app = FastAPI()
app.include_router(router)

@pytest.mark.asyncio
async def test_get_customer_happy_path():
    async with AsyncClient(app=app, base_url='http://test') as client:
        response = await client.get('/customers/1')
    assert response.status_code == 200
    assert response.json() == {'id': 1, 'name': 'John Doe', 'email': 'john@example.com'}

@pytest.mark.asyncio
async def test_get_customer_not_found():
    async with AsyncClient(app=app, base_url='http://test') as client:
        response = await client.get('/customers/999')
    assert response.status_code == 404
    assert response.json() == {'detail': 'Customer not found'}

@pytest.mark.asyncio
async def test_update_customer_happy_path():
    async with AsyncClient(app=app, base_url='http://test') as client:
        response = await client.put('/customers/1', json={'id': 1, 'name': 'John Updated', 'email': 'john.updated@example.com'})
    assert response.status_code == 200
    assert response.json() == {'id': 1, 'name': 'John Updated', 'email': 'john.updated@example.com'}

@pytest.mark.asyncio
async def test_update_customer_not_found():
    async with AsyncClient(app=app, base_url='http://test') as client:
        response = await client.put('/customers/999', json={'id': 999, 'name': 'Nonexistent', 'email': 'nonexistent@example.com'})
    assert response.status_code == 404
    assert response.json() == {'detail': 'Customer not found'}
