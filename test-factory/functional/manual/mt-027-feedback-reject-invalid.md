# mt-027-feedback-reject-invalid: Feedback: Reject values that break the field rules

| | |
|---|---|
| Module | Customer Management (wave 1) |
| Table | Feedback |
| Legacy reference | `legacy/customer-management/feedback_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Customer Management user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Customer Management > Feedback maintenance and open any record.
2. Enter Contact Name: `XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "at most 30 characters". Nothing is written.

## Traceability
- Field rules: Contact `x(30)`, Company `x(20)`, EmailAddress `x(50)`, Phone `x(20)`
