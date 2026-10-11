# Sales & Territories: program map

52 legacy programs and where each lands in the modern stack.

| Legacy program | Kind | Lines | Complexity | Modern home |
|---|---|---|---|---|
| `salesrep_maint.p` | procedure | 95 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `salesrep_browse.w` | ui | 187 | 4 | web: <Table>List.tsx |
| `salesrep_inquiry.w` | ui | 73 | 2 | web: <Table>Detail.tsx |
| `salesrep_report.p` | procedure | 50 | 1 | service function (follow-up PR) |
| `salesrep_lookup.i` | include | 44 | 1 | types.ts / repository |
| `tt_salesrep.i` | include | 37 | 1 | types.ts / repository |
| `salesrep_val.p` | procedure | 30 | 1 | validation.ts + Pydantic model |
| `salesrep_batch.p` | procedure | 41 | 1 | scheduled job (wave 4 batch platform) |
| `salesrep_export.p` | procedure | 42 | 1 | scheduled job (wave 4 batch platform) |
| `salesrep_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `SalesrepBE.cls` | class | 75 | 2 | Pydantic model + router |
| `trg/write_salesrep.p` | trigger | 56 | 1 | API audit middleware |
| `trg/delete_salesrep.p` | trigger | 56 | 1 | API audit middleware |
| `si_salesrep.p` | procedure | 59 | 3 | FastAPI router |
| `state_maint.p` | procedure | 97 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `state_browse.w` | ui | 187 | 4 | web: <Table>List.tsx |
| `state_inquiry.w` | ui | 73 | 2 | web: <Table>Detail.tsx |
| `state_report.p` | procedure | 48 | 1 | service function (follow-up PR) |
| `state_lookup.i` | include | 44 | 1 | types.ts / repository |
| `tt_state.i` | include | 34 | 1 | types.ts / repository |
| `state_val.p` | procedure | 30 | 1 | validation.ts + Pydantic model |
| `state_batch.p` | procedure | 41 | 1 | scheduled job (wave 4 batch platform) |
| `state_export.p` | procedure | 43 | 1 | scheduled job (wave 4 batch platform) |
| `state_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `StateBE.cls` | class | 75 | 2 | Pydantic model + router |
| `trg/write_state.p` | trigger | 56 | 1 | API audit middleware |
| `trg/delete_state.p` | trigger | 66 | 1 | API audit middleware |
| `si_state.p` | procedure | 59 | 3 | FastAPI router |
| `local_default_maint.p` | procedure | 109 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `local_default_browse.w` | ui | 192 | 4 | web: <Table>List.tsx |
| `local_default_inquiry.w` | ui | 85 | 2 | web: <Table>Detail.tsx |
| `local_default_report.p` | procedure | 50 | 1 | service function (follow-up PR) |
| `local_default_lookup.i` | include | 41 | 1 | types.ts / repository |
| `tt_local_default.i` | include | 44 | 1 | types.ts / repository |
| `local_default_val.p` | procedure | 28 | 1 | validation.ts + Pydantic model |
| `local_default_batch.p` | procedure | 43 | 1 | scheduled job (wave 4 batch platform) |
| `local_default_export.p` | procedure | 44 | 1 | scheduled job (wave 4 batch platform) |
| `local_default_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `LocalDefaultBE.cls` | class | 93 | 2 | Pydantic model + router |
| `trg/write_local_default.p` | trigger | 76 | 2 | API audit middleware |
| `trg/delete_local_default.p` | trigger | 40 | 1 | API audit middleware |
| `si_local_default.p` | procedure | 59 | 3 | FastAPI router |
| `territory_assign.p` | procedure | 217 | 6 | service function (follow-up PR) |
| `quota_calc.p` | procedure | 316 | 6 | service function (follow-up PR) |
| `rep_performance.w` | ui | 252 | 6 | service function (follow-up PR) |
| `quota_rollover.p` | procedure | 221 | 5 | service function (follow-up PR) |
| `region_sales_rpt.p` | procedure | 153 | 4 | service function (follow-up PR) |
| `commission_calc.p` | procedure | 173 | 3 | service function (follow-up PR) |
| `locale_defaults_sync.p` | procedure | 156 | 3 | service function (follow-up PR) |
| `territory_realign.p` | procedure | 203 | 5 | service function (follow-up PR) |
| `st_defs.i` | include | 50 | 1 | shared library |
| `st_menu.w` | ui | 107 | 3 | routes.tsx |
