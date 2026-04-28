import pytest
from fastapi.testclient import TestClient
from customer_maint import app

client = TestClient(app)

@pytest.fixture
def customer_data():
    return {
        'CustNum': 1,
        'Name': 'John Doe',
        'Address': '123 Main St',
        'City': 'Anytown',
        'State': 'CA',
        'PostalCode': '12345',
        'Phone': '555-1234'
    }

def test_create_customer(customer_data):
    response = client.post('/customers/', json=customer_data)
    assert response.status_code == 200
    assert response.json() == customer_data


def test_read_customer(customer_data):
    client.post('/customers/', json=customer_data)
    response = client.get('/customers/1')
    assert response.status_code == 200
    assert response.json() == customer_data


def test_update_customer(customer_data):
    client.post('/customers/', json=customer_data)
    updated_data = customer_data.copy()
    updated_data['Name'] = 'Jane Doe'
    response = client.put('/customers/1', json=updated_data)
    assert response.status_code == 200
    assert response.json()['Name'] == 'Jane Doe'


def test_delete_customer(customer_data):
    client.post('/customers/', json=customer_data)
    response = client.delete('/customers/1')
    assert response.status_code == 200
    assert response.json() == customer_data


def test_read_nonexistent_customer():
    response = client.get('/customers/999')
    assert response.status_code == 404


def test_create_existing_customer(customer_data):
    client.post('/customers/', json=customer_data)
    response = client.post('/customers/', json=customer_data)
    assert response.status_code == 400
