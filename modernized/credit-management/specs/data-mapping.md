# Credit Management: data mapping

ABL field to TypeScript, Pydantic and validation. Generated from `sports2000.df`.

## RefCall `ref-calls`

Primary key: `CallNum` · Indexes: `CallNum` (primary) (unique), `CustNum` (unique), `Sibling` (unique), `Txt`

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `CallNum` | Call Num | character | `x(6)` | `string` | `str` | required, at most 6 characters |
| `CustNum` | Cust Num | integer | `>>>>9` | `number` | `int` | greater than 0, at most 99999 |
| `CallDate` | Call Date | date | `99/99/9999` | `string` | `date` | ISO date |
| `SalesRep` | Sales Rep | character | `x(4)` | `string` | `str` | at most 4 characters |
| `Parent` | Parent | character | `x(6)` | `string` | `str` | at most 6 characters |
| `Txt` | Txt | character | `x(300)` | `string` | `str` | at most 300 characters |
