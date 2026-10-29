# Credit Management: program map

27 legacy programs and where each lands in the modern stack.

| Legacy program | Kind | Lines | Complexity | Modern home |
|---|---|---|---|---|
| `ref_call_maint.p` | procedure | 118 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `ref_call_browse.w` | ui | 190 | 4 | web: <Table>List.tsx |
| `ref_call_inquiry.w` | ui | 79 | 2 | web: <Table>Detail.tsx |
| `ref_call_report.p` | procedure | 48 | 1 | service function (follow-up PR) |
| `ref_call_lookup.i` | include | 43 | 1 | types.ts / repository |
| `tt_ref_call.i` | include | 40 | 1 | types.ts / repository |
| `ref_call_val.p` | procedure | 37 | 1 | validation.ts + Pydantic model |
| `ref_call_batch.p` | procedure | 42 | 1 | scheduled job (wave 4 batch platform) |
| `ref_call_export.p` | procedure | 43 | 1 | scheduled job (wave 4 batch platform) |
| `ref_call_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `RefCallBE.cls` | class | 81 | 2 | Pydantic model + router |
| `trg/write_ref_call.p` | trigger | 65 | 1 | API audit middleware |
| `trg/delete_ref_call.p` | trigger | 42 | 1 | API audit middleware |
| `si_ref_call.p` | procedure | 59 | 3 | FastAPI router |
| `credit_hold.p` | procedure | 451 | 10 | service function (follow-up PR) |
| `credit_limit_calc.p` | procedure | 147 | 3 | service function (follow-up PR) |
| `collections.w` | ui | 274 | 6 | service function (follow-up PR) |
| `dunning_batch.p` | procedure | 99 | 2 | scheduled job (wave 4 batch platform) |
| `credit_exposure_rpt.p` | procedure | 121 | 3 | service function (follow-up PR) |
| `credit_bureau_if.p` | procedure | 63 | 1 | service function (follow-up PR) |
| `refcall_followup.p` | procedure | 313 | 7 | service function (follow-up PR) |
| `bad_debt_writeoff.p` | procedure | 452 | 10 | service function (follow-up PR) |
| `dso_calc.p` | procedure | 368 | 9 | service function (follow-up PR) |
| `credit_review.w` | ui | 166 | 4 | service function (follow-up PR) |
| `credit_alert.p` | procedure | 255 | 6 | service function (follow-up PR) |
| `cr_defs.i` | include | 41 | 1 | shared library |
| `cr_menu.w` | ui | 101 | 3 | routes.tsx |
