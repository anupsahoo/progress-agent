# mt-031-supplier-reject-invalid: Supplier: Reject values that break the field rules

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
1. Open Supplier Management > Supplier maintenance and open any record.
2. Enter Supplier ID: `0`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "Supplier number must be greater than zero". Nothing is written.

## Traceability
- Field rules: SupplierIDNum `zzzzzzzzz9`, Name `x(30)`, Address `x(35)`, Address2 `x(35)`
