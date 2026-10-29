# Inventory: program map

39 legacy programs and where each lands in the modern stack.

| Legacy program | Kind | Lines | Complexity | Modern home |
|---|---|---|---|---|
| `item_maint.p` | procedure | 138 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `item_browse.w` | ui | 192 | 4 | web: <Table>List.tsx |
| `item_inquiry.w` | ui | 95 | 2 | web: <Table>Detail.tsx |
| `item_report.p` | procedure | 91 | 1 | service function (follow-up PR) |
| `item_lookup.i` | include | 43 | 1 | types.ts / repository |
| `tt_item.i` | include | 48 | 1 | types.ts / repository |
| `item_val.p` | procedure | 32 | 1 | validation.ts + Pydantic model |
| `item_batch.p` | procedure | 49 | 1 | scheduled job (wave 4 batch platform) |
| `item_export.p` | procedure | 45 | 1 | scheduled job (wave 4 batch platform) |
| `item_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `ItemBE.cls` | class | 106 | 2 | Pydantic model + router |
| `trg/write_item.p` | trigger | 96 | 2 | API audit middleware |
| `trg/delete_item.p` | trigger | 66 | 1 | API audit middleware |
| `si_item.p` | procedure | 59 | 3 | FastAPI router |
| `inventory_trans_maint.p` | procedure | 121 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `inventory_trans_browse.w` | ui | 192 | 4 | web: <Table>List.tsx |
| `inventory_trans_inquiry.w` | ui | 87 | 2 | web: <Table>Detail.tsx |
| `inventory_trans_report.p` | procedure | 58 | 1 | service function (follow-up PR) |
| `inventory_trans_lookup.i` | include | 40 | 1 | types.ts / repository |
| `tt_inventory_trans.i` | include | 41 | 1 | types.ts / repository |
| `inventory_trans_val.p` | procedure | 35 | 1 | validation.ts + Pydantic model |
| `inventory_trans_batch.p` | procedure | 46 | 1 | scheduled job (wave 4 batch platform) |
| `inventory_trans_export.p` | procedure | 44 | 1 | scheduled job (wave 4 batch platform) |
| `inventory_trans_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `InventoryTransBE.cls` | class | 95 | 2 | Pydantic model + router |
| `trg/write_inventory_trans.p` | trigger | 84 | 2 | API audit middleware |
| `trg/delete_inventory_trans.p` | trigger | 40 | 1 | API audit middleware |
| `si_inventory_trans.p` | procedure | 59 | 3 | FastAPI router |
| `stock_allocate.p` | procedure | 432 | 10 | service function (follow-up PR) |
| `reorder_calc.p` | procedure | 159 | 4 | service function (follow-up PR) |
| `stock_inquiry.w` | ui | 222 | 5 | web: <Table>Detail.tsx |
| `inv_valuation.p` | procedure | 155 | 4 | service function (follow-up PR) |
| `inv_movement_rpt.p` | procedure | 83 | 2 | service function (follow-up PR) |
| `inv_adjust.p` | procedure | 469 | 10 | service function (follow-up PR) |
| `catalog_export.p` | procedure | 175 | 4 | scheduled job (wave 4 batch platform) |
| `abc_classify.p` | procedure | 129 | 3 | service function (follow-up PR) |
| `inv_trans_post.p` | procedure | 354 | 9 | service function (follow-up PR) |
| `in_defs.i` | include | 46 | 1 | shared library |
| `in_menu.w` | ui | 101 | 3 | routes.tsx |
