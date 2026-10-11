# Billing & Invoicing: program map

39 legacy programs and where each lands in the modern stack.

| Legacy program | Kind | Lines | Complexity | Modern home |
|---|---|---|---|---|
| `invoice_maint.p` | procedure | 153 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `invoice_browse.w` | ui | 191 | 4 | web: <Table>List.tsx |
| `invoice_inquiry.w` | ui | 83 | 2 | web: <Table>Detail.tsx |
| `invoice_report.p` | procedure | 61 | 1 | service function (follow-up PR) |
| `invoice_lookup.i` | include | 39 | 1 | types.ts / repository |
| `tt_invoice.i` | include | 45 | 1 | types.ts / repository |
| `invoice_val.p` | procedure | 39 | 1 | validation.ts + Pydantic model |
| `invoice_batch.p` | procedure | 48 | 1 | scheduled job (wave 4 batch platform) |
| `invoice_export.p` | procedure | 44 | 1 | scheduled job (wave 4 batch platform) |
| `invoice_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `InvoiceBE.cls` | class | 90 | 2 | Pydantic model + router |
| `trg/write_invoice.p` | trigger | 72 | 2 | API audit middleware |
| `trg/delete_invoice.p` | trigger | 41 | 1 | API audit middleware |
| `si_invoice.p` | procedure | 59 | 3 | FastAPI router |
| `bill_to_maint.p` | procedure | 121 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `bill_to_browse.w` | ui | 192 | 4 | web: <Table>List.tsx |
| `bill_to_inquiry.w` | ui | 87 | 2 | web: <Table>Detail.tsx |
| `bill_to_report.p` | procedure | 48 | 1 | service function (follow-up PR) |
| `bill_to_lookup.i` | include | 45 | 1 | types.ts / repository |
| `tt_bill_to.i` | include | 44 | 1 | types.ts / repository |
| `bill_to_val.p` | procedure | 32 | 1 | validation.ts + Pydantic model |
| `bill_to_batch.p` | procedure | 42 | 1 | scheduled job (wave 4 batch platform) |
| `bill_to_export.p` | procedure | 41 | 1 | scheduled job (wave 4 batch platform) |
| `bill_to_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `BillToBE.cls` | class | 97 | 2 | Pydantic model + router |
| `trg/write_bill_to.p` | trigger | 80 | 2 | API audit middleware |
| `trg/delete_bill_to.p` | trigger | 42 | 1 | API audit middleware |
| `si_bill_to.p` | procedure | 59 | 3 | FastAPI router |
| `invoice_gen.p` | procedure | 148 | 4 | service function (follow-up PR) |
| `invoice_print.p` | procedure | 157 | 3 | service function (follow-up PR) |
| `payment_apply.p` | procedure | 509 | 10 | service function (follow-up PR) |
| `invoice_adjust.w` | ui | 213 | 5 | service function (follow-up PR) |
| `ar_aging.p` | procedure | 78 | 2 | service function (follow-up PR) |
| `month_end_close.p` | procedure | 68 | 2 | service function (follow-up PR) |
| `einvoice_export.p` | procedure | 115 | 3 | scheduled job (wave 4 batch platform) |
| `ship_charge_calc.p` | procedure | 293 | 6 | service function (follow-up PR) |
| `billto_maint_wiz.w` | ui | 138 | 3 | service function (follow-up PR) |
| `bi_defs.i` | include | 47 | 1 | shared library |
| `bi_menu.w` | ui | 101 | 3 | routes.tsx |
