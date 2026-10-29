# mt-052-feedback-search-sort: Feedback: Search and sort the list

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
1. Open Customer Management > Feedback.
2. Type `Ant` in Search.
3. Select the Contact Name column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: Contact `x(30)`, Company `x(20)`, EmailAddress `x(50)`, Phone `x(20)`
