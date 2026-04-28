import pytest
from httpx import AsyncClient
from fastapi import FastAPI
from customer_maint import router

app = FastAPI()
app.include_router(router)

@pytest.fixture
async def client():
    async with AsyncClient(app=app, base_url="http://test") as client:
        yield client

@pytest.mark.asyncio
async def test_create_customer(client):
    response = await client.post("/customers/", json={"customer_number": "C001", "name": "John Doe", "email": "john@example.com", "phone": "1234567890"})
    assert response.status_code == 200
    assert response.json()["customer_number"] == "C001"

@pytest.mark.asyncio
async def test_find_customer(client):
    await client.post("/customers/", json={"customer_number": "C001", "name": "John Doe", "email": "john@example.com", "phone": "1234567890"})
    response = await client.get("/customers/C001")
    assert response.status_code == 200
    assert response.json()["name"] == "John Doe"

@pytest.mark.asyncio
async def test_update_customer(client):
    await client.post("/customers/", json={"customer_number": "C001", "name": "John Doe", "email": "john@example.com", "phone": "1234567890"})
    response = await client.put("/customers/C001", json={"customer_number": "C001", "name": "Jane Doe", "email": "jane@example.com", "phone": "0987654321"})
    assert response.status_code == 200
    assert response.json()["name"] == "Jane Doe"

@pytest.mark.asyncio
async def test_delete_customer(client):
    await client.post("/customers/", json={"customer_number": "C001", "name": "John Doe", "email": "john@example.com", "phone": "1234567890"})
    response = await client.delete("/customers/C001")
    assert response.status_code == 200
    assert response.json()["detail"] == "Customer deleted"

@pytest.mark.asyncio
async def test_find_nonexistent_customer(client):
    response = await client.get("/customers/C999")
    assert response.status_code == 404
