# Supplier Management: data mapping

ABL field to TypeScript, Pydantic and validation. Generated from `sports2000.df`.

## Supplier `suppliers`

Primary key: `SupplierIDNum` · Indexes: `SupplierID` (primary) (unique)

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `SupplierIDNum` | Supplier ID | integer | `zzzzzzzzz9` | `number` | `int` | required, greater than 0, at most 9999999999 |
| `Name` | Name | character | `x(30)` | `string` | `str` | at most 30 characters |
| `Address` | Address | character | `x(35)` | `string` | `str` | at most 35 characters |
| `Address2` | Address2 | character | `x(35)` | `string` | `str` | at most 35 characters |
| `City` | City | character | `x(25)` | `string` | `str` | at most 25 characters |
| `State` | State | character | `x(20)` | `string` | `str` | at most 20 characters |
| `PostalCode` | ZipCode | character | `x(10)` | `string` | `str` | at most 10 characters |
| `Country` | Country | character | `x(20)` | `string` | `str` | at most 20 characters |
| `Phone` | Phone | character | `x(20)` | `string` | `str` | at most 20 characters |
| `Comments` | Comments | character | `x(80)` | `string` | `str` | at most 80 characters |
| `Password` | Password | character | `x(8)` | `string` | `str` | required, at most 8 characters |
| `LoginDate` | Login Date | date | `99/99/9999` | `string` | `date` | ISO date |
| `ShipAmount` | Ship Amount | integer | `>>>>9` | `number` | `int` | at least 0, at most 99999 |
| `Discount` | Discount | integer | `>>9%` | `number` | `int` | at least 0, at most 999 |

## SupplierItemXref `supplier-item-xrefs`

Primary key: `SupplierIDNum, Itemnum` · Indexes: `SupplieridItemNum` (primary) (unique), `ItemNumSupplierID` (unique)

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `SupplierIDNum` | Supplier ID | integer | `zzzzzzzzz9` | `number` | `int` | required, at least 0, at most 9999999999, must match an existing Supplier |
| `Itemnum` | Item # | integer | `zzzzzzzzz9` | `number` | `int` | required, at least 0, at most 9999999999, must match an existing Item |
