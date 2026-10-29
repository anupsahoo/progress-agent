"""TimeSheet models. Generated from the sports2000 schema: The timesheet table records time in and out, hours worked, and overtime.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class TimeSheet(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    EmpNum: int = Field(..., ge=0, le=9999999999, description="Emp No. Please enter the emp number")
    DayRecorded: date = Field(..., description="Day Recorded. Please enter the day recorded")
    TypeRecorded: str | None = Field(None, max_length=8, description="Type Recorded. Please enter Worked, Vacation, Sick, or  Holiday.")
    AMTimeIn: str | None = Field(None, max_length=5, description="AM Time In. Please enter AM Time in")
    AMTimeOut: str | None = Field(None, max_length=5, description="AM Time Out. Please enter AM Time Out")
    PMTimeIn: str | None = Field(None, max_length=5, description="PM Time In. Please enter PM Time In")
    PMTimeOut: str | None = Field(None, max_length=5, description="PM Time Out. Please enter PM Time Out")
    RegularHours: Decimal | None = Field(None, ge=0, le=999.99, decimal_places=2, description="Regular Hours. Please enter Regular Hours")
    OvertimeHours: Decimal | None = Field(None, ge=0, le=999.99, decimal_places=2, description="Overtime Hours. Please enter Overtime Hours")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class TimeSheetPage(BaseModel):
    items: list[TimeSheet]
    total: int


# Primary key: EmpNum, DayRecorded
PRIMARY_KEY = ["EmpNum","DayRecorded"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {"EmpNum":"Employee.EmpNum"}
