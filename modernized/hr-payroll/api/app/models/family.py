"""Family models. Generated from the sports2000 schema: The family table tracks an employee's family

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class Family(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    EmpNum: int = Field(..., ge=0, le=9999999999, description="Emp No. Please enter the Emp Num.")
    RelativeName: str = Field(..., max_length=15, description="Relative Name. Please enter the Relative Name")
    Relation: str | None = Field(None, max_length=15, description="Relation. Please enter Spouse or Child.")
    Birthdate: date | None = Field(None, description="Birthdate. Please enter a Birthdate")
    CoveredOnBenefits: bool | None = Field(None, description="Covered On Benefits. Please enter the Covered on Benefits field.")
    BenefitDate: date | None = Field(None, description="Benefit Date. Please enter the Date relative added to benefits.")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class FamilyPage(BaseModel):
    items: list[Family]
    total: int


# Primary key: EmpNum, RelativeName
PRIMARY_KEY = ["EmpNum","RelativeName"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {"EmpNum":"Employee.EmpNum"}
