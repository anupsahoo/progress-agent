# mt-004-state-create-valid: State: Create a valid record

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
1. Open Sales & Territories > State maintenance.
2. Select New.
3. Enter State: `AK` (use a new key value for State).
4. Enter State Name: `Alaska` (use a new key value for State).
5. Enter Region: `West` (use a new key value for State).
6. Select Save.

## Expected result
The record saves, the banner shows "State saved." and it appears in the list.

## Traceability
- Field rules: State `x(20)`, StateName `x(20)`, Region `x(8)`
