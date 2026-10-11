"""Warehouse models. Generated from the sports2000 schema: The warehouse table contains warehouse information including warehouse name and address.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class Warehouse(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    WarehouseNum: int = Field(..., gt=0, le=9999999999, description="Warehouse Num. Please enter the Warehouse Number.")
    WarehouseName: str | None = Field(None, max_length=30, description="Warehouse Name. Please enter a warehouse name.")
    Country: str | None = Field(None, max_length=20, description="Country. Please enter a country.")
    Address: str | None = Field(None, max_length=35, description="Address. Please enter an address.")
    Address2: str | None = Field(None, max_length=35, description="Address2. Please enter an address.")
    City: str | None = Field(None, max_length=25, description="City. Please enter a city.")
    State: str | None = Field(None, max_length=20, description="State. Please enter standard state abbreviation.")
    PostalCode: str | None = Field(None, max_length=10, description="Postal Code. Please enter the appropriate Postal Code.")
    Phone: str | None = Field(None, max_length=20, description="Phone. Please enter a phone.")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class WarehousePage(BaseModel):
    items: list[Warehouse]
    total: int


# Primary key: WarehouseNum
PRIMARY_KEY = ["WarehouseNum"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {}
