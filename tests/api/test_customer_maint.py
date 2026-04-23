import pytest
from httpx import AsyncClient
from main import app

@pytest.mark.asyncio
async def test_get_customer():
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get('/customers/1')
        assert response.status_code == 200
        assert response.json() == {'CustNum': 1, 'Name': 'John Doe', 'Address': '123 Main St', 'City': 'Anytown', 'State': 'CA', 'PostalCode': '12345', 'Phone': '555-5555'}

@pytest.mark.asyncio
async def test_get_customer_not_found():
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get('/customers/999')
        assert response.status_code == 404
        assert response.json() == {'detail': 'Customer not found'}