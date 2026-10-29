# Customer Management: program map

39 legacy programs and where each lands in the modern stack.

| Legacy program | Kind | Lines | Complexity | Modern home |
|---|---|---|---|---|
| `customer_maint.p` | procedure | 165 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `customer_browse.w` | ui | 192 | 4 | web: <Table>List.tsx |
| `customer_inquiry.w` | ui | 103 | 2 | web: <Table>Detail.tsx |
| `customer_report.p` | procedure | 64 | 1 | service function (follow-up PR) |
| `customer_lookup.i` | include | 40 | 1 | types.ts / repository |
| `tt_customer.i` | include | 53 | 1 | types.ts / repository |
| `customer_val.p` | procedure | 47 | 1 | validation.ts + Pydantic model |
| `customer_batch.p` | procedure | 47 | 1 | scheduled job (wave 4 batch platform) |
| `customer_export.p` | procedure | 41 | 1 | scheduled job (wave 4 batch platform) |
| `customer_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `CustomerBE.cls` | class | 118 | 2 | Pydantic model + router |
| `trg/write_customer.p` | trigger | 114 | 3 | API audit middleware |
| `trg/delete_customer.p` | trigger | 67 | 1 | API audit middleware |
| `si_customer.p` | procedure | 59 | 3 | FastAPI router |
| `feedback_maint.p` | procedure | 106 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `feedback_browse.w` | ui | 192 | 4 | web: <Table>List.tsx |
| `feedback_inquiry.w` | ui | 83 | 2 | web: <Table>Detail.tsx |
| `feedback_report.p` | procedure | 58 | 1 | service function (follow-up PR) |
| `feedback_lookup.i` | include | 42 | 1 | types.ts / repository |
| `tt_feedback.i` | include | 41 | 1 | types.ts / repository |
| `feedback_val.p` | procedure | 33 | 1 | validation.ts + Pydantic model |
| `feedback_batch.p` | procedure | 45 | 1 | scheduled job (wave 4 batch platform) |
| `feedback_export.p` | procedure | 41 | 1 | scheduled job (wave 4 batch platform) |
| `feedback_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `FeedbackBE.cls` | class | 90 | 2 | Pydantic model + router |
| `trg/write_feedback.p` | trigger | 73 | 2 | API audit middleware |
| `trg/delete_feedback.p` | trigger | 38 | 1 | API audit middleware |
| `si_feedback.p` | procedure | 59 | 3 | FastAPI router |
| `cust_merge.p` | procedure | 482 | 10 | service function (follow-up PR) |
| `cust_credit_review.p` | procedure | 359 | 8 | service function (follow-up PR) |
| `cust_360.w` | ui | 103 | 2 | service function (follow-up PR) |
| `cust_dedupe_batch.p` | procedure | 142 | 3 | scheduled job (wave 4 batch platform) |
| `cust_aging_rpt.p` | procedure | 191 | 4 | service function (follow-up PR) |
| `cust_crm_feed.p` | procedure | 101 | 2 | service function (follow-up PR) |
| `feedback_triage.p` | procedure | 477 | 10 | service function (follow-up PR) |
| `cust_address_std.p` | procedure | 195 | 4 | service function (follow-up PR) |
| `cust_onboard.w` | ui | 227 | 5 | service function (follow-up PR) |
| `cm_defs.i` | include | 44 | 1 | shared library |
| `cm_menu.w` | ui | 101 | 3 | routes.tsx |
