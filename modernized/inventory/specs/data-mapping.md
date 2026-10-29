# Inventory: data mapping

ABL field to TypeScript, Pydantic and validation. Generated from `sports2000.df`.

## Item `items`

Primary key: `Itemnum` · Indexes: `ItemNum` (primary) (unique), `CatDescription`, `Category2ItemName`, `CategoryItemName`, `ItemName`

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `Itemnum` | Item Num | integer | `zzzzzzzzz9` | `number` | `int` | required, at least 0, at most 9999999999 |
| `ItemName` | Item Name | character | `x(25)` | `string` | `str` | at most 25 characters |
| `Price` | Price | decimal | `->,>>>,>>9.99` | `number` | `Decimal` | at least -9999999.99, at most 9999999.99, 2 decimal places |
| `Onhand` | On Hand | integer | `->>>>9` | `number` | `int` | at least -99999, at most 99999 |
| `Allocated` | Allocated | integer | `->>>>9` | `number` | `int` | at least -99999, at most 99999 |
| `ReOrder` | Re Order | integer | `->>>>9` | `number` | `int` | at least -99999, at most 99999 |
| `OnOrder` | On Order | integer | `->>>>9` | `number` | `int` | at least -99999, at most 99999 |
| `CatPage` | Cat Page | integer | `>>9` | `number` | `int` | at least 0, at most 999 |
| `CatDescription` | Cat-Description | character | `X(200)` | `string` | `str` | at most 200 characters |
| `Category1` | Category1 | character | `x(30)` | `string` | `str` | at most 30 characters |
| `Category2` | Category2 | character | `x(30)` | `string` | `str` | at most 30 characters |
| `Special` | Special | character | `x(8)` | `string` | `str` | at most 8 characters |
| `Weight` | Weight | decimal | `->>,>>9.99` | `number` | `Decimal` | at least -99999.99, at most 99999.99, 2 decimal places |
| `Minqty` | Min Qty | integer | `->>>>9` | `number` | `int` | at least -99999, at most 99999 |

## InventoryTrans `inventory-transes`

Primary key: `InvTransNum` · Indexes: 

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `InvTransNum` | Inventory Trans Num | integer | `zzzzzzzzz9` | `number` | `int` | required, at least 0, at most 9999999999 |
| `WarehouseNum` | Warehouse Num | integer | `zzzzzzzzz9` | `number` | `int` | at least 0, at most 9999999999 |
| `BinNum` | Bin Num | integer | `zzzzzzzzz9` | `number` | `int` | at least 0, at most 9999999999 |
| `Qty` | Qty | integer | `->>>>9` | `number` | `int` | at least -99999, at most 99999 |
| `Itemnum` | Item Num | integer | `zzzzzzzzz9` | `number` | `int` | at least 0, at most 9999999999, must match an existing Item |
| `TransDate` | Trans Date | date | `99/99/9999` | `string` | `date` | ISO date |
| `InvType` | Type | character | `X(12)` | `string` | `str` | at most 12 characters |
| `PONum` | PO Num | integer | `zzzzzzzzz9` | `number` | `int` | at least 0, at most 9999999999 |
| `Ordernum` | Order Num | integer | `zzzzzzzzz9` | `number` | `int` | at least 0, at most 9999999999 |
| `Transtime` | Trans Time | character | `X(5)` | `string` | `str` | at most 5 characters |
