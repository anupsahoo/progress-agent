# HR & Payroll: program map

95 legacy programs and where each lands in the modern stack.

| Legacy program | Kind | Lines | Complexity | Modern home |
|---|---|---|---|---|
| `employee_maint.p` | procedure | 140 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `employee_browse.w` | ui | 192 | 4 | web: <Table>List.tsx |
| `employee_inquiry.w` | ui | 99 | 2 | web: <Table>Detail.tsx |
| `employee_report.p` | procedure | 62 | 1 | service function (follow-up PR) |
| `employee_lookup.i` | include | 44 | 1 | types.ts / repository |
| `tt_employee.i` | include | 56 | 1 | types.ts / repository |
| `employee_val.p` | procedure | 38 | 1 | validation.ts + Pydantic model |
| `employee_batch.p` | procedure | 46 | 1 | scheduled job (wave 4 batch platform) |
| `employee_export.p` | procedure | 44 | 1 | scheduled job (wave 4 batch platform) |
| `employee_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `EmployeeBE.cls` | class | 111 | 2 | Pydantic model + router |
| `trg/write_employee.p` | trigger | 108 | 3 | API audit middleware |
| `trg/delete_employee.p` | trigger | 61 | 1 | API audit middleware |
| `si_employee.p` | procedure | 59 | 3 | FastAPI router |
| `department_maint.p` | procedure | 95 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `department_browse.w` | ui | 186 | 4 | web: <Table>List.tsx |
| `department_inquiry.w` | ui | 71 | 2 | web: <Table>Detail.tsx |
| `department_report.p` | procedure | 51 | 1 | service function (follow-up PR) |
| `department_lookup.i` | include | 43 | 1 | types.ts / repository |
| `tt_department.i` | include | 34 | 1 | types.ts / repository |
| `department_val.p` | procedure | 30 | 1 | validation.ts + Pydantic model |
| `department_batch.p` | procedure | 43 | 1 | scheduled job (wave 4 batch platform) |
| `department_export.p` | procedure | 41 | 1 | scheduled job (wave 4 batch platform) |
| `department_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `DepartmentBE.cls` | class | 70 | 2 | Pydantic model + router |
| `trg/write_department.p` | trigger | 51 | 1 | API audit middleware |
| `trg/delete_department.p` | trigger | 46 | 1 | API audit middleware |
| `si_department.p` | procedure | 59 | 3 | FastAPI router |
| `benefits_maint.p` | procedure | 110 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `benefits_browse.w` | ui | 191 | 4 | web: <Table>List.tsx |
| `benefits_inquiry.w` | ui | 81 | 2 | web: <Table>Detail.tsx |
| `benefits_report.p` | procedure | 75 | 1 | service function (follow-up PR) |
| `benefits_lookup.i` | include | 44 | 1 | types.ts / repository |
| `tt_benefits.i` | include | 43 | 1 | types.ts / repository |
| `benefits_val.p` | procedure | 32 | 1 | validation.ts + Pydantic model |
| `benefits_batch.p` | procedure | 45 | 1 | scheduled job (wave 4 batch platform) |
| `benefits_export.p` | procedure | 44 | 1 | scheduled job (wave 4 batch platform) |
| `benefits_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `BenefitsBE.cls` | class | 86 | 2 | Pydantic model + router |
| `trg/write_benefits.p` | trigger | 69 | 2 | API audit middleware |
| `trg/delete_benefits.p` | trigger | 60 | 1 | API audit middleware |
| `si_benefits.p` | procedure | 59 | 3 | FastAPI router |
| `family_maint.p` | procedure | 126 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `family_browse.w` | ui | 190 | 4 | web: <Table>List.tsx |
| `family_inquiry.w` | ui | 79 | 2 | web: <Table>Detail.tsx |
| `family_report.p` | procedure | 48 | 1 | service function (follow-up PR) |
| `family_lookup.i` | include | 43 | 1 | types.ts / repository |
| `tt_family.i` | include | 38 | 1 | types.ts / repository |
| `family_val.p` | procedure | 40 | 1 | validation.ts + Pydantic model |
| `family_batch.p` | procedure | 43 | 1 | scheduled job (wave 4 batch platform) |
| `family_export.p` | procedure | 46 | 1 | scheduled job (wave 4 batch platform) |
| `family_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `FamilyBE.cls` | class | 81 | 2 | Pydantic model + router |
| `trg/write_family.p` | trigger | 66 | 1 | API audit middleware |
| `trg/delete_family.p` | trigger | 39 | 1 | API audit middleware |
| `si_family.p` | procedure | 59 | 3 | FastAPI router |
| `time_sheet_maint.p` | procedure | 136 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `time_sheet_browse.w` | ui | 192 | 4 | web: <Table>List.tsx |
| `time_sheet_inquiry.w` | ui | 85 | 2 | web: <Table>Detail.tsx |
| `time_sheet_report.p` | procedure | 61 | 1 | service function (follow-up PR) |
| `time_sheet_lookup.i` | include | 42 | 1 | types.ts / repository |
| `tt_time_sheet.i` | include | 43 | 1 | types.ts / repository |
| `time_sheet_val.p` | procedure | 32 | 1 | validation.ts + Pydantic model |
| `time_sheet_batch.p` | procedure | 49 | 1 | scheduled job (wave 4 batch platform) |
| `time_sheet_export.p` | procedure | 46 | 1 | scheduled job (wave 4 batch platform) |
| `time_sheet_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `TimeSheetBE.cls` | class | 91 | 2 | Pydantic model + router |
| `trg/write_time_sheet.p` | trigger | 80 | 2 | API audit middleware |
| `trg/delete_time_sheet.p` | trigger | 39 | 1 | API audit middleware |
| `si_time_sheet.p` | procedure | 59 | 3 | FastAPI router |
| `vacation_maint.p` | procedure | 118 | 2 | web: <Table>Edit.tsx + PUT/POST |
| `vacation_browse.w` | ui | 186 | 4 | web: <Table>List.tsx |
| `vacation_inquiry.w` | ui | 73 | 2 | web: <Table>Detail.tsx |
| `vacation_report.p` | procedure | 48 | 1 | service function (follow-up PR) |
| `vacation_lookup.i` | include | 40 | 1 | types.ts / repository |
| `tt_vacation.i` | include | 38 | 1 | types.ts / repository |
| `vacation_val.p` | procedure | 34 | 1 | validation.ts + Pydantic model |
| `vacation_batch.p` | procedure | 42 | 1 | scheduled job (wave 4 batch platform) |
| `vacation_export.p` | procedure | 44 | 1 | scheduled job (wave 4 batch platform) |
| `vacation_import.p` | procedure | 45 | 2 | scheduled job (wave 4 batch platform) |
| `VacationBE.cls` | class | 75 | 2 | Pydantic model + router |
| `trg/write_vacation.p` | trigger | 55 | 1 | API audit middleware |
| `trg/delete_vacation.p` | trigger | 39 | 1 | API audit middleware |
| `si_vacation.p` | procedure | 59 | 3 | FastAPI router |
| `payroll_run.p` | procedure | 291 | 7 | service function (follow-up PR) |
| `overtime_calc.p` | procedure | 446 | 10 | service function (follow-up PR) |
| `vacation_accrue.p` | procedure | 105 | 3 | service function (follow-up PR) |
| `benefits_enrol.w` | ui | 179 | 4 | service function (follow-up PR) |
| `headcount_rpt.p` | procedure | 223 | 6 | service function (follow-up PR) |
| `timesheet_import.p` | procedure | 40 | 1 | scheduled job (wave 4 batch platform) |
| `dependent_audit.p` | procedure | 227 | 6 | service function (follow-up PR) |
| `org_chart.w` | ui | 191 | 4 | service function (follow-up PR) |
| `w2_extract.p` | procedure | 116 | 3 | service function (follow-up PR) |
| `hr_defs.i` | include | 55 | 2 | shared library |
| `hr_menu.w` | ui | 149 | 5 | routes.tsx |
