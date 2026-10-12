"""RefCall models. Generated from the sports2000 schema: The refcall table contains information about a sale.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class RefCall(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    CallNum: str = Field(..., max_length=6, description="Call Num. Please enter the call number.")
    CustNum: int | None = Field(None, gt=0, le=99999, description="Cust Num. Please enter the customer number.")
    CallDate: date | None = Field(None, description="Call Date. Please enter the call date.")
    SalesRep: str | None = Field(None, max_length=4, description="Sales Rep. Please enter the sales rep.")
    Parent: str | None = Field(None, max_length=6, description="Parent. Please enter the parent.")
    Txt: str | None = Field(None, max_length=300, description="Txt. Please enter text")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class RefCallPage(BaseModel):
    items: list[RefCall]
    total: int


# Primary key: CallNum
PRIMARY_KEY = ["CallNum"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {}
