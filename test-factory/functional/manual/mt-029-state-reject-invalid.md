# mt-029-state-reject-invalid: State: Reject values that break the field rules

| | |
|---|---|
| Module | Sales & Territories (wave 1) |
| Table | State |
| Legacy reference | `legacy/sales-territories/state_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Sales & Territories user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Sales & Territories > State maintenance and open any record.
2. Enter State Name: `XXXXXXXXXXXXXXXXXXXXX`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "at most 20 characters". Nothing is written.

## Traceability
- Field rules: State `x(20)`, StateName `x(20)`, Region `x(8)`
