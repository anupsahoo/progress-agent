"""Employee models. Generated from the sports2000 schema: The employee table stores employee information including name and address

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class Employee(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    EmpNum: int = Field(..., ge=0, le=9999999999, description="Emp No. Please enter the Emp Num")
    LastName: str | None = Field(None, max_length=25, description="Last Name. Please enter the last name.")
    FirstName: str | None = Field(None, max_length=15, description="First Name. Please enter the First Name.")
    Address: str | None = Field(None, max_length=35, description="Address. Please enter the address")
    Address2: str | None = Field(None, max_length=35, description="Address2. Please enter the address.")
    City: str | None = Field(None, max_length=25, description="City. Please enter the city.")
    State: str | None = Field(None, max_length=20, description="State. Please enter a State.")
    PostalCode: str | None = Field(None, max_length=10, description="Postal Code. Please enter the Postal Code.")
    HomePhone: str | None = Field(None, max_length=20, description="Home Phone. Please enter the home phone.")
    WorkPhone: str | None = Field(None, max_length=20, description="Work Phone. Please enter work phone number")
    DeptCode: str | None = Field(None, max_length=3, description="Dept Code. Please enter the Dept Code")
    Position: str | None = Field(None, max_length=20, description="Position. Please enter the position.")
    Birthdate: date | None = Field(None, description="Birthdate. Please enter the birth date.")
    StartDate: date | None = Field(None, description="Start Date. Please enter a Start Date")
    VacationDaysLeft: int | None = Field(None, ge=0, le=999, description="Vacation Days Left. Please enter Vacation Days Left.")
    SickDaysLeft: int | None = Field(None, ge=0, le=999, description="Sick Days Left. Please enter Sick Days Left.")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class EmployeePage(BaseModel):
    items: list[Employee]
    total: int


# Primary key: EmpNum
PRIMARY_KEY = ["EmpNum"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {"DeptCode":"Department.DeptCode"}
