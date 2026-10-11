"""OrderLine models. Generated from the sports2000 schema: The orderline table contains order detail information including item number and quantity ordered.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class OrderLine(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    Ordernum: int = Field(..., ge=0, le=9999999999, description="Order Num. Please enter and Order Number for this order line.")
    Linenum: int = Field(..., ge=0, le=999, description="Line Num. Please enter the line number")
    Itemnum: int | None = Field(None, ge=0, le=9999999999, description="Item Num. Please enter an item number.")
    Price: Decimal | None = Field(None, ge=-9999999.99, le=9999999.99, decimal_places=2, description="Price. Please enter the price")
    Qty: int | None = Field(None, ge=-99999, le=99999, description="Qty. Please enter the quantity.")
    Discount: int | None = Field(None, ge=0, le=999, description="Discount. Please enter a discount.")
    ExtendedPrice: Decimal | None = Field(None, ge=-999999.99, le=999999.99, decimal_places=2, description="Extended Price. Please enter the extended price")
    OrderLineStatus: str | None = Field(None, max_length=20, description="Order Line Status. Please enter the order line status.")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class OrderLinePage(BaseModel):
    items: list[OrderLine]
    total: int


# Primary key: Ordernum, Linenum
PRIMARY_KEY = ["Ordernum","Linenum"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {"Ordernum":"Order.Ordernum","Itemnum":"Item.Itemnum"}
