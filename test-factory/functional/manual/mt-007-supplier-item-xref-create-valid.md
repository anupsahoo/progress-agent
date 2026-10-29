# mt-007-supplier-item-xref-create-valid: SupplierItemXref: Create a valid record

| | |
|---|---|
| Module | Supplier Management (wave 1) |
| Table | SupplierItemXref |
| Legacy reference | `legacy/supplier-management/supplier_item_xref_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Supplier Management user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Supplier Management > SupplierItemXref maintenance.
2. Select New.
3. Enter Supplier ID: `0` (use a new key value for SupplierIDNum, Itemnum).
4. Enter Item #: `0` (use a new key value for SupplierIDNum, Itemnum).
5. Select Save.

## Expected result
The record saves, the banner shows "SupplierItemXref saved." and it appears in the list.

## Traceability
- Field rules: SupplierIDNum `zzzzzzzzz9`, Itemnum `zzzzzzzzz9`
