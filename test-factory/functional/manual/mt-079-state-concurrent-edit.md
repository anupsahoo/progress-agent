# mt-079-state-concurrent-edit: State: Two users edit the same record

| | |
|---|---|
| Module | Sales & Territories (wave 1) |
| Table | State |
| Legacy reference | `legacy/sales-territories/state_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Sales & Territories user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Sign in as user A and user B in two browsers.
2. Both open State State=AK and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: State `x(20)`, StateName `x(20)`, Region `x(8)`
