# Sales & Territories: data mapping

ABL field to TypeScript, Pydantic and validation. Generated from `sports2000.df`.

## Salesrep `salesreps`

Primary key: `SalesRep` · Indexes: `SalesRep` (primary) (unique)

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `SalesRep` | Sales Rep | character | `x(4)` | `string` | `str` | required, at most 4 characters |
| `RepName` | Rep Name | character | `x(30)` | `string` | `str` | at most 30 characters |
| `Region` | Region | character | `x(8)` | `string` | `str` | at most 8 characters |
| `MonthQuota` | Month Quota | integer[12] | `->,>>>,>>9` | `number[]` | `list[int]` | free text |

## State `states`

Primary key: `State` · Indexes: `State` (primary) (unique)

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `State` | State | character | `x(20)` | `string` | `str` | required, at most 20 characters |
| `StateName` | State Name | character | `x(20)` | `string` | `str` | at most 20 characters |
| `Region` | Region | character | `x(8)` | `string` | `str` | at most 8 characters |

## LocalDefault `local-defaults`

Primary key: `LocalDefNum` · Indexes: `localdefnum` (primary) (unique)

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `Country` | Country | character | `x(20)` | `string` | `str` | at most 20 characters |
| `Region1Label` | Region1 Label | character | `x(15)` | `string` | `str` | at most 15 characters |
| `Region2Label` | Region2 Label | character | `x(15)` | `string` | `str` | at most 15 characters |
| `PostalLabel` | Postal Label | character | `x(15)` | `string` | `str` | at most 15 characters |
| `PostalFormat` | Postal Format | character | `x(15)` | `string` | `str` | at most 15 characters |
| `TelFormat` | Tel Format | character | `x(15)` | `string` | `str` | at most 15 characters |
| `CurrencySymbol` | Currency Symbol | character | `x(6)` | `string` | `str` | at most 6 characters |
| `DateFormat` | Date Format | character | `x(8)` | `string` | `str` | at most 8 characters |
| `LocalDefNum` | Local Default Num | integer | `zzzzzzzzz9` | `number` | `int` | required, at least 0, at most 9999999999 |
