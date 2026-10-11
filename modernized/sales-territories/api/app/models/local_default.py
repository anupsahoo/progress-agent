"""LocalDefault models. Generated from the sports2000 schema: The local default table contains default information for the application.

Every constraint below comes from the ABL FORMAT, DECIMALS or VALEXP of the field.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class LocalDefault(BaseModel):
    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    Country: str | None = Field(None, max_length=20, description="Country. Please enter the Country.")
    Region1Label: str | None = Field(None, max_length=15, description="Region1 Label. Please enter region one label")
    Region2Label: str | None = Field(None, max_length=15, description="Region2 Label. Please enter region two label.")
    PostalLabel: str | None = Field(None, max_length=15, description="Postal Label. Please enter the Postal Label")
    PostalFormat: str | None = Field(None, max_length=15, description="Postal Format. Please enter the Postal Format")
    TelFormat: str | None = Field(None, max_length=15, description="Tel Format. Please enter telephone format.")
    CurrencySymbol: str | None = Field(None, max_length=6, description="Currency Symbol. Please enter the currency symbol")
    DateFormat: str | None = Field(None, max_length=8, description="Date Format. Please enter the date format.")
    LocalDefNum: int = Field(..., ge=0, le=9999999999, description="Local Default Num. Please enter the Local Default Number.")
    version: int = Field(0, ge=0, description="Optimistic concurrency token (replaces EXCLUSIVE-LOCK)")


class LocalDefaultPage(BaseModel):
    items: list[LocalDefault]
    total: int


# Primary key: LocalDefNum
PRIMARY_KEY = ["LocalDefNum"]
# Foreign keys from VALEXP CAN-FIND(... OF ...)
FOREIGN_KEYS = {}
