"""Invoice models. Generated from the sports2000 schema: The invoice table contains transactions for the receivable module.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class Invoice(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    Invoicenum: int = Field(..., gt=0, le=9999999999, description="Invoice Num. Please enter an Invoice Number")
    CustNum: int | None = Field(None, ge=0, le=99999, description="Cust Num. Please enter a customer number.")
    InvoiceDate: date | None = Field(None, description="Invoice Date. Please enter an invoice date")
    Amount: Decimal | None = Field(None, ge=-99999.99, le=99999.99, decimal_places=2, description="Amount. Please enter total invoice amt including shipping and sales.")
    TotalPaid: Decimal | None = Field(None, ge=-99999.99, le=99999.99, decimal_places=2, description="Total Paid. Please enter Total Paid.")
    Adjustment: Decimal | None = Field(None, ge=-99999.99, le=99999.99, decimal_places=2, description="Adjustment. Please enter adjustment.")
    OrderNum: int | None = Field(None, ge=0, le=9999999999, description="Order Num. Please enter an order number.")
    ShipCharge: Decimal | None = Field(None, ge=-99999.99, le=99999.99, decimal_places=2, description="Ship Charge. Please enter a Ship Charge.")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class InvoicePage(BaseModel):
    items: list[Invoice]
    total: int


# Primary key: Invoicenum
PRIMARY_KEY = ["Invoicenum"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {"CustNum":"Customer.CustNum"}
