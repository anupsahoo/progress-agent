from fastapi import FastAPI
from fastapi.testclient import TestClient
from modernized.customer_maint.api.customer_maint import router

app = FastAPI(); app.include_router(router)
client = TestClient(app)


def test_r1_lookup_existing():
    r = client.get("/customers/3")
    assert r.status_code == 200 and r.json()["name"] == "Hoops" and r.headers["ETag"]


def test_r2_not_found_message_matches_legacy():
    r = client.get("/customers/99999")
    assert r.status_code == 404 and r.json()["detail"] == "Customer not found."


def test_r4_update_message_matches_legacy():
    tag = client.get("/customers/1").headers["ETag"]
    body = {**client.get("/customers/1").json(), "city": "Boston"}; body.pop("custNum")
    r = client.put("/customers/1", json=body, headers={"If-Match": tag})
    assert r.json()["message"] == "Record updated successfully."


def test_r5_stale_update_is_rejected():
    body = {**client.get("/customers/3").json()}; body.pop("custNum")
    r = client.put("/customers/3", json=body, headers={"If-Match": '"stale"'})
    assert r.status_code == 409


def test_name_longer_than_legacy_format_is_rejected():
    r = client.put("/customers/3", json={"name": "x" * 31})
    assert r.status_code == 422
