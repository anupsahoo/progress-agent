import pytest
from httpx import AsyncClient
from fastapi import FastAPI
from customer_maint import router

app = FastAPI()
app.include_router(router)

@pytest.mark.asyncio
async def test_create_customer():
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.post('/customers/', json={
            'customer_number': 1,
            'customer_name': 'John Doe',
            'customer_address': '123 Elm St',
            'customer_city': 'Springfield',
            'customer_state': 'IL',
            'customer_postal_code': '62701',
            'customer_phone': '555-1234'
        })
    assert response.status_code == 200
    assert response.json()['customer_number'] == 1

@pytest.mark.asyncio
async def test_read_customer():
    async with AsyncClient(app=app, base_url="http://test") as client:
        await client.post('/customers/', json={
            'customer_number': 1,
            'customer_name': 'John Doe',
            'customer_address': '123 Elm St',
            'customer_city': 'Springfield',
            'customer_state': 'IL',
            'customer_postal_code': '62701',
            'customer_phone': '555-1234'
        })
        response = await client.get('/customers/1')
    assert response.status_code == 200
    assert response.json()['customer_name'] == 'John Doe'

@pytest.mark.asyncio
async def test_update_customer():
    async with AsyncClient(app=app, base_url="http://test") as client:
        await client.post('/customers/', json={
            'customer_number': 1,
            'customer_name': 'John Doe',
            'customer_address': '123 Elm St',
            'customer_city': 'Springfield',
            'customer_state': 'IL',
            'customer_postal_code': '62701',
            'customer_phone': '555-1234'
        })
        response = await client.put('/customers/1', json={
            'customer_number': 1,
            'customer_name': 'Jane Doe',
            'customer_address': '456 Oak St',
            'customer_city': 'Springfield',
            'customer_state': 'IL',
            'customer_postal_code': '62701',
            'customer_phone': '555-5678'
        })
    assert response.status_code == 200
    assert response.json()['customer_name'] == 'Jane Doe'

@pytest.mark.asyncio
async def test_delete_customer():
    async with AsyncClient(app=app, base_url="http://test") as client:
        await client.post('/customers/', json={
            'customer_number': 1,
            'customer_name': 'John Doe',
            'customer_address': '123 Elm St',
            'customer_city': 'Springfield',
            'customer_state': 'IL',
            'customer_postal_code': '62701',
            'customer_phone': '555-1234'
        })
        response = await client.delete('/customers/1')
    assert response.status_code == 200
    assert response.json()['customer_number'] == 1

@pytest.mark.asyncio
async def test_not_found():
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get('/customers/999')
    assert response.status_code == 404
