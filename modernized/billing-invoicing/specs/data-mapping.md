# Billing & Invoicing: data mapping

ABL field to TypeScript, Pydantic and validation. Generated from `sports2000.df`.

## Invoice `invoices`

Primary key: `Invoicenum` · Indexes: `InvoiceNum` (primary) (unique), `CustNum`, `InvoiceDate`, `OrderNum`

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `Invoicenum` | Invoice Num | integer | `zzzzzzzzz9` | `number` | `int` | required, greater than 0, at most 9999999999 |
| `CustNum` | Cust Num | integer | `>>>>9` | `number` | `int` | at least 0, at most 99999, must match an existing Customer |
| `InvoiceDate` | Invoice Date | date | `99/99/9999` | `string` | `date` | ISO date |
| `Amount` | Amount | decimal | `->>,>>9.99` | `number` | `Decimal` | at least -99999.99, at most 99999.99, 2 decimal places |
| `TotalPaid` | Total Paid | decimal | `->>,>>9.99` | `number` | `Decimal` | at least -99999.99, at most 99999.99, 2 decimal places |
| `Adjustment` | Adjustment | decimal | `->>,>>9.99` | `number` | `Decimal` | at least -99999.99, at most 99999.99, 2 decimal places |
| `OrderNum` | Order Num | integer | `zzzzzzzzz9` | `number` | `int` | at least 0, at most 9999999999 |
| `ShipCharge` | Ship Charge | decimal | `->>,>>9.99` | `number` | `Decimal` | at least -99999.99, at most 99999.99, 2 decimal places |

## BillTo `bill-tos`

Primary key: `CustNum, BillToID` · Indexes: `custnumbillto` (primary) (unique)

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `CustNum` | Cust Num | integer | `>>>>9` | `number` | `int` | required, at least 0, at most 99999, must match an existing Customer |
| `BillToID` | BillToID | integer | `zzzzzzzzz9` | `number` | `int` | required, at least 0, at most 9999999999 |
| `Name` | Name | character | `x(30)` | `string` | `str` | at most 30 characters |
| `Address` | Address | character | `x(35)` | `string` | `str` | at most 35 characters |
| `Address2` | Address2 | character | `x(35)` | `string` | `str` | at most 35 characters |
| `City` | City | character | `x(25)` | `string` | `str` | at most 25 characters |
| `State` | State | character | `x(20)` | `string` | `str` | at most 20 characters |
| `PostalCode` | Postal Code | character | `x(10)` | `string` | `str` | at most 10 characters |
| `Contact` | Contact | character | `x(30)` | `string` | `str` | at most 30 characters |
| `Phone` | Phone | character | `x(20)` | `string` | `str` | at most 20 characters |
