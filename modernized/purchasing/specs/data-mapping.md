# Purchasing: data mapping

ABL field to TypeScript, Pydantic and validation. Generated from `sports2000.df`.

## PurchaseOrder `purchase-orders`

Primary key: `PONum` · Indexes: `PONum` (primary) (unique)

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `PONum` | PO Num | integer | `zzzzzzzzz9` | `number` | `int` | required, greater than 0, at most 9999999999 |
| `DateEntered` | Date Entered | date | `99/99/9999` | `string` | `date` | ISO date |
| `SupplierIDNum` | Supplier ID | integer | `zzzzzzzzz9` | `number` | `int` | at least 0, at most 9999999999, must match an existing Supplier |
| `ReceiveDate` | Date Received | date | `99/99/9999` | `string` | `date` | ISO date |
| `POStatus` | PO Status | character | `x(20)` | `string` | `str` | at most 20 characters |

## POLine `po-lines`

Primary key: `PONum, Linenum` · Indexes: `PONumLinenum` (primary) (unique)

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `Linenum` | Line Num | integer | `>>9` | `number` | `int` | required, at least 0, at most 999 |
| `Itemnum` | Item Num | integer | `zzzzzzzzz9` | `number` | `int` | at least 0, at most 9999999999, must match an existing Item |
| `Price` | Price | decimal | `->,>>>,>>9.99` | `number` | `Decimal` | at least -9999999.99, at most 9999999.99, 2 decimal places |
| `Qty` | Qty | integer | `->>>>9` | `number` | `int` | at least -99999, at most 99999 |
| `Discount` | Discount | integer | `>>9%` | `number` | `int` | at least 0, at most 999 |
| `ExtendedPrice` | Extended Price | decimal | `->>,>>9.99` | `number` | `Decimal` | at least -99999.99, at most 99999.99, 2 decimal places |
| `PONum` | Order Num | integer | `zzzzzzzzz9` | `number` | `int` | required, at least 0, at most 9999999999, must match an existing PurchaseOrder |
| `POLineStatus` | PO Line Status | character | `x(20)` | `string` | `str` | at most 20 characters |
