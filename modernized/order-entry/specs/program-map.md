# Order Entry: program map

40 legacy programs and where each lands in the modern stack.

| Legacy program | Kind | Lines | Complexity | Modern home |
|---|---|---|---|---|
| `order_maint.p` | procedure | 160 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `order_browse.w` | ui | 192 | 4 | web: <Table>List.tsx |
| `order_inquiry.w` | ui | 97 | 2 | web: <Table>Detail.tsx |
| `order_report.p` | procedure | 50 | 1 | service function (follow-up PR) |
| `order_lookup.i` | include | 44 | 1 | types.ts / repository |
| `tt_order.i` | include | 56 | 1 | types.ts / repository |
| `order_val.p` | procedure | 49 | 1 | validation.ts + Pydantic model |
| `order_batch.p` | procedure | 44 | 1 | scheduled job (wave 4 batch platform) |
| `order_export.p` | procedure | 46 | 1 | scheduled job (wave 4 batch platform) |
| `order_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `OrderBE.cls` | class | 109 | 2 | Pydantic model + router |
| `trg/write_order.p` | trigger | 102 | 3 | API audit middleware |
| `trg/delete_order.p` | trigger | 57 | 1 | API audit middleware |
| `si_order.p` | procedure | 59 | 3 | FastAPI router |
| `order_line_maint.p` | procedure | 138 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `order_line_browse.w` | ui | 192 | 4 | web: <Table>List.tsx |
| `order_line_inquiry.w` | ui | 83 | 2 | web: <Table>Detail.tsx |
| `order_line_report.p` | procedure | 70 | 1 | service function (follow-up PR) |
| `order_line_lookup.i` | include | 41 | 1 | types.ts / repository |
| `tt_order_line.i` | include | 42 | 1 | types.ts / repository |
| `order_line_val.p` | procedure | 36 | 1 | validation.ts + Pydantic model |
| `order_line_batch.p` | procedure | 49 | 1 | scheduled job (wave 4 batch platform) |
| `order_line_export.p` | procedure | 45 | 1 | scheduled job (wave 4 batch platform) |
| `order_line_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `OrderLineBE.cls` | class | 91 | 2 | Pydantic model + router |
| `trg/write_order_line.p` | trigger | 73 | 2 | API audit middleware |
| `trg/delete_order_line.p` | trigger | 39 | 1 | API audit middleware |
| `si_order_line.p` | procedure | 59 | 3 | FastAPI router |
| `order_entry.w` | ui | 147 | 3 | service function (follow-up PR) |
| `order_price.p` | procedure | 527 | 10 | service function (follow-up PR) |
| `order_credit_check.p` | procedure | 213 | 5 | service function (follow-up PR) |
| `order_copy.p` | procedure | 142 | 4 | service function (follow-up PR) |
| `order_status_upd.p` | procedure | 294 | 7 | service function (follow-up PR) |
| `order_backlog_rpt.p` | procedure | 218 | 5 | service function (follow-up PR) |
| `order_web_import.p` | procedure | 181 | 4 | scheduled job (wave 4 batch platform) |
| `order_purge.p` | procedure | 124 | 3 | service function (follow-up PR) |
| `order_tax_calc.p` | procedure | 297 | 6 | service function (follow-up PR) |
| `order_inquiry.w` | ui | 256 | 5 | web: <Table>Detail.tsx |
| `oe_defs.i` | include | 46 | 2 | shared library |
| `oe_menu.w` | ui | 107 | 3 | routes.tsx |
