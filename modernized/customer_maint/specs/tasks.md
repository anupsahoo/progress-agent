# Tasks — customer_maint

Units of work dispatched by the Orchestrator. Each must pass the harness before the next human gate.

- [x] T1 Extract business rules R1–R7 (ABL Analyzer)
- [x] T2 Map schema `customer.d` → typed model (Data Mapper)
- [ ] T3 Build React form + service (UI Converter) → covers R1–R4, R7
- [ ] T4 Build FastAPI GET/PUT with ETag (API Converter) → covers R1, R2, R4–R6
- [ ] T5 Generate automated UI tests from R1–R4 (Test Agent)
- [ ] T6 Generate API contract tests + parity cases (Test Agent, Parity Checker)
- [ ] T7 Reviewer: LLM-as-judge against this spec; open PRs (PR Agent)
