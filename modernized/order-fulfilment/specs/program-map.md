# Order Fulfilment: program map

26 legacy programs and where each lands in the modern stack.

| Legacy program | Kind | Lines | Complexity | Modern home |
|---|---|---|---|---|
| `ship_to_maint.p` | procedure | 122 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `ship_to_browse.w` | ui | 192 | 4 | web: <Table>List.tsx |
| `ship_to_inquiry.w` | ui | 89 | 2 | web: <Table>Detail.tsx |
| `ship_to_report.p` | procedure | 47 | 1 | service function (follow-up PR) |
| `ship_to_lookup.i` | include | 41 | 1 | types.ts / repository |
| `tt_ship_to.i` | include | 44 | 1 | types.ts / repository |
| `ship_to_val.p` | procedure | 32 | 1 | validation.ts + Pydantic model |
| `ship_to_batch.p` | procedure | 42 | 1 | scheduled job (wave 4 batch platform) |
| `ship_to_export.p` | procedure | 44 | 1 | scheduled job (wave 4 batch platform) |
| `ship_to_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `ShipToBE.cls` | class | 99 | 2 | Pydantic model + router |
| `trg/write_ship_to.p` | trigger | 86 | 2 | API audit middleware |
| `trg/delete_ship_to.p` | trigger | 42 | 1 | API audit middleware |
| `si_ship_to.p` | procedure | 59 | 3 | FastAPI router |
| `pick_list.p` | procedure | 45 | 1 | service function (follow-up PR) |
| `ship_confirm.w` | ui | 71 | 1 | service function (follow-up PR) |
| `ship_post.p` | procedure | 169 | 5 | service function (follow-up PR) |
| `carrier_rate.p` | procedure | 309 | 7 | service function (follow-up PR) |
| `backorder_release.p` | procedure | 98 | 2 | service function (follow-up PR) |
| `wave_pick.p` | procedure | 498 | 10 | service function (follow-up PR) |
| `asn_856.p` | procedure | 106 | 2 | service function (follow-up PR) |
| `packing_slip.p` | procedure | 60 | 2 | service function (follow-up PR) |
| `shipto_validate.p` | procedure | 444 | 9 | service function (follow-up PR) |
| `delivery_track.w` | ui | 135 | 3 | service function (follow-up PR) |
| `of_defs.i` | include | 48 | 2 | shared library |
| `of_menu.w` | ui | 95 | 3 | routes.tsx |
