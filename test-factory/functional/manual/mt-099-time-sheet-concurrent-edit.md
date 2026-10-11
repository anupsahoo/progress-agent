# mt-099-time-sheet-concurrent-edit: TimeSheet: Two users edit the same record

| | |
|---|---|
| Module | HR & Payroll (wave 4) |
| Table | TimeSheet |
| Legacy reference | `legacy/hr-payroll/time_sheet_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a HR & Payroll user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Sign in as user A and user B in two browsers.
2. Both open TimeSheet EmpNum=1, DayRecorded=1998-01-05 and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: EmpNum `zzzzzzzzz9`, DayRecorded `99/99/9999`, TypeRecorded `x(8)`, AMTimeIn `xx:xx`
