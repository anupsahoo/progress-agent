&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : wh_menu.w
    Purpose     : Warehousing menu
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE lAllowed AS LOGICAL NO-UNDO.
DEFINE SUB-MENU mProg
    MENU-ITEM m0 LABEL "Warehouse maintenance"
    MENU-ITEM m1 LABEL "Warehouse report"
    MENU-ITEM m2 LABEL "Bin maintenance"
    MENU-ITEM m3 LABEL "Bin report"
    MENU-ITEM m4 LABEL "Move stock between bins"
    MENU-ITEM m5 LABEL "Cycle count and variance posting"
    MENU-ITEM m6 LABEL "Put-away bin suggestion for receipts"
    MENU-ITEM m7 LABEL "Warehouse capacity and utilisation"
    MENU-ITEM m8 LABEL "Overnight pick-face replenishment"
    MENU-ITEM m9 LABEL "Inter-warehouse stock transfer"
    MENU-ITEM m10 LABEL "RF scanner message interface"
    MENU-ITEM m11 LABEL "Warehouse layout maintenance"
    .
DEFINE MENU mbMain MENUBAR SUB-MENU mProg LABEL "&Warehousing".

ON CHOOSE OF MENU-ITEM m0 DO:
  RUN shared/security.p (INPUT "warehousing/warehouse_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN warehousing/warehouse_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m1 DO:
  RUN shared/security.p (INPUT "warehousing/warehouse_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN warehousing/warehouse_report.p.
END.

ON CHOOSE OF MENU-ITEM m2 DO:
  RUN shared/security.p (INPUT "warehousing/bin_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN warehousing/bin_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m3 DO:
  RUN shared/security.p (INPUT "warehousing/bin_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN warehousing/bin_report.p.
END.

ON CHOOSE OF MENU-ITEM m4 DO:
  RUN shared/security.p (INPUT "warehousing/bin_transfer.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN warehousing/bin_transfer.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m5 DO:
  RUN shared/security.p (INPUT "warehousing/cycle_count.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN warehousing/cycle_count.p.
END.

ON CHOOSE OF MENU-ITEM m6 DO:
  RUN shared/security.p (INPUT "warehousing/putaway_plan.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN warehousing/putaway_plan.p.
END.

ON CHOOSE OF MENU-ITEM m7 DO:
  RUN shared/security.p (INPUT "warehousing/wh_capacity_rpt.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN warehousing/wh_capacity_rpt.p.
END.

ON CHOOSE OF MENU-ITEM m8 DO:
  RUN shared/security.p (INPUT "warehousing/bin_replenish.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN warehousing/bin_replenish.p.
END.

ON CHOOSE OF MENU-ITEM m9 DO:
  RUN shared/security.p (INPUT "warehousing/wh_transfer.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN warehousing/wh_transfer.p.
END.

ON CHOOSE OF MENU-ITEM m10 DO:
  RUN shared/security.p (INPUT "warehousing/rf_scanner_if.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN warehousing/rf_scanner_if.p.
END.

ON CHOOSE OF MENU-ITEM m11 DO:
  RUN shared/security.p (INPUT "warehousing/wh_layout.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN warehousing/wh_layout.w PERSISTENT.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Warehousing" MENUBAR = MENU mbMain:HANDLE.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

