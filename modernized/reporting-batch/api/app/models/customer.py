"""Customer models. Generated from the sports2000 schema: The customer table contains customer information including balance and address.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class Customer(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    CustNum: int = Field(..., gt=0, le=99999, description="Cust Num. Please enter a customer number.")
    Country: str | None = Field(None, max_length=20, description="Country. Please enter a country.")
    Name: str | None = Field(None, max_length=30, description="Name. Please enter a name.")
    Address: str | None = Field(None, max_length=35, description="Address. Please enter an address.")
    Address2: str | None = Field(None, max_length=35, description="Address2. Please enter an address.")
    City: str | None = Field(None, max_length=25, description="City. Please enter a city.")
    State: str | None = Field(None, max_length=20, description="State. Please enter standard state abbreviation.")
    PostalCode: str | None = Field(None, max_length=10, description="Postal Code. Please enter the appropriate Postal Code.")
    Contact: str | None = Field(None, max_length=30, description="Contact. Please enter a contact.")
    Phone: str | None = Field(None, max_length=20, description="Phone. Please enter a phone number")
    SalesRep: str | None = Field(None, max_length=4, description="Sales Rep. Please Enter a Sales Rep.")
    CreditLimit: Decimal | None = Field(None, ge=0, le=9999999, decimal_places=2, description="Credit Limit. Please enter a Credit Limit.")
    Balance: Decimal | None = Field(None, ge=-9999999.99, le=9999999.99, decimal_places=2, description="Balance. Please enter a balance.")
    Terms: str | None = Field(None, max_length=20, description="Terms. Please enter terms")
    Discount: int | None = Field(None, ge=0, le=999, description="Discount. Please enter a percentage from 0 to 100.")
    Comments: str | None = Field(None, max_length=80, description="Comments. Please enter comments.")
    Fax: str | None = Field(None, max_length=20, description="Fax. Please enter a fax number.")
    EmailAddress: str | None = Field(None, max_length=50, description="Email. Please enter an full Internet Email Address.")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class CustomerPage(BaseModel):
    items: list[Customer]
    total: int


# Primary key: CustNum
PRIMARY_KEY = ["CustNum"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {"SalesRep":"Salesrep.SalesRep"}
