# Warehousing: data mapping

ABL field to TypeScript, Pydantic and validation. Generated from `sports2000.df`.

## Warehouse `warehouses`

Primary key: `WarehouseNum` · Indexes: `warehousenum` (primary) (unique), `warehousename`

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `WarehouseNum` | Warehouse Num | integer | `zzzzzzzzz9` | `number` | `int` | required, greater than 0, at most 9999999999 |
| `WarehouseName` | Warehouse Name | character | `x(30)` | `string` | `str` | at most 30 characters |
| `Country` | Country | character | `x(20)` | `string` | `str` | at most 20 characters |
| `Address` | Address | character | `x(35)` | `string` | `str` | at most 35 characters |
| `Address2` | Address2 | character | `x(35)` | `string` | `str` | at most 35 characters |
| `City` | City | character | `x(25)` | `string` | `str` | at most 25 characters |
| `State` | State | character | `x(20)` | `string` | `str` | at most 20 characters |
| `PostalCode` | Postal Code | character | `x(10)` | `string` | `str` | at most 10 characters |
| `Phone` | Phone | character | `x(20)` | `string` | `str` | at most 20 characters |

## Bin `bins`

Primary key: `BinNum` · Indexes: `BinNum` (primary) (unique), `ItemNum`, `WarehouseNumItemNum`

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `WarehouseNum` | Warehouse Num | integer | `zzzzzzzzz9` | `number` | `int` | at least 0, at most 9999999999, must match an existing Warehouse |
| `Itemnum` | Item Num | integer | `zzzzzzzzz9` | `number` | `int` | at least 0, at most 9999999999, must match an existing Item |
| `Qty` | Qty | integer | `->>>>9` | `number` | `int` | at least -99999, at most 99999 |
| `BinNum` | Bin Num | integer | `zzzzzzzzz9` | `number` | `int` | required, at least 0, at most 9999999999 |
| `BinName` | Bin Name | character | `x(30)` | `string` | `str` | at most 30 characters |
