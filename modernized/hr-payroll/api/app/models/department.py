"""Department models. Generated from the sports2000 schema: The department contains a master listing of departments.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class Department(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    DeptCode: str = Field(..., max_length=3, description="Dept Code. Please enter the Dept Code.")
    DeptName: str | None = Field(None, max_length=15, description="Dept Name. Please enter the Dept Name")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class DepartmentPage(BaseModel):
    items: list[Department]
    total: int


# Primary key: DeptCode
PRIMARY_KEY = ["DeptCode"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {}
