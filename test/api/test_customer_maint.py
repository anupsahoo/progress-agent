import pytest
from httpx import AsyncClient
from fastapi import FastAPI
from customer_maint import router

app = FastAPI()
app.include_router(router)

@pytest.fixture
async def client():
    async with AsyncClient(app=app, base_url='http://test') as client:
        yield client

@pytest.mark.asyncio
async def test_create_customer(client):
    response = await client.post('/customers/', json={'cust_num': 1, 'name': 'John Doe', 'address': '123 Elm St', 'city': 'Anytown', 'state': 'CA', 'postal_code': '12345', 'phone': '555-1234'})
    assert response.status_code == 200
    assert response.json()['name'] == 'John Doe'

@pytest.mark.asyncio
async def test_read_customer(client):
    await client.post('/customers/', json={'cust_num': 1, 'name': 'John Doe', 'address': '123 Elm St', 'city': 'Anytown', 'state': 'CA', 'postal_code': '12345', 'phone': '555-1234'})
    response = await client.get('/customers/1')
    assert response.status_code == 200
    assert response.json()['name'] == 'John Doe'

@pytest.mark.asyncio
async def test_update_customer(client):
    await client.post('/customers/', json={'cust_num': 1, 'name': 'John Doe', 'address': '123 Elm St', 'city': 'Anytown', 'state': 'CA', 'postal_code': '12345', 'phone': '555-1234'})
    response = await client.put('/customers/1', json={'cust_num': 1, 'name': 'Jane Doe', 'address': '456 Oak St', 'city': 'Othertown', 'state': 'NY', 'postal_code': '54321', 'phone': '555-5678'})
    assert response.status_code == 200
    assert response.json()['name'] == 'Jane Doe'

@pytest.mark.asyncio
async def test_delete_customer(client):
    await client.post('/customers/', json={'cust_num': 1, 'name': 'John Doe', 'address': '123 Elm St', 'city': 'Anytown', 'state': 'CA', 'postal_code': '12345', 'phone': '555-1234'})
    response = await client.delete('/customers/1')
    assert response.status_code == 200
    assert response.json()['name'] == 'John Doe'

@pytest.mark.asyncio
async def test_read_nonexistent_customer(client):
    response = await client.get('/customers/999')
    assert response.status_code == 404
