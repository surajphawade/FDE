
from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_health_check():
    response = client.get("/health")

    assert response.status_code == 200

    data = response.json()

    assert data["service"] == "payment-service"
    assert data["status"] == "healthy"


def test_root_endpoint():
    response = client.get("/")

    assert response.status_code == 200
    assert data_contains_documentation(response.json())


def data_contains_documentation(data):
    return data["documentation"] == "/docs"


def test_successful_payment():
    payload = {
        "customer_id": "CUST001",
        "amount": 1500,
        "currency": "INR",
        "payment_method": "UPI"
    }

    response = client.post("/payments", json=payload)

    assert response.status_code == 200

    data = response.json()

    assert data["customer_id"] == "CUST001"
    assert data["amount"] == 1500
    assert data["status"] == "SUCCESS"
    assert "payment_id" in data


def test_payment_exceeds_transaction_limit():
    payload = {
        "customer_id": "CUST002",
        "amount": 60000,
        "currency": "INR",
        "payment_method": "UPI"
    }

    response = client.post("/payments", json=payload)

    assert response.status_code == 400
    assert "exceeds" in response.json()["detail"]


def test_negative_payment_amount():
    payload = {
        "customer_id": "CUST003",
        "amount": -100,
        "currency": "INR"
    }

    response = client.post("/payments", json=payload)

    assert response.status_code == 422


def test_invalid_currency():
    payload = {
        "customer_id": "CUST004",
        "amount": 1000,
        "currency": "USD"
    }

    response = client.post("/payments", json=payload)

    assert response.status_code == 422
