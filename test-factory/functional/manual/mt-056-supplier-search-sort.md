# mt-056-supplier-search-sort: Supplier: Search and sort the list

| | |
|---|---|
| Module | Supplier Management (wave 1) |
| Table | Supplier |
| Legacy reference | `legacy/supplier-management/supplier_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Supplier Management user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Supplier Management > Supplier.
2. Type `Gol` in Search.
3. Select the Supplier ID column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: SupplierIDNum `zzzzzzzzz9`, Name `x(30)`, Address `x(35)`, Address2 `x(35)`
