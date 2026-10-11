# mt-080-local-default-concurrent-edit: LocalDefault: Two users edit the same record

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
1. Sign in as user A and user B in two browsers.
2. Both open LocalDefault LocalDefNum=1 and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: Country `x(20)`, Region1Label `x(15)`, Region2Label `x(15)`, PostalLabel `x(15)`
