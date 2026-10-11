&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : hr_menu.w
    Purpose     : HR & Payroll menu
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE lAllowed AS LOGICAL NO-UNDO.
DEFINE SUB-MENU mProg
    MENU-ITEM m0 LABEL "Employee maintenance"
    MENU-ITEM m1 LABEL "Employee report"
    MENU-ITEM m2 LABEL "Department maintenance"
    MENU-ITEM m3 LABEL "Department report"
    MENU-ITEM m4 LABEL "Benefits maintenance"
    MENU-ITEM m5 LABEL "Benefits report"
    MENU-ITEM m6 LABEL "Family maintenance"
    MENU-ITEM m7 LABEL "Family report"
    MENU-ITEM m8 LABEL "TimeSheet maintenance"
    MENU-ITEM m9 LABEL "TimeSheet report"
    MENU-ITEM m10 LABEL "Vacation maintenance"
    MENU-ITEM m11 LABEL "Vacation report"
    MENU-ITEM m12 LABEL "Bi-weekly payroll run"
    MENU-ITEM m13 LABEL "Overtime and premium hours"
    MENU-ITEM m14 LABEL "Vacation and sick day accrual"
    MENU-ITEM m15 LABEL "Benefits enrolment"
    MENU-ITEM m16 LABEL "Headcount by department"
    MENU-ITEM m17 LABEL "Time clock import"
    MENU-ITEM m18 LABEL "Dependent eligibility audit"
    MENU-ITEM m19 LABEL "Department and employee directory"
    MENU-ITEM m20 LABEL "Year-end tax extract"
    .
DEFINE MENU mbMain MENUBAR SUB-MENU mProg LABEL "&HR and Payroll".

ON CHOOSE OF MENU-ITEM m0 DO:
  RUN shared/security.p (INPUT "hr-payroll/employee_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/employee_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m1 DO:
  RUN shared/security.p (INPUT "hr-payroll/employee_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/employee_report.p.
END.

ON CHOOSE OF MENU-ITEM m2 DO:
  RUN shared/security.p (INPUT "hr-payroll/department_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/department_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m3 DO:
  RUN shared/security.p (INPUT "hr-payroll/department_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/department_report.p.
END.

ON CHOOSE OF MENU-ITEM m4 DO:
  RUN shared/security.p (INPUT "hr-payroll/benefits_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/benefits_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m5 DO:
  RUN shared/security.p (INPUT "hr-payroll/benefits_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/benefits_report.p.
END.

ON CHOOSE OF MENU-ITEM m6 DO:
  RUN shared/security.p (INPUT "hr-payroll/family_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/family_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m7 DO:
  RUN shared/security.p (INPUT "hr-payroll/family_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/family_report.p.
END.

ON CHOOSE OF MENU-ITEM m8 DO:
  RUN shared/security.p (INPUT "hr-payroll/time_sheet_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/time_sheet_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m9 DO:
  RUN shared/security.p (INPUT "hr-payroll/time_sheet_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/time_sheet_report.p.
END.

ON CHOOSE OF MENU-ITEM m10 DO:
  RUN shared/security.p (INPUT "hr-payroll/vacation_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/vacation_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m11 DO:
  RUN shared/security.p (INPUT "hr-payroll/vacation_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/vacation_report.p.
END.

ON CHOOSE OF MENU-ITEM m12 DO:
  RUN shared/security.p (INPUT "hr-payroll/payroll_run.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/payroll_run.p.
END.

ON CHOOSE OF MENU-ITEM m13 DO:
  RUN shared/security.p (INPUT "hr-payroll/overtime_calc.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/overtime_calc.p.
END.

ON CHOOSE OF MENU-ITEM m14 DO:
  RUN shared/security.p (INPUT "hr-payroll/vacation_accrue.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/vacation_accrue.p.
END.

ON CHOOSE OF MENU-ITEM m15 DO:
  RUN shared/security.p (INPUT "hr-payroll/benefits_enrol.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/benefits_enrol.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m16 DO:
  RUN shared/security.p (INPUT "hr-payroll/headcount_rpt.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/headcount_rpt.p.
END.

ON CHOOSE OF MENU-ITEM m17 DO:
  RUN shared/security.p (INPUT "hr-payroll/timesheet_import.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/timesheet_import.p.
END.

ON CHOOSE OF MENU-ITEM m18 DO:
  RUN shared/security.p (INPUT "hr-payroll/dependent_audit.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/dependent_audit.p.
END.

ON CHOOSE OF MENU-ITEM m19 DO:
  RUN shared/security.p (INPUT "hr-payroll/org_chart.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/org_chart.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m20 DO:
  RUN shared/security.p (INPUT "hr-payroll/w2_extract.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/w2_extract.p.
END.

CREATE WINDOW wWin ASSIGN TITLE = "HR & Payroll" MENUBAR = MENU mbMain:HANDLE.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

