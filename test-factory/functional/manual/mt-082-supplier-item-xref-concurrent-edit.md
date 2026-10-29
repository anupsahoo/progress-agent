# mt-082-supplier-item-xref-concurrent-edit: SupplierItemXref: Two users edit the same record

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
1. Sign in as user A and user B in two browsers.
2. Both open SupplierItemXref SupplierIDNum=0, Itemnum=0 and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: SupplierIDNum `zzzzzzzzz9`, Itemnum `zzzzzzzzz9`
