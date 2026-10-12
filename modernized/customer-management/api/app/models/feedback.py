"""Feedback models. Generated from the sports2000 schema: The feedback table allows customers to provide feedback about what they like and don't like.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class Feedback(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    Contact: str | None = Field(None, max_length=30, description="Contact Name. Please enter the contact")
    Company: str | None = Field(None, max_length=20, description="Company. Please enter the company")
    EmailAddress: str | None = Field(None, max_length=50, description="Email. Please enter the email address.")
    Phone: str | None = Field(None, max_length=20, description="Phone. Please enter the phone.")
    Fax: str | None = Field(None, max_length=20, description="Fax. Please enter the fax.")
    Comments: str | None = Field(None, max_length=80, description="Comments. Please enter comments.")
    Department: str = Field(..., max_length=15, description="Department. Please enter the department.")
    Rating: int | None = Field(None, ge=0, le=9, description="Rating. Please enter the rating")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class FeedbackPage(BaseModel):
    items: list[Feedback]
    total: int


# Primary key: Department
PRIMARY_KEY = ["Department"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {}
