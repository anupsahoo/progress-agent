# mt-030-local-default-reject-invalid: LocalDefault: Reject values that break the field rules

| | |
|---|---|
| Module | Sales & Territories (wave 1) |
| Table | LocalDefault |
| Legacy reference | `legacy/sales-territories/local_default_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Sales & Territories user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Sales & Territories > LocalDefault maintenance and open any record.
2. Enter Country: `XXXXXXXXXXXXXXXXXXXXX`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "at most 20 characters". Nothing is written.

## Traceability
- Field rules: Country `x(20)`, Region1Label `x(15)`, Region2Label `x(15)`, PostalLabel `x(15)`
