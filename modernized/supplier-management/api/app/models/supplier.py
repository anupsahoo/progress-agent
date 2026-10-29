"""Supplier models. Generated from the sports2000 schema: The supplier table contains a supplier's name, address and additional information pertaining to the supplier.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class Supplier(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    SupplierIDNum: int = Field(..., gt=0, le=9999999999, description="Supplier ID. Please enter a Supplier ID Number.")
    Name: str | None = Field(None, max_length=30, description="Name. Please enter the Supplier's Name.")
    Address: str | None = Field(None, max_length=35, description="Address. Please enter the Supplier Address.")
    Address2: str | None = Field(None, max_length=35, description="Address2. Please enter the Supplier Address 2.")
    City: str | None = Field(None, max_length=25, description="City. Please enter the Supplier City.")
    State: str | None = Field(None, max_length=20, description="State. Please enter standard state abbreviation.")
    PostalCode: str | None = Field(None, max_length=10, description="ZipCode. Please enter the appropriate Postal Code.")
    Country: str | None = Field(None, max_length=20, description="Country. Please enter a county.")
    Phone: str | None = Field(None, max_length=20, description="Phone. Please enter a phone number")
    Comments: str | None = Field(None, max_length=80, description="Comments. Please enter comments.")
    Password: str = Field(..., max_length=8, description="Password. Please enter a Password.")
    LoginDate: date | None = Field(None, description="Login Date. Please enter the Last Login Date.")
    ShipAmount: int | None = Field(None, ge=0, le=99999, description="Ship Amount. Please enter the Amount to Ship.")
    Discount: int | None = Field(None, ge=0, le=999, description="Discount. Please enter a percentage from 0 to 100.")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class SupplierPage(BaseModel):
    items: list[Supplier]
    total: int


# Primary key: SupplierIDNum
PRIMARY_KEY = ["SupplierIDNum"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {}
