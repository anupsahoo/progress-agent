import pytest
from fastapi.testclient import TestClient
from customer_maint import app

client = TestClient(app)

@pytest.fixture
def customer_data():
    return {'id': 1, 'name': 'John Doe', 'email': 'john@example.com'}

def test_get_customer_success(customer_data):
    response = client.get('/customers/1')
    assert response.status_code == 200
    assert response.json() == customer_data


def test_get_customer_not_found():
    response = client.get('/customers/999')
    assert response.status_code == 404
    assert response.json() == {'detail': 'Customer not found'}


def test_update_customer_success(customer_data):
    update_data = {'id': 1, 'name': 'John Updated', 'email': 'john.updated@example.com'}
    response = client.put('/customers/1', json=update_data)
    assert response.status_code == 200
    assert response.json() == update_data


def test_update_customer_not_found():
    update_data = {'id': 999, 'name': 'Nonexistent', 'email': 'nonexistent@example.com'}
    response = client.put('/customers/999', json=update_data)
    assert response.status_code == 404
    assert response.json() == {'detail': 'Customer not found'}


def test_delete_customer_success():
    response = client.delete('/customers/1')
    assert response.status_code == 200
    assert response.json() == {'detail': 'Customer deleted'}


def test_delete_customer_not_found():
    response = client.delete('/customers/999')
    assert response.status_code == 404
    assert response.json() == {'detail': 'Customer not found'}