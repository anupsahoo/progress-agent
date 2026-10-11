"""POLine models. Generated from the sports2000 schema: The poline table contains the PO detail information including the item and quantity on the PO.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class POLine(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    Linenum: int = Field(..., ge=0, le=999, description="Line Num. Please enter the Line Number")
    Itemnum: int | None = Field(None, ge=0, le=9999999999, description="Item Num. Please enter an item number.")
    Price: Decimal | None = Field(None, ge=-9999999.99, le=9999999.99, decimal_places=2, description="Price. Please enter the Price")
    Qty: int | None = Field(None, ge=-99999, le=99999, description="Qty. Please enter the quantity.")
    Discount: int | None = Field(None, ge=0, le=999, description="Discount. Please enter the discount.")
    ExtendedPrice: Decimal | None = Field(None, ge=-99999.99, le=99999.99, decimal_places=2, description="Extended Price. Please enter the Extended Price.")
    PONum: int = Field(..., ge=0, le=9999999999, description="Order Num. Please enter an order number.")
    POLineStatus: str | None = Field(None, max_length=20, description="PO Line Status. Please enter the PO status.")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class POLinePage(BaseModel):
    items: list[POLine]
    total: int


# Primary key: PONum, Linenum
PRIMARY_KEY = ["PONum","Linenum"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {"Itemnum":"Item.Itemnum","PONum":"PurchaseOrder.PONum"}
