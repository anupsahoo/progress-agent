"""Vacation models. Generated from the sports2000 schema: The vacation table keeps track of employee vacation time.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class Vacation(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    EmpNum: int = Field(..., ge=0, le=9999999999, description="Emp No. Please enter the Emp Num.")
    StartDate: date = Field(..., description="Start Date. Please enter the Start Date.")
    EndDate: date | None = Field(None, description="End Date. Please enter the End Date.")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class VacationPage(BaseModel):
    items: list[Vacation]
    total: int


# Primary key: EmpNum, StartDate
PRIMARY_KEY = ["EmpNum","StartDate"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {}
