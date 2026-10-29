# Order Fulfilment: data mapping

ABL field to TypeScript, Pydantic and validation. Generated from `sports2000.df`.

## ShipTo `ship-tos`

Primary key: `CustNum, ShipToID` · Indexes: `custnumshipto` (primary) (unique)

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `CustNum` | Cust Num | integer | `>>>>9` | `number` | `int` | required, at least 0, at most 99999, must match an existing Customer |
| `ShipToID` | Ship To ID | integer | `zzzzzzzzz9` | `number` | `int` | required, at least 0, at most 9999999999 |
| `Contact` | Contact | character | `x(30)` | `string` | `str` | at most 30 characters |
| `Address` | Address | character | `x(35)` | `string` | `str` | at most 35 characters |
| `Address2` | Address2 | character | `x(35)` | `string` | `str` | at most 35 characters |
| `City` | City | character | `x(25)` | `string` | `str` | at most 25 characters |
| `State` | State | character | `x(20)` | `string` | `str` | at most 20 characters |
| `PostalCode` | Postal Code | character | `x(10)` | `string` | `str` | at most 10 characters |
| `Phone` | Phone | character | `x(20)` | `string` | `str` | at most 20 characters |
| `Comments` | Comments | character | `x(80)` | `string` | `str` | at most 80 characters |
| `Name` | Name | character | `x(30)` | `string` | `str` | at most 30 characters |
