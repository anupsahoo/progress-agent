&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : cr_menu.w
    Purpose     : Credit Management menu
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE lAllowed AS LOGICAL NO-UNDO.
DEFINE SUB-MENU mProg
    MENU-ITEM m0 LABEL "RefCall maintenance"
    MENU-ITEM m1 LABEL "RefCall report"
    MENU-ITEM m2 LABEL "Place and release credit holds"
    MENU-ITEM m3 LABEL "Credit limit recommendation"
    MENU-ITEM m4 LABEL "Collections work queue and call log"
    MENU-ITEM m5 LABEL "Dunning letters for overdue invoices"
    MENU-ITEM m6 LABEL "Credit exposure by customer"
    MENU-ITEM m7 LABEL "Credit bureau score import"
    MENU-ITEM m8 LABEL "Reference call follow-up scheduling"
    MENU-ITEM m9 LABEL "Bad debt write off"
    MENU-ITEM m10 LABEL "Days sales outstanding"
    MENU-ITEM m11 LABEL "Credit review approval screen"
    MENU-ITEM m12 LABEL "Daily over-limit alerts"
    .
DEFINE MENU mbMain MENUBAR SUB-MENU mProg LABEL "&Credit Management".

ON CHOOSE OF MENU-ITEM m0 DO:
  RUN shared/security.p (INPUT "credit-management/ref_call_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN credit-management/ref_call_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m1 DO:
  RUN shared/security.p (INPUT "credit-management/ref_call_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN credit-management/ref_call_report.p.
END.

ON CHOOSE OF MENU-ITEM m2 DO:
  RUN shared/security.p (INPUT "credit-management/credit_hold.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN credit-management/credit_hold.p.
END.

ON CHOOSE OF MENU-ITEM m3 DO:
  RUN shared/security.p (INPUT "credit-management/credit_limit_calc.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN credit-management/credit_limit_calc.p.
END.

ON CHOOSE OF MENU-ITEM m4 DO:
  RUN shared/security.p (INPUT "credit-management/collections.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN credit-management/collections.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m5 DO:
  RUN shared/security.p (INPUT "credit-management/dunning_batch.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN credit-management/dunning_batch.p.
END.

ON CHOOSE OF MENU-ITEM m6 DO:
  RUN shared/security.p (INPUT "credit-management/credit_exposure_rpt.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN credit-management/credit_exposure_rpt.p.
END.

ON CHOOSE OF MENU-ITEM m7 DO:
  RUN shared/security.p (INPUT "credit-management/credit_bureau_if.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN credit-management/credit_bureau_if.p.
END.

ON CHOOSE OF MENU-ITEM m8 DO:
  RUN shared/security.p (INPUT "credit-management/refcall_followup.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN credit-management/refcall_followup.p.
END.

ON CHOOSE OF MENU-ITEM m9 DO:
  RUN shared/security.p (INPUT "credit-management/bad_debt_writeoff.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN credit-management/bad_debt_writeoff.p.
END.

ON CHOOSE OF MENU-ITEM m10 DO:
  RUN shared/security.p (INPUT "credit-management/dso_calc.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN credit-management/dso_calc.p.
END.

ON CHOOSE OF MENU-ITEM m11 DO:
  RUN shared/security.p (INPUT "credit-management/credit_review.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN credit-management/credit_review.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m12 DO:
  RUN shared/security.p (INPUT "credit-management/credit_alert.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN credit-management/credit_alert.p.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Credit Management" MENUBAR = MENU mbMain:HANDLE.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

