"""PurchaseOrder models. Generated from the sports2000 schema: The purchaseorder table contains information pertaining to the purchase order including: PO number and status.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class PurchaseOrder(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    PONum: int = Field(..., gt=0, le=9999999999, description="PO Num. Please Enter a PO Number.")
    DateEntered: date | None = Field(None, description="Date Entered. Please enter today's date.")
    SupplierIDNum: int | None = Field(None, ge=0, le=9999999999, description="Supplier ID. Please enter a  Supplier ID")
    ReceiveDate: date | None = Field(None, description="Date Received. Please enter the Receive Date")
    POStatus: str | None = Field(None, max_length=20, description="PO Status. Please enter the PO status.")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class PurchaseOrderPage(BaseModel):
    items: list[PurchaseOrder]
    total: int


# Primary key: PONum
PRIMARY_KEY = ["PONum"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {"SupplierIDNum":"Supplier.SupplierIDNum"}
