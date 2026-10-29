"""Order models. Generated from the sports2000 schema: The order table contains order header information.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class Order(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    Ordernum: int = Field(..., gt=0, le=9999999999, description="Order Num. Please enter an order number.")
    CustNum: int | None = Field(None, ge=0, le=99999, description="Cust Num. Please enter an existing customer number.")
    OrderDate: date | None = Field(None, description="Ordered. Please enter the date of order.")
    ShipDate: date | None = Field(None, description="Shipped. Please enter the ship date.")
    PromiseDate: date | None = Field(None, description="Promised. Please enter the Promise Date.")
    Carrier: str | None = Field(None, max_length=25, description="Carrier. Please enter the carrier.")
    Instructions: str | None = Field(None, max_length=50, description="Instructions. Please enter Instructions")
    PO: str | None = Field(None, max_length=20, description="PO. Please enter the PO.")
    Terms: str | None = Field(None, max_length=20, description="Terms. Please enter the terms.")
    SalesRep: str | None = Field(None, max_length=4, description="Sales Rep. Please enter the Sales Rep.")
    BillToID: int | None = Field(None, ge=0, le=9999999999, description="Bill To ID. Please enter the BillTo ID.")
    ShipToID: int | None = Field(None, ge=0, le=9999999999, description="Ship To ID. Please enter the ShipToID.")
    OrderStatus: str | None = Field(None, max_length=20, description="Order Status. Please enter the Order Status.")
    WarehouseNum: int | None = Field(None, ge=0, le=9999999999, description="Warehouse Num. Please enter the Warehouse Number.")
    Creditcard: str | None = Field(None, max_length=20, description="Credit Card. Please enter the credit card.")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class OrderPage(BaseModel):
    items: list[Order]
    total: int


# Primary key: Ordernum
PRIMARY_KEY = ["Ordernum"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {"CustNum":"Customer.CustNum","WarehouseNum":"Warehouse.WarehouseNum"}
