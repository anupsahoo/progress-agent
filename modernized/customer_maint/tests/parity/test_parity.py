"""Behavioural parity: legacy transactions recorded from customer_maint.p, replayed against the new API.
Any mismatch fails CI and blocks the pull request."""
import json
from pathlib import Path
import pytest
from fastapi import FastAPI
from fastapi.testclient import TestClient
from modernized.customer_maint.api.customer_maint import router

app = FastAPI(); app.include_router(router)
client = TestClient(app)
CASES = json.loads((Path(__file__).parent / "parity_cases.json").read_text())


def modern_output(case: dict) -> str:
    if case["op"] == "GET":
        r = client.get(f"/customers/{case['custNum']}")
        return f"FOUND {r.json()['name']}" if r.status_code == 200 else r.json()["detail"]
    current = client.get(f"/customers/{case['custNum']}")
    if current.status_code == 404:
        return "Customer not found."
    body = {**current.json(), **case["change"]}; body.pop("custNum")
    r = client.put(f"/customers/{case['custNum']}", json=body, headers={"If-Match": current.headers["ETag"]})
    return r.json().get("message") or r.json().get("detail")


@pytest.mark.parametrize("case", CASES, ids=[c["name"] for c in CASES])
def test_parity(case):
    assert modern_output(case) == case["legacy_output"]
