# mt-057-supplier-item-xref-search-sort: SupplierItemXref: Search and sort the list

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
1. Open Supplier Management > SupplierItemXref.
2. Type `0` in Search.
3. Select the Supplier ID column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: SupplierIDNum `zzzzzzzzz9`, Itemnum `zzzzzzzzz9`
