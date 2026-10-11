&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : oe_menu.w
    Purpose     : Order Entry menu
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE lAllowed AS LOGICAL NO-UNDO.
DEFINE SUB-MENU mProg
    MENU-ITEM m0 LABEL "Order maintenance"
    MENU-ITEM m1 LABEL "Order report"
    MENU-ITEM m2 LABEL "OrderLine maintenance"
    MENU-ITEM m3 LABEL "OrderLine report"
    MENU-ITEM m4 LABEL "Order entry: header, lines and pricing"
    MENU-ITEM m5 LABEL "Line pricing, discount and extended pric"
    MENU-ITEM m6 LABEL "Credit check before order release"
    MENU-ITEM m7 LABEL "Copy an existing order as a new order"
    MENU-ITEM m8 LABEL "Order status transitions"
    MENU-ITEM m9 LABEL "Order backlog by promise date"
    MENU-ITEM m10 LABEL "Import web shop orders"
    MENU-ITEM m11 LABEL "Archive and purge closed orders"
    MENU-ITEM m12 LABEL "Sales tax by ship-to state"
    MENU-ITEM m13 LABEL "Order inquiry by customer"
    .
DEFINE MENU mbMain MENUBAR SUB-MENU mProg LABEL "&Order Entry".

ON CHOOSE OF MENU-ITEM m0 DO:
  RUN shared/security.p (INPUT "order-entry/order_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-entry/order_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m1 DO:
  RUN shared/security.p (INPUT "order-entry/order_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-entry/order_report.p.
END.

ON CHOOSE OF MENU-ITEM m2 DO:
  RUN shared/security.p (INPUT "order-entry/order_line_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-entry/order_line_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m3 DO:
  RUN shared/security.p (INPUT "order-entry/order_line_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-entry/order_line_report.p.
END.

ON CHOOSE OF MENU-ITEM m4 DO:
  RUN shared/security.p (INPUT "order-entry/order_entry.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-entry/order_entry.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m5 DO:
  RUN shared/security.p (INPUT "order-entry/order_price.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-entry/order_price.p.
END.

ON CHOOSE OF MENU-ITEM m6 DO:
  RUN shared/security.p (INPUT "order-entry/order_credit_check.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-entry/order_credit_check.p.
END.

ON CHOOSE OF MENU-ITEM m7 DO:
  RUN shared/security.p (INPUT "order-entry/order_copy.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-entry/order_copy.p.
END.

ON CHOOSE OF MENU-ITEM m8 DO:
  RUN shared/security.p (INPUT "order-entry/order_status_upd.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-entry/order_status_upd.p.
END.

ON CHOOSE OF MENU-ITEM m9 DO:
  RUN shared/security.p (INPUT "order-entry/order_backlog_rpt.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-entry/order_backlog_rpt.p.
END.

ON CHOOSE OF MENU-ITEM m10 DO:
  RUN shared/security.p (INPUT "order-entry/order_web_import.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-entry/order_web_import.p.
END.

ON CHOOSE OF MENU-ITEM m11 DO:
  RUN shared/security.p (INPUT "order-entry/order_purge.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-entry/order_purge.p.
END.

ON CHOOSE OF MENU-ITEM m12 DO:
  RUN shared/security.p (INPUT "order-entry/order_tax_calc.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-entry/order_tax_calc.p.
END.

ON CHOOSE OF MENU-ITEM m13 DO:
  RUN shared/security.p (INPUT "order-entry/order_inquiry.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-entry/order_inquiry.w PERSISTENT.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Order Entry" MENUBAR = MENU mbMain:HANDLE.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

