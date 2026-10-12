"""BillTo models. Generated from the sports2000 schema: The billto table contains bill to address information for an order.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class BillTo(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    CustNum: int = Field(..., ge=0, le=99999, description="Cust Num. Please enter the customer number.")
    BillToID: int = Field(..., ge=0, le=9999999999, description="BillToID. Please enter the BillTo ID")
    Name: str | None = Field(None, max_length=30, description="Name. Please enter the name.")
    Address: str | None = Field(None, max_length=35, description="Address. Please enter the address.")
    Address2: str | None = Field(None, max_length=35, description="Address2. Please enter the address2.")
    City: str | None = Field(None, max_length=25, description="City. Please enter the city")
    State: str | None = Field(None, max_length=20, description="State. Please enter standard state abbreviation.")
    PostalCode: str | None = Field(None, max_length=10, description="Postal Code. Please enter the appropriate postal code.")
    Contact: str | None = Field(None, max_length=30, description="Contact. Please enter the contact.")
    Phone: str | None = Field(None, max_length=20, description="Phone. Please enter the phone number.")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class BillToPage(BaseModel):
    items: list[BillTo]
    total: int


# Primary key: CustNum, BillToID
PRIMARY_KEY = ["CustNum","BillToID"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {"CustNum":"Customer.CustNum"}
