"""InventoryTrans models. Generated from the sports2000 schema: The inventorytrans table contains information about the movement of inventory.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class InventoryTrans(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    InvTransNum: int = Field(..., ge=0, le=9999999999, description="Inventory Trans Num. Please enter an inventory trans number")
    WarehouseNum: int | None = Field(None, ge=0, le=9999999999, description="Warehouse Num. Please enter the Warehouse Number.")
    BinNum: int | None = Field(None, ge=0, le=9999999999, description="Bin Num. Please enter a bin number.")
    Qty: int | None = Field(None, ge=-99999, le=99999, description="Qty. Please enter the quantity.")
    Itemnum: int | None = Field(None, ge=0, le=9999999999, description="Item Num. Please enter an item number")
    TransDate: date | None = Field(None, description="Trans Date. Please enter the trans date.")
    InvType: str | None = Field(None, max_length=12, description="Type. Please enter the type.")
    PONum: int | None = Field(None, ge=0, le=9999999999, description="PO Num. Please enter a PO Number.")
    Ordernum: int | None = Field(None, ge=0, le=9999999999, description="Order Num. Please Enter an Order Number")
    Transtime: str | None = Field(None, max_length=5, description="Trans Time")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class InventoryTransPage(BaseModel):
    items: list[InventoryTrans]
    total: int


# Primary key: InvTransNum
PRIMARY_KEY = ["InvTransNum"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {"Itemnum":"Item.Itemnum"}
