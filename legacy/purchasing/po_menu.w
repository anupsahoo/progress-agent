&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : po_menu.w
    Purpose     : Purchasing menu
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE lAllowed AS LOGICAL NO-UNDO.
DEFINE SUB-MENU mProg
    MENU-ITEM m0 LABEL "PurchaseOrder maintenance"
    MENU-ITEM m1 LABEL "PurchaseOrder report"
    MENU-ITEM m2 LABEL "POLine maintenance"
    MENU-ITEM m3 LABEL "POLine report"
    MENU-ITEM m4 LABEL "Raise purchase orders from reorder sugge"
    MENU-ITEM m5 LABEL "Goods receipt against purchase order"
    MENU-ITEM m6 LABEL "Post receipts to stock and close lines"
    MENU-ITEM m7 LABEL "Line pricing with supplier discount"
    MENU-ITEM m8 LABEL "Open purchase orders by supplier"
    MENU-ITEM m9 LABEL "Daily overdue PO expedite list"
    MENU-ITEM m10 LABEL "EDI 850 outbound purchase orders"
    MENU-ITEM m11 LABEL "Purchase order approval workflow"
    MENU-ITEM m12 LABEL "Close fully received purchase orders"
    .
DEFINE MENU mbMain MENUBAR SUB-MENU mProg LABEL "&Purchasing".

ON CHOOSE OF MENU-ITEM m0 DO:
  RUN shared/security.p (INPUT "purchasing/purchase_order_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN purchasing/purchase_order_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m1 DO:
  RUN shared/security.p (INPUT "purchasing/purchase_order_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN purchasing/purchase_order_report.p.
END.

ON CHOOSE OF MENU-ITEM m2 DO:
  RUN shared/security.p (INPUT "purchasing/poline_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN purchasing/poline_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m3 DO:
  RUN shared/security.p (INPUT "purchasing/poline_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN purchasing/poline_report.p.
END.

ON CHOOSE OF MENU-ITEM m4 DO:
  RUN shared/security.p (INPUT "purchasing/po_create_from_reorder.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN purchasing/po_create_from_reorder.p.
END.

ON CHOOSE OF MENU-ITEM m5 DO:
  RUN shared/security.p (INPUT "purchasing/po_receive.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN purchasing/po_receive.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m6 DO:
  RUN shared/security.p (INPUT "purchasing/po_receipt_post.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN purchasing/po_receipt_post.p.
END.

ON CHOOSE OF MENU-ITEM m7 DO:
  RUN shared/security.p (INPUT "purchasing/po_price_calc.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN purchasing/po_price_calc.p.
END.

ON CHOOSE OF MENU-ITEM m8 DO:
  RUN shared/security.p (INPUT "purchasing/po_open_rpt.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN purchasing/po_open_rpt.p.
END.

ON CHOOSE OF MENU-ITEM m9 DO:
  RUN shared/security.p (INPUT "purchasing/po_expedite_batch.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN purchasing/po_expedite_batch.p.
END.

ON CHOOSE OF MENU-ITEM m10 DO:
  RUN shared/security.p (INPUT "purchasing/po_edi_850.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN purchasing/po_edi_850.p.
END.

ON CHOOSE OF MENU-ITEM m11 DO:
  RUN shared/security.p (INPUT "purchasing/po_approve.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN purchasing/po_approve.p.
END.

ON CHOOSE OF MENU-ITEM m12 DO:
  RUN shared/security.p (INPUT "purchasing/po_close.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN purchasing/po_close.p.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Purchasing" MENUBAR = MENU mbMain:HANDLE.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

