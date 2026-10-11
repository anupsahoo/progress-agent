# Supplier Management: program map

38 legacy programs and where each lands in the modern stack.

| Legacy program | Kind | Lines | Complexity | Modern home |
|---|---|---|---|---|
| `supplier_maint.p` | procedure | 139 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `supplier_browse.w` | ui | 192 | 4 | web: <Table>List.tsx |
| `supplier_inquiry.w` | ui | 95 | 2 | web: <Table>Detail.tsx |
| `supplier_report.p` | procedure | 59 | 1 | service function (follow-up PR) |
| `supplier_lookup.i` | include | 40 | 1 | types.ts / repository |
| `tt_supplier.i` | include | 53 | 1 | types.ts / repository |
| `supplier_val.p` | procedure | 39 | 1 | validation.ts + Pydantic model |
| `supplier_batch.p` | procedure | 48 | 1 | scheduled job (wave 4 batch platform) |
| `supplier_export.p` | procedure | 45 | 1 | scheduled job (wave 4 batch platform) |
| `supplier_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `SupplierBE.cls` | class | 106 | 2 | Pydantic model + router |
| `trg/write_supplier.p` | trigger | 100 | 2 | API audit middleware |
| `trg/delete_supplier.p` | trigger | 48 | 1 | API audit middleware |
| `si_supplier.p` | procedure | 59 | 3 | FastAPI router |
| `supplier_item_xref_maint.p` | procedure | 109 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `supplier_item_xref_browse.w` | ui | 185 | 4 | web: <Table>List.tsx |
| `supplier_item_xref_inquiry.w` | ui | 71 | 2 | web: <Table>Detail.tsx |
| `supplier_item_xref_report.p` | procedure | 49 | 1 | service function (follow-up PR) |
| `supplier_item_xref_lookup.i` | include | 36 | 1 | types.ts / repository |
| `tt_supplier_item_xref.i` | include | 38 | 1 | types.ts / repository |
| `supplier_item_xref_val.p` | procedure | 36 | 1 | validation.ts + Pydantic model |
| `supplier_item_xref_batch.p` | procedure | 42 | 1 | scheduled job (wave 4 batch platform) |
| `supplier_item_xref_export.p` | procedure | 43 | 1 | scheduled job (wave 4 batch platform) |
| `supplier_item_xref_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `SupplierItemXrefBE.cls` | class | 72 | 2 | Pydantic model + router |
| `trg/write_supplier_item_xref.p` | trigger | 51 | 1 | API audit middleware |
| `trg/delete_supplier_item_xref.p` | trigger | 42 | 1 | API audit middleware |
| `si_supplier_item_xref.p` | procedure | 59 | 3 | FastAPI router |
| `supplier_onboard.w` | ui | 86 | 2 | service function (follow-up PR) |
| `supplier_scorecard.p` | procedure | 98 | 2 | service function (follow-up PR) |
| `supplier_item_sync.p` | procedure | 63 | 1 | service function (follow-up PR) |
| `supplier_review_batch.p` | procedure | 279 | 7 | scheduled job (wave 4 batch platform) |
| `supplier_spend_rpt.p` | procedure | 125 | 3 | service function (follow-up PR) |
| `supplier_login_audit.p` | procedure | 495 | 10 | service function (follow-up PR) |
| `xref_cleanup.p` | procedure | 182 | 5 | service function (follow-up PR) |
| `supplier_shipcost.p` | procedure | 445 | 10 | service function (follow-up PR) |
| `sm_defs.i` | include | 46 | 1 | shared library |
| `sm_menu.w` | ui | 95 | 3 | routes.tsx |
