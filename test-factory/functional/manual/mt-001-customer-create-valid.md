# mt-001-customer-create-valid: Customer: Create a valid record

| | |
|---|---|
| Module | Customer Management (wave 1) |
| Table | Customer |
| Legacy reference | `legacy/customer-management/customer_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Customer Management user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Customer Management > Customer maintenance.
2. Select New.
3. Enter Cust Num: `1` (use a new key value for CustNum).
4. Enter Country: `USA` (use a new key value for CustNum).
5. Enter Name: `Lift Tours` (use a new key value for CustNum).
6. Enter Address: `276 North Drive` (use a new key value for CustNum).
7. Enter Address2: `` (use a new key value for CustNum).
8. Enter City: `Burlington` (use a new key value for CustNum).
9. Select Save.

## Expected result
The record saves, the banner shows "Customer saved." and it appears in the list.

## Traceability
- Field rules: CustNum `>>>>9`, Country `x(20)`, Name `x(30)`, Address `x(35)`
