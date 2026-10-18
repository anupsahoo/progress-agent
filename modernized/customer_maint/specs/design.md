# Design — customer_maint

## Architecture
```
React (CustomerMaint.tsx) ──▶ GET/PUT /customers/{custNum} (FastAPI) ──▶ OpenEdge DB (unchanged, via data access layer)
```
The Progress database stays as-is. A thin API layer replaces the character UI.

## API contract
| Method | Path | Success | Errors |
|--------|------|---------|--------|
| GET | /customers/{custNum} | 200 Customer + `ETag` | 404 "Customer not found." |
| PUT | /customers/{custNum} (`If-Match`) | 200 "Record updated successfully." | 404, 409 stale version, 422 validation |

## Data model (from customer.d)
| Field | Type | Editable |
|-------|------|----------|
| CustNum | integer | no |
| Name | character x(30) | yes |
| Address | character x(35) | yes |
| City | character x(25) | yes |
| State | character x(20) | yes |
| PostalCode | character x(10) | yes |
| Phone | character x(20) | yes |

## Legacy → modern mapping
| ABL construct | Modern equivalent |
|---------------|-------------------|
| `DEFINE FRAME fMain ... SIDE-LABELS` | Labelled responsive form |
| `UPDATE iCustNum WITH FRAME fPrompt` | Search input + Load button |
| `EXCLUSIVE-LOCK` / `RELEASE` | ETag + If-Match optimistic concurrency |
| `MESSAGE ... VIEW-AS ALERT-BOX` | Inline status banner (aria-live) |
