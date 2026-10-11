"""SupplierItemXref models. Generated from the sports2000 schema: The supplieritemxref lists all of the items that are supplied by a particlar supplier.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class SupplierItemXref(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    SupplierIDNum: int = Field(..., ge=0, le=9999999999, description="Supplier ID. Please enter a Supplier ID")
    Itemnum: int = Field(..., ge=0, le=9999999999, description="Item #. Please enter an Item Number")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class SupplierItemXrefPage(BaseModel):
    items: list[SupplierItemXref]
    total: int


# Primary key: SupplierIDNum, Itemnum
PRIMARY_KEY = ["SupplierIDNum","Itemnum"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {"SupplierIDNum":"Supplier.SupplierIDNum","Itemnum":"Item.Itemnum"}
