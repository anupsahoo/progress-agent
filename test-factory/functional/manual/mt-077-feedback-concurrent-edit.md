# mt-077-feedback-concurrent-edit: Feedback: Two users edit the same record

| | |
|---|---|
| Module | Customer Management (wave 1) |
| Table | Feedback |
| Legacy reference | `legacy/customer-management/feedback_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Customer Management user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Sign in as user A and user B in two browsers.
2. Both open Feedback Department= and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: Contact `x(30)`, Company `x(20)`, EmailAddress `x(50)`, Phone `x(20)`
