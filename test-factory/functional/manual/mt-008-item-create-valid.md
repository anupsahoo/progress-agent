# mt-008-item-create-valid: Item: Create a valid record

| | |
|---|---|
| Module | Inventory (wave 2) |
| Table | Item |
| Legacy reference | `legacy/inventory/item_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Inventory user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Inventory > Item maintenance.
2. Select New.
3. Enter Item Num: `1` (use a new key value for Itemnum).
4. Enter Item Name: `Fins` (use a new key value for Itemnum).
5. Enter Price: `24` (use a new key value for Itemnum).
6. Enter On Hand: `13022` (use a new key value for Itemnum).
7. Enter Allocated: `9399` (use a new key value for Itemnum).
8. Enter Re Order: `1` (use a new key value for Itemnum).
9. Select Save.

## Expected result
The record saves, the banner shows "Item saved." and it appears in the list.

## Traceability
- Field rules: Itemnum `zzzzzzzzz9`, ItemName `x(25)`, Price `->,>>>,>>9.99`, Onhand `->>>>9`
