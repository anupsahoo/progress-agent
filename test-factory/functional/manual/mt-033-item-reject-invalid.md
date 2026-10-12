# mt-033-item-reject-invalid: Item: Reject values that break the field rules

| | |
|---|---|
| Module | Inventory (wave 2) |
| Table | Item |
| Legacy reference | `legacy/inventory/item_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Inventory user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Inventory > Item maintenance and open any record.
2. Enter Item Num: `-1`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "Item number must be greater or equal to 0". Nothing is written.

## Traceability
- Field rules: Itemnum `zzzzzzzzz9`, ItemName `x(25)`, Price `->,>>>,>>9.99`, Onhand `->>>>9`
