"""Item models. Generated from the sports2000 schema: The item table provides a quick reference for items in stock and quantity on-hand.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class Item(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    Itemnum: int = Field(..., ge=0, le=9999999999, description="Item Num. Please enter the item  number .")
    ItemName: str | None = Field(None, max_length=25, description="Item Name. Please enter an item name.")
    Price: Decimal | None = Field(None, ge=-9999999.99, le=9999999.99, decimal_places=2, description="Price. Please enter a Price.")
    Onhand: int | None = Field(None, ge=-99999, le=99999, description="On Hand. Please enter On Hand Qty")
    Allocated: int | None = Field(None, ge=-99999, le=99999, description="Allocated. Please enter allocated")
    ReOrder: int | None = Field(None, ge=-99999, le=99999, description="Re Order. Please enter reorder qty")
    OnOrder: int | None = Field(None, ge=-99999, le=99999, description="On Order. Please enter On Order Qty")
    CatPage: int | None = Field(None, ge=0, le=999, description="Cat Page. Please enter a catalog page")
    CatDescription: str | None = Field(None, max_length=200, description="Cat-Description. Please enter a description.")
    Category1: str | None = Field(None, max_length=30, description="Category1. Please enter a category")
    Category2: str | None = Field(None, max_length=30, description="Category2. Please enter a category")
    Special: str | None = Field(None, max_length=8, description="Special. Please enter special information")
    Weight: Decimal | None = Field(None, ge=-99999.99, le=99999.99, decimal_places=2, description="Weight. Please enter weight.")
    Minqty: int | None = Field(None, ge=-99999, le=99999, description="Min Qty. Please enter a min qty")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class ItemPage(BaseModel):
    items: list[Item]
    total: int


# Primary key: Itemnum
PRIMARY_KEY = ["Itemnum"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {}
