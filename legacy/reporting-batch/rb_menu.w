&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : rb_menu.w
    Purpose     : Reporting & Batch menu
    Module      : Reporting & Batch
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE lAllowed AS LOGICAL NO-UNDO.
DEFINE SUB-MENU mProg
    MENU-ITEM m0 LABEL "Daily sales flash report"
    MENU-ITEM m1 LABEL "Monthly KPI pack"
    MENU-ITEM m2 LABEL "End-of-day batch driver"
    MENU-ITEM m3 LABEL "End-of-month batch driver"
    MENU-ITEM m4 LABEL "Sales cube extract for the data warehous"
    MENU-ITEM m5 LABEL "Customer dimension extract"
    MENU-ITEM m6 LABEL "Sales rep league table"
    MENU-ITEM m7 LABEL "Item velocity report"
    MENU-ITEM m8 LABEL "Report scheduler"
    MENU-ITEM m9 LABEL "Spooled report viewer"
    MENU-ITEM m10 LABEL "Revenue recognition schedule"
    MENU-ITEM m11 LABEL "Gross margin by item and customer"
    MENU-ITEM m12 LABEL "History archive batch"
    MENU-ITEM m13 LABEL "Auditor extract"
    MENU-ITEM m14 LABEL "Batch exception report"
    MENU-ITEM m15 LABEL "Batch job monitor"
    .
DEFINE MENU mbMain MENUBAR SUB-MENU mProg LABEL "&Reporting and Batch".

ON CHOOSE OF MENU-ITEM m0 DO:
  RUN shared/security.p (INPUT "reporting-batch/daily_sales_flash.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/daily_sales_flash.p.
END.

ON CHOOSE OF MENU-ITEM m1 DO:
  RUN shared/security.p (INPUT "reporting-batch/monthly_kpi.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/monthly_kpi.p.
END.

ON CHOOSE OF MENU-ITEM m2 DO:
  RUN shared/security.p (INPUT "reporting-batch/eod_batch_driver.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/eod_batch_driver.p.
END.

ON CHOOSE OF MENU-ITEM m3 DO:
  RUN shared/security.p (INPUT "reporting-batch/eom_batch_driver.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/eom_batch_driver.p.
END.

ON CHOOSE OF MENU-ITEM m4 DO:
  RUN shared/security.p (INPUT "reporting-batch/sales_cube_extract.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/sales_cube_extract.p.
END.

ON CHOOSE OF MENU-ITEM m5 DO:
  RUN shared/security.p (INPUT "reporting-batch/customer_extract.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/customer_extract.p.
END.

ON CHOOSE OF MENU-ITEM m6 DO:
  RUN shared/security.p (INPUT "reporting-batch/rep_league_table.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/rep_league_table.p.
END.

ON CHOOSE OF MENU-ITEM m7 DO:
  RUN shared/security.p (INPUT "reporting-batch/item_velocity_rpt.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/item_velocity_rpt.p.
END.

ON CHOOSE OF MENU-ITEM m8 DO:
  RUN shared/security.p (INPUT "reporting-batch/report_scheduler.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/report_scheduler.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m9 DO:
  RUN shared/security.p (INPUT "reporting-batch/report_viewer.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/report_viewer.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m10 DO:
  RUN shared/security.p (INPUT "reporting-batch/revenue_recog.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/revenue_recog.p.
END.

ON CHOOSE OF MENU-ITEM m11 DO:
  RUN shared/security.p (INPUT "reporting-batch/margin_calc.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/margin_calc.p.
END.

ON CHOOSE OF MENU-ITEM m12 DO:
  RUN shared/security.p (INPUT "reporting-batch/archive_batch.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/archive_batch.p.
END.

ON CHOOSE OF MENU-ITEM m13 DO:
  RUN shared/security.p (INPUT "reporting-batch/audit_extract.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/audit_extract.p.
END.

ON CHOOSE OF MENU-ITEM m14 DO:
  RUN shared/security.p (INPUT "reporting-batch/exception_rpt.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/exception_rpt.p.
END.

ON CHOOSE OF MENU-ITEM m15 DO:
  RUN shared/security.p (INPUT "reporting-batch/batch_monitor.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/batch_monitor.w PERSISTENT.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Reporting & Batch" MENUBAR = MENU mbMain:HANDLE.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

