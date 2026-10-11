&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : sm_menu.w
    Purpose     : Supplier Management menu
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE lAllowed AS LOGICAL NO-UNDO.
DEFINE SUB-MENU mProg
    MENU-ITEM m0 LABEL "Supplier maintenance"
    MENU-ITEM m1 LABEL "Supplier report"
    MENU-ITEM m2 LABEL "SupplierItemXref maintenance"
    MENU-ITEM m3 LABEL "SupplierItemXref report"
    MENU-ITEM m4 LABEL "Supplier onboarding and item cross refer"
    MENU-ITEM m5 LABEL "On-time delivery and discount scorecard"
    MENU-ITEM m6 LABEL "Import supplier catalogue into item cros"
    MENU-ITEM m7 LABEL "Quarterly supplier review extraction"
    MENU-ITEM m8 LABEL "Spend by supplier and month"
    MENU-ITEM m9 LABEL "Supplier portal login audit and lockout"
    MENU-ITEM m10 LABEL "Remove cross references for discontinued"
    MENU-ITEM m11 LABEL "Freight cost estimate per supplier"
    .
DEFINE MENU mbMain MENUBAR SUB-MENU mProg LABEL "&Supplier Management".

ON CHOOSE OF MENU-ITEM m0 DO:
  RUN shared/security.p (INPUT "supplier-management/supplier_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN supplier-management/supplier_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m1 DO:
  RUN shared/security.p (INPUT "supplier-management/supplier_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN supplier-management/supplier_report.p.
END.

ON CHOOSE OF MENU-ITEM m2 DO:
  RUN shared/security.p (INPUT "supplier-management/supplier_item_xref_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN supplier-management/supplier_item_xref_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m3 DO:
  RUN shared/security.p (INPUT "supplier-management/supplier_item_xref_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN supplier-management/supplier_item_xref_report.p.
END.

ON CHOOSE OF MENU-ITEM m4 DO:
  RUN shared/security.p (INPUT "supplier-management/supplier_onboard.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN supplier-management/supplier_onboard.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m5 DO:
  RUN shared/security.p (INPUT "supplier-management/supplier_scorecard.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN supplier-management/supplier_scorecard.p.
END.

ON CHOOSE OF MENU-ITEM m6 DO:
  RUN shared/security.p (INPUT "supplier-management/supplier_item_sync.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN supplier-management/supplier_item_sync.p.
END.

ON CHOOSE OF MENU-ITEM m7 DO:
  RUN shared/security.p (INPUT "supplier-management/supplier_review_batch.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN supplier-management/supplier_review_batch.p.
END.

ON CHOOSE OF MENU-ITEM m8 DO:
  RUN shared/security.p (INPUT "supplier-management/supplier_spend_rpt.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN supplier-management/supplier_spend_rpt.p.
END.

ON CHOOSE OF MENU-ITEM m9 DO:
  RUN shared/security.p (INPUT "supplier-management/supplier_login_audit.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN supplier-management/supplier_login_audit.p.
END.

ON CHOOSE OF MENU-ITEM m10 DO:
  RUN shared/security.p (INPUT "supplier-management/xref_cleanup.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN supplier-management/xref_cleanup.p.
END.

ON CHOOSE OF MENU-ITEM m11 DO:
  RUN shared/security.p (INPUT "supplier-management/supplier_shipcost.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN supplier-management/supplier_shipcost.p.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Supplier Management" MENUBAR = MENU mbMain:HANDLE.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

