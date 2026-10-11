"""Salesrep models. Generated from the sports2000 schema: The salesrep table contains sales representative information

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class Salesrep(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    SalesRep: str = Field(..., max_length=4, description="Sales Rep. Please enter the Sales Rep.")
    RepName: str | None = Field(None, max_length=30, description="Rep Name. Please enter the Name of the Salesperson.")
    Region: str | None = Field(None, max_length=8, description="Region. Please enter the Sales Region covered by this salesman.")
    MonthQuota: list[int] | None = Field(None, min_length=12, max_length=12, description="Month Quota. Please enter the Month Quota.")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class SalesrepPage(BaseModel):
    items: list[Salesrep]
    total: int


# Primary key: SalesRep
PRIMARY_KEY = ["SalesRep"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {}
