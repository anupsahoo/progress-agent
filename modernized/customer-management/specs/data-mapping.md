# Customer Management: data mapping

ABL field to TypeScript, Pydantic and validation. Generated from `sports2000.df`.

## Customer `customers`

Primary key: `CustNum` · Indexes: `CustNum` (primary) (unique), `Comments`, `CountryPost`, `Name`, `SalesRep`

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `CustNum` | Cust Num | integer | `>>>>9` | `number` | `int` | required, greater than 0, at most 99999 |
| `Country` | Country | character | `x(20)` | `string` | `str` | at most 20 characters |
| `Name` | Name | character | `x(30)` | `string` | `str` | at most 30 characters |
| `Address` | Address | character | `x(35)` | `string` | `str` | at most 35 characters |
| `Address2` | Address2 | character | `x(35)` | `string` | `str` | at most 35 characters |
| `City` | City | character | `x(25)` | `string` | `str` | at most 25 characters |
| `State` | State | character | `x(20)` | `string` | `str` | at most 20 characters |
| `PostalCode` | Postal Code | character | `x(10)` | `string` | `str` | at most 10 characters |
| `Contact` | Contact | character | `x(30)` | `string` | `str` | at most 30 characters |
| `Phone` | Phone | character | `x(20)` | `string` | `str` | at most 20 characters |
| `SalesRep` | Sales Rep | character | `x(4)` | `string` | `str` | at most 4 characters, must match an existing Salesrep |
| `CreditLimit` | Credit Limit | decimal | `->,>>>,>>9` | `number` | `Decimal` | at least 0, at most 9999999, 2 decimal places |
| `Balance` | Balance | decimal | `->,>>>,>>9.99` | `number` | `Decimal` | at least -9999999.99, at most 9999999.99, 2 decimal places |
| `Terms` | Terms | character | `x(20)` | `string` | `str` | at most 20 characters |
| `Discount` | Discount | integer | `>>9%` | `number` | `int` | at least 0, at most 999 |
| `Comments` | Comments | character | `x(80)` | `string` | `str` | at most 80 characters |
| `Fax` | Fax | character | `x(20)` | `string` | `str` | at most 20 characters |
| `EmailAddress` | Email | character | `x(50)` | `string` | `str` | at most 50 characters |

## Feedback `feedbacks`

Primary key: `Department` · Indexes: `Department` (primary), `Comments`, `Company`, `Contact`, `Rating`

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `Contact` | Contact Name | character | `x(30)` | `string` | `str` | at most 30 characters |
| `Company` | Company | character | `x(20)` | `string` | `str` | at most 20 characters |
| `EmailAddress` | Email | character | `x(50)` | `string` | `str` | at most 50 characters |
| `Phone` | Phone | character | `x(20)` | `string` | `str` | at most 20 characters |
| `Fax` | Fax | character | `x(20)` | `string` | `str` | at most 20 characters |
| `Comments` | Comments | character | `x(80)` | `string` | `str` | at most 80 characters |
| `Department` | Department | character | `x(15)` | `string` | `str` | required, at most 15 characters |
| `Rating` | Rating | integer | `9` | `number` | `int` | at least 0, at most 9 |
