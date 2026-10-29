# Purchasing: program map

39 legacy programs and where each lands in the modern stack.

| Legacy program | Kind | Lines | Complexity | Modern home |
|---|---|---|---|---|
| `purchase_order_maint.p` | procedure | 127 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `purchase_order_browse.w` | ui | 189 | 4 | web: <Table>List.tsx |
| `purchase_order_inquiry.w` | ui | 77 | 2 | web: <Table>Detail.tsx |
| `purchase_order_report.p` | procedure | 47 | 1 | service function (follow-up PR) |
| `purchase_order_lookup.i` | include | 40 | 1 | types.ts / repository |
| `tt_purchase_order.i` | include | 44 | 1 | types.ts / repository |
| `purchase_order_val.p` | procedure | 42 | 1 | validation.ts + Pydantic model |
| `purchase_order_batch.p` | procedure | 45 | 1 | scheduled job (wave 4 batch platform) |
| `purchase_order_export.p` | procedure | 42 | 1 | scheduled job (wave 4 batch platform) |
| `purchase_order_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `PurchaseOrderBE.cls` | class | 79 | 2 | Pydantic model + router |
| `trg/write_purchase_order.p` | trigger | 62 | 1 | API audit middleware |
| `trg/delete_purchase_order.p` | trigger | 48 | 1 | API audit middleware |
| `si_purchase_order.p` | procedure | 59 | 3 | FastAPI router |
| `poline_maint.p` | procedure | 136 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `poline_browse.w` | ui | 192 | 4 | web: <Table>List.tsx |
| `poline_inquiry.w` | ui | 83 | 2 | web: <Table>Detail.tsx |
| `poline_report.p` | procedure | 71 | 1 | service function (follow-up PR) |
| `poline_lookup.i` | include | 45 | 1 | types.ts / repository |
| `tt_poline.i` | include | 41 | 1 | types.ts / repository |
| `poline_val.p` | procedure | 36 | 1 | validation.ts + Pydantic model |
| `poline_batch.p` | procedure | 45 | 1 | scheduled job (wave 4 batch platform) |
| `poline_export.p` | procedure | 43 | 1 | scheduled job (wave 4 batch platform) |
| `poline_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `POLineBE.cls` | class | 91 | 2 | Pydantic model + router |
| `trg/write_poline.p` | trigger | 75 | 2 | API audit middleware |
| `trg/delete_poline.p` | trigger | 39 | 1 | API audit middleware |
| `si_poline.p` | procedure | 59 | 3 | FastAPI router |
| `po_create_from_reorder.p` | procedure | 297 | 8 | service function (follow-up PR) |
| `po_receive.w` | ui | 188 | 4 | service function (follow-up PR) |
| `po_receipt_post.p` | procedure | 263 | 7 | service function (follow-up PR) |
| `po_price_calc.p` | procedure | 183 | 4 | service function (follow-up PR) |
| `po_open_rpt.p` | procedure | 99 | 3 | service function (follow-up PR) |
| `po_expedite_batch.p` | procedure | 64 | 1 | scheduled job (wave 4 batch platform) |
| `po_edi_850.p` | procedure | 162 | 4 | service function (follow-up PR) |
| `po_approve.p` | procedure | 184 | 4 | service function (follow-up PR) |
| `po_close.p` | procedure | 108 | 3 | service function (follow-up PR) |
| `po_defs.i` | include | 48 | 1 | shared library |
| `po_menu.w` | ui | 101 | 3 | routes.tsx |
