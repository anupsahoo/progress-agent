# Warehousing: program map

38 legacy programs and where each lands in the modern stack.

| Legacy program | Kind | Lines | Complexity | Modern home |
|---|---|---|---|---|
| `warehouse_maint.p` | procedure | 113 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `warehouse_browse.w` | ui | 192 | 4 | web: <Table>List.tsx |
| `warehouse_inquiry.w` | ui | 85 | 2 | web: <Table>Detail.tsx |
| `warehouse_report.p` | procedure | 49 | 1 | service function (follow-up PR) |
| `warehouse_lookup.i` | include | 41 | 1 | types.ts / repository |
| `tt_warehouse.i` | include | 45 | 1 | types.ts / repository |
| `warehouse_val.p` | procedure | 32 | 1 | validation.ts + Pydantic model |
| `warehouse_batch.p` | procedure | 41 | 1 | scheduled job (wave 4 batch platform) |
| `warehouse_export.p` | procedure | 42 | 1 | scheduled job (wave 4 batch platform) |
| `warehouse_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `WarehouseBE.cls` | class | 93 | 2 | Pydantic model + router |
| `trg/write_warehouse.p` | trigger | 76 | 2 | API audit middleware |
| `trg/delete_warehouse.p` | trigger | 54 | 1 | API audit middleware |
| `si_warehouse.p` | procedure | 59 | 3 | FastAPI router |
| `bin_maint.p` | procedure | 112 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `bin_browse.w` | ui | 189 | 4 | web: <Table>List.tsx |
| `bin_inquiry.w` | ui | 77 | 2 | web: <Table>Detail.tsx |
| `bin_report.p` | procedure | 54 | 1 | service function (follow-up PR) |
| `bin_lookup.i` | include | 42 | 1 | types.ts / repository |
| `tt_bin.i` | include | 39 | 1 | types.ts / repository |
| `bin_val.p` | procedure | 36 | 1 | validation.ts + Pydantic model |
| `bin_batch.p` | procedure | 48 | 1 | scheduled job (wave 4 batch platform) |
| `bin_export.p` | procedure | 41 | 1 | scheduled job (wave 4 batch platform) |
| `bin_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `BinBE.cls` | class | 81 | 2 | Pydantic model + router |
| `trg/write_bin.p` | trigger | 64 | 1 | API audit middleware |
| `trg/delete_bin.p` | trigger | 46 | 1 | API audit middleware |
| `si_bin.p` | procedure | 59 | 3 | FastAPI router |
| `bin_transfer.w` | ui | 143 | 3 | service function (follow-up PR) |
| `cycle_count.p` | procedure | 160 | 4 | service function (follow-up PR) |
| `putaway_plan.p` | procedure | 243 | 5 | service function (follow-up PR) |
| `wh_capacity_rpt.p` | procedure | 162 | 4 | service function (follow-up PR) |
| `bin_replenish.p` | procedure | 248 | 6 | service function (follow-up PR) |
| `wh_transfer.p` | procedure | 394 | 10 | service function (follow-up PR) |
| `rf_scanner_if.p` | procedure | 117 | 3 | service function (follow-up PR) |
| `wh_layout.w` | ui | 194 | 4 | service function (follow-up PR) |
| `wh_defs.i` | include | 43 | 1 | shared library |
| `wh_menu.w` | ui | 95 | 3 | routes.tsx |
