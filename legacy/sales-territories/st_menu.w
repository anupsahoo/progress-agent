&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : st_menu.w
    Purpose     : Sales & Territories menu
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE lAllowed AS LOGICAL NO-UNDO.
DEFINE SUB-MENU mProg
    MENU-ITEM m0 LABEL "Salesrep maintenance"
    MENU-ITEM m1 LABEL "Salesrep report"
    MENU-ITEM m2 LABEL "State maintenance"
    MENU-ITEM m3 LABEL "State report"
    MENU-ITEM m4 LABEL "LocalDefault maintenance"
    MENU-ITEM m5 LABEL "LocalDefault report"
    MENU-ITEM m6 LABEL "Assign customers to reps by state and re"
    MENU-ITEM m7 LABEL "Monthly quota attainment per rep"
    MENU-ITEM m8 LABEL "Rep performance dashboard"
    MENU-ITEM m9 LABEL "Year-end quota roll forward"
    MENU-ITEM m10 LABEL "Sales by region and state"
    MENU-ITEM m11 LABEL "Commission accrual from shipped orders"
    MENU-ITEM m12 LABEL "Sync country locale defaults from HQ"
    MENU-ITEM m13 LABEL "Re-align territories when a rep leaves"
    .
DEFINE MENU mbMain MENUBAR SUB-MENU mProg LABEL "&Sales and Territories".

ON CHOOSE OF MENU-ITEM m0 DO:
  RUN shared/security.p (INPUT "sales-territories/salesrep_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN sales-territories/salesrep_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m1 DO:
  RUN shared/security.p (INPUT "sales-territories/salesrep_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN sales-territories/salesrep_report.p.
END.

ON CHOOSE OF MENU-ITEM m2 DO:
  RUN shared/security.p (INPUT "sales-territories/state_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN sales-territories/state_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m3 DO:
  RUN shared/security.p (INPUT "sales-territories/state_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN sales-territories/state_report.p.
END.

ON CHOOSE OF MENU-ITEM m4 DO:
  RUN shared/security.p (INPUT "sales-territories/local_default_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN sales-territories/local_default_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m5 DO:
  RUN shared/security.p (INPUT "sales-territories/local_default_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN sales-territories/local_default_report.p.
END.

ON CHOOSE OF MENU-ITEM m6 DO:
  RUN shared/security.p (INPUT "sales-territories/territory_assign.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN sales-territories/territory_assign.p.
END.

ON CHOOSE OF MENU-ITEM m7 DO:
  RUN shared/security.p (INPUT "sales-territories/quota_calc.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN sales-territories/quota_calc.p.
END.

ON CHOOSE OF MENU-ITEM m8 DO:
  RUN shared/security.p (INPUT "sales-territories/rep_performance.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN sales-territories/rep_performance.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m9 DO:
  RUN shared/security.p (INPUT "sales-territories/quota_rollover.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN sales-territories/quota_rollover.p.
END.

ON CHOOSE OF MENU-ITEM m10 DO:
  RUN shared/security.p (INPUT "sales-territories/region_sales_rpt.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN sales-territories/region_sales_rpt.p.
END.

ON CHOOSE OF MENU-ITEM m11 DO:
  RUN shared/security.p (INPUT "sales-territories/commission_calc.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN sales-territories/commission_calc.p.
END.

ON CHOOSE OF MENU-ITEM m12 DO:
  RUN shared/security.p (INPUT "sales-territories/locale_defaults_sync.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN sales-territories/locale_defaults_sync.p.
END.

ON CHOOSE OF MENU-ITEM m13 DO:
  RUN shared/security.p (INPUT "sales-territories/territory_realign.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN sales-territories/territory_realign.p.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Sales & Territories" MENUBAR = MENU mbMain:HANDLE.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

