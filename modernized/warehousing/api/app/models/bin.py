"""Bin models. Generated from the sports2000 schema: The bin table is used to represent the bins in each warehouse that contain items.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class Bin(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    WarehouseNum: int | None = Field(None, ge=0, le=9999999999, description="Warehouse Num. Please Enter the Warehouse Number.")
    Itemnum: int | None = Field(None, ge=0, le=9999999999, description="Item Num. Please enter an item number.")
    Qty: int | None = Field(None, ge=-99999, le=99999, description="Qty. Please enter a quantity.")
    BinNum: int = Field(..., ge=0, le=9999999999, description="Bin Num. Please enter a bin number")
    BinName: str | None = Field(None, max_length=30, description="Bin Name. Please enter a bin name")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class BinPage(BaseModel):
    items: list[Bin]
    total: int


# Primary key: BinNum
PRIMARY_KEY = ["BinNum"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {"WarehouseNum":"Warehouse.WarehouseNum","Itemnum":"Item.Itemnum"}
