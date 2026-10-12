# mt-002-feedback-create-valid: Feedback: Create a valid record

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
1. Open Customer Management > Feedback maintenance.
2. Select New.
3. Enter Contact Name: `Antti Oyrinmetsa` (use a new key value for Department).
4. Enter Company: `Antin Metsastysase` (use a new key value for Department).
5. Enter Email: `aoyrinmetsa@sysma.am.com` (use a new key value for Department).
6. Enter Phone: `` (use a new key value for Department).
7. Enter Fax: `` (use a new key value for Department).
8. Enter Comments: `I enjoy having the selection of products I see here` (use a new key value for Department).
9. Select Save.

## Expected result
The record saves, the banner shows "Feedback saved." and it appears in the list.

## Traceability
- Field rules: Contact `x(30)`, Company `x(20)`, EmailAddress `x(50)`, Phone `x(20)`
