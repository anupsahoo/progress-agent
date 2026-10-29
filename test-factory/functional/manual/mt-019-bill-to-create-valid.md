# mt-019-bill-to-create-valid: BillTo: Create a valid record

| | |
|---|---|
| Module | Billing & Invoicing (wave 4) |
| Table | BillTo |
| Legacy reference | `legacy/billing-invoicing/bill_to_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Billing & Invoicing user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Billing & Invoicing > BillTo maintenance.
2. Select New.
3. Enter Cust Num: `5` (use a new key value for CustNum, BillToID).
4. Enter BillToID: `1` (use a new key value for CustNum, BillToID).
5. Enter Name: `AL - Finance Offc` (use a new key value for CustNum, BillToID).
6. Enter Address: `7876 Alabama St` (use a new key value for CustNum, BillToID).
7. Enter Address2: `Suite 250` (use a new key value for CustNum, BillToID).
8. Enter City: `Montgomery` (use a new key value for CustNum, BillToID).
9. Select Save.

## Expected result
The record saves, the banner shows "BillTo saved." and it appears in the list.

## Traceability
- Field rules: CustNum `>>>>9`, BillToID `zzzzzzzzz9`, Name `x(30)`, Address `x(35)`
