"""Benefits models. Generated from the sports2000 schema: The benefits table contains employee benefits.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class Benefits(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    EmpNum: int = Field(..., ge=0, le=9999999999, description="Emp No. Please enter the Emp Number")
    HealthCare: str | None = Field(None, max_length=8, description="Health Care. Please enter the Health Care field.")
    LifeInsurance: int | None = Field(None, ge=0, le=99999999, description="Life Insurance. Please enter the Life Insurance field.")
    Pension401K: int | None = Field(None, ge=0, le=99999, description="Pension401K. Please enter the 401K field.")
    StockPurchase: int | None = Field(None, ge=0, le=99999, description="Stock Purchase. Please enter the Stock Purchase field.")
    MedicalSpending: int | None = Field(None, ge=0, le=99999, description="Medical Spending. Please enter the Medical Spending field.")
    DependentCare: int | None = Field(None, ge=0, le=99999, description="Dependent Care. Please enter the dependent care field.")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class BenefitsPage(BaseModel):
    items: list[Benefits]
    total: int


# Primary key: EmpNum
PRIMARY_KEY = ["EmpNum"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {"EmpNum":"Employee.EmpNum"}
