# mt-032-supplier-item-xref-reject-invalid: SupplierItemXref: Reject values that break the field rules

| | |
|---|---|
| Module | Supplier Management (wave 1) |
| Table | SupplierItemXref |
| Legacy reference | `legacy/supplier-management/supplier_item_xref_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Supplier Management user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Supplier Management > SupplierItemXref maintenance and open any record.
2. Enter Supplier ID: `-1`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "Supplier must exist.". Nothing is written.

## Traceability
- Field rules: SupplierIDNum `zzzzzzzzz9`, Itemnum `zzzzzzzzz9`
