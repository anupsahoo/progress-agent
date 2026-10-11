# mt-005-local-default-create-valid: LocalDefault: Create a valid record

| | |
|---|---|
| Module | Sales & Territories (wave 1) |
| Table | LocalDefault |
| Legacy reference | `legacy/sales-territories/local_default_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Sales & Territories user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Sales & Territories > LocalDefault maintenance.
2. Select New.
3. Enter Country: `Canada` (use a new key value for LocalDefNum).
4. Enter Region1 Label: `City` (use a new key value for LocalDefNum).
5. Enter Region2 Label: `Province` (use a new key value for LocalDefNum).
6. Enter Postal Label: `Postal Code` (use a new key value for LocalDefNum).
7. Enter Postal Format: `X9X 9X9` (use a new key value for LocalDefNum).
8. Enter Tel Format: `(999) 999-9999` (use a new key value for LocalDefNum).
9. Select Save.

## Expected result
The record saves, the banner shows "LocalDefault saved." and it appears in the list.

## Traceability
- Field rules: Country `x(20)`, Region1Label `x(15)`, Region2Label `x(15)`, PostalLabel `x(15)`
