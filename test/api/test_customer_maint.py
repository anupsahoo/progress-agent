import pytest
from fastapi.testclient import TestClient
from customer_maint import app

client = TestClient(app)

@pytest.fixture
def customer_data():
    return {
        "id": 1,
        "name": "John Doe",
        "email": "john@example.com"
    }

def test_get_customer_happy_path(customer_data):
    response = client.get(f"/customers/{customer_data['id']}")
    assert response.status_code == 200
    assert response.json() == customer_data


def test_get_customer_not_found():
    response = client.get("/customers/999")
    assert response.status_code == 404
    assert response.json() == {"detail": "Customer not found"}


def test_update_customer_happy_path(customer_data):
    updated_data = {"id": 1, "name": "John Updated", "email": "john.updated@example.com"}
    response = client.put(f"/customers/{customer_data['id']}", json=updated_data)
    assert response.status_code == 200
    assert response.json() == updated_data


def test_update_customer_not_found():
    response = client.put("/customers/999", json={"name": "Not Found"})
    assert response.status_code == 404
    assert response.json() == {"detail": "Customer not found"}


def test_delete_customer_happy_path(customer_data):
    response = client.delete(f"/customers/{customer_data['id']}")
    assert response.status_code == 200
    assert response.json() == {"detail": "Customer deleted"}


def test_delete_customer_not_found():
    response = client.delete("/customers/999")
    assert response.status_code == 404
    assert response.json() == {"detail": "Customer not found"}