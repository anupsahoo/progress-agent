# Order Entry: data mapping

ABL field to TypeScript, Pydantic and validation. Generated from `sports2000.df`.

## Order `orders`

Primary key: `Ordernum` · Indexes: `OrderNum` (primary) (unique), `CustOrder` (unique), `OrderDate`, `OrderStatus`, `SalesRep`

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `Ordernum` | Order Num | integer | `zzzzzzzzz9` | `number` | `int` | required, greater than 0, at most 9999999999 |
| `CustNum` | Cust Num | integer | `>>>>9` | `number` | `int` | at least 0, at most 99999, must match an existing Customer |
| `OrderDate` | Ordered | date | `99/99/99` | `string` | `date` | ISO date |
| `ShipDate` | Shipped | date | `99/99/9999` | `string` | `date` | ISO date |
| `PromiseDate` | Promised | date | `99/99/99` | `string` | `date` | ISO date |
| `Carrier` | Carrier | character | `x(25)` | `string` | `str` | at most 25 characters |
| `Instructions` | Instructions | character | `x(50)` | `string` | `str` | at most 50 characters |
| `PO` | PO | character | `x(20)` | `string` | `str` | at most 20 characters |
| `Terms` | Terms | character | `x(20)` | `string` | `str` | at most 20 characters |
| `SalesRep` | Sales Rep | character | `x(4)` | `string` | `str` | at most 4 characters |
| `BillToID` | Bill To ID | integer | `zzzzzzzzz9` | `number` | `int` | at least 0, at most 9999999999 |
| `ShipToID` | Ship To ID | integer | `zzzzzzzzz9` | `number` | `int` | at least 0, at most 9999999999 |
| `OrderStatus` | Order Status | character | `x(20)` | `string` | `str` | at most 20 characters |
| `WarehouseNum` | Warehouse Num | integer | `zzzzzzzzz9` | `number` | `int` | at least 0, at most 9999999999, must match an existing Warehouse (0 means "not set") |
| `Creditcard` | Credit Card | character | `x(20)` | `string` | `str` | at most 20 characters |

## OrderLine `order-lines`

Primary key: `Ordernum, Linenum` · Indexes: `orderline` (primary) (unique), `itemnum`, `OrderLineStatus`

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `Ordernum` | Order Num | integer | `zzzzzzzzz9` | `number` | `int` | required, at least 0, at most 9999999999, must match an existing Order |
| `Linenum` | Line Num | integer | `>>9` | `number` | `int` | required, at least 0, at most 999 |
| `Itemnum` | Item Num | integer | `zzzzzzzzz9` | `number` | `int` | at least 0, at most 9999999999, must match an existing Item |
| `Price` | Price | decimal | `->,>>>,>>9.99` | `number` | `Decimal` | at least -9999999.99, at most 9999999.99, 2 decimal places |
| `Qty` | Qty | integer | `->>>>9` | `number` | `int` | at least -99999, at most 99999 |
| `Discount` | Discount | integer | `>>9%` | `number` | `int` | at least 0, at most 999 |
| `ExtendedPrice` | Extended Price | decimal | `->>>,>>9.99` | `number` | `Decimal` | at least -999999.99, at most 999999.99, 2 decimal places |
| `OrderLineStatus` | Order Line Status | character | `x(20)` | `string` | `str` | at most 20 characters |
