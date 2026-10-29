# mt-006-supplier-create-valid: Supplier: Create a valid record

| | |
|---|---|
| Module | Supplier Management (wave 1) |
| Table | Supplier |
| Legacy reference | `legacy/supplier-management/supplier_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Supplier Management user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Supplier Management > Supplier maintenance.
2. Select New.
3. Enter Supplier ID: `1` (use a new key value for SupplierIDNum).
4. Enter Name: `GolfWorld Supplies` (use a new key value for SupplierIDNum).
5. Enter Address: `276 North Street` (use a new key value for SupplierIDNum).
6. Enter Address2: `-` (use a new key value for SupplierIDNum).
7. Enter City: `Boston` (use a new key value for SupplierIDNum).
8. Enter State: `MA` (use a new key value for SupplierIDNum).
9. Select Save.

## Expected result
The record saves, the banner shows "Supplier saved." and it appears in the list.

## Traceability
- Field rules: SupplierIDNum `zzzzzzzzz9`, Name `x(30)`, Address `x(35)`, Address2 `x(35)`
