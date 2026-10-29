"""State models. Generated from the sports2000 schema: The state table contans state abbreviations and corresponding sales regions

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class State(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    State: str = Field(..., max_length=20, description="State. Please enter the state abbreviation.")
    StateName: str | None = Field(None, max_length=20, description="State Name. Please enter the full state name.")
    Region: str | None = Field(None, max_length=8, description="Region. Please enter the sales region for state.")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class StatePage(BaseModel):
    items: list[State]
    total: int


# Primary key: State
PRIMARY_KEY = ["State"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {}
