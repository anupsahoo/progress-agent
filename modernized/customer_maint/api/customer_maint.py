"""Customer Maintenance API — modernized from sports/customer_maint.p.

R1/R2 lookup · R3/R4 update · R5/R6 optimistic concurrency replaces EXCLUSIVE-LOCK/RELEASE.
"""
from hashlib import sha1
from fastapi import APIRouter, Header, HTTPException, Response
from pydantic import BaseModel, Field

router = APIRouter(prefix="/customers", tags=["customer_maint"])


class CustomerUpdate(BaseModel):
    name: str = Field(max_length=30)
    address: str = Field(default="", max_length=35)
    city: str = Field(default="", max_length=25)
    state: str = Field(default="", max_length=20)
    postalCode: str = Field(default="", max_length=10)
    phone: str = Field(default="", max_length=20)


class Customer(CustomerUpdate):
    custNum: int


# Data access stays on the OpenEdge DB in production; in-memory seed for tests.
DB: dict[int, Customer] = {
    1: Customer(custNum=1, name="Lift Tours", address="276 North Drive", city="Burlington", state="MA", postalCode="01730", phone="(617) 450-0086"),
    3: Customer(custNum=3, name="Hoops", address="Suite 415, 40 Grove St.", city="Atlanta", state="GA", postalCode="02112", phone="(617) 355-1557"),
}


def etag(c: Customer) -> str:
    return '"' + sha1(c.model_dump_json().encode()).hexdigest()[:16] + '"'


@router.get("/{cust_num}", response_model=Customer)
def get_customer(cust_num: int, response: Response) -> Customer:
    c = DB.get(cust_num)
    if c is None:
        raise HTTPException(404, "Customer not found.")
    response.headers["ETag"] = etag(c)
    return c


@router.put("/{cust_num}")
def update_customer(cust_num: int, body: CustomerUpdate, if_match: str | None = Header(default=None)) -> dict:
    c = DB.get(cust_num)
    if c is None:
        raise HTTPException(404, "Customer not found.")
    if if_match is not None and if_match != etag(c):
        raise HTTPException(409, "Record changed by another user.")
    DB[cust_num] = Customer(custNum=cust_num, **body.model_dump())
    return {"message": "Record updated successfully."}
