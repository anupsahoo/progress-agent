&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : in_menu.w
    Purpose     : Inventory menu
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE lAllowed AS LOGICAL NO-UNDO.
DEFINE SUB-MENU mProg
    MENU-ITEM m0 LABEL "Item maintenance"
    MENU-ITEM m1 LABEL "Item report"
    MENU-ITEM m2 LABEL "InventoryTrans maintenance"
    MENU-ITEM m3 LABEL "InventoryTrans report"
    MENU-ITEM m4 LABEL "Allocate on-hand stock to open order lin"
    MENU-ITEM m5 LABEL "Reorder point and quantity calculation"
    MENU-ITEM m6 LABEL "Stock by item, bin and warehouse"
    MENU-ITEM m7 LABEL "Month-end inventory valuation"
    MENU-ITEM m8 LABEL "Inventory movement by transaction type"
    MENU-ITEM m9 LABEL "Stock adjustment with audit trail"
    MENU-ITEM m10 LABEL "Catalogue export to the web shop"
    MENU-ITEM m11 LABEL "ABC classification by value and velocity"
    MENU-ITEM m12 LABEL "Post inventory transactions to item bala"
    .
DEFINE MENU mbMain MENUBAR SUB-MENU mProg LABEL "&Inventory".

ON CHOOSE OF MENU-ITEM m0 DO:
  RUN shared/security.p (INPUT "inventory/item_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN inventory/item_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m1 DO:
  RUN shared/security.p (INPUT "inventory/item_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN inventory/item_report.p.
END.

ON CHOOSE OF MENU-ITEM m2 DO:
  RUN shared/security.p (INPUT "inventory/inventory_trans_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN inventory/inventory_trans_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m3 DO:
  RUN shared/security.p (INPUT "inventory/inventory_trans_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN inventory/inventory_trans_report.p.
END.

ON CHOOSE OF MENU-ITEM m4 DO:
  RUN shared/security.p (INPUT "inventory/stock_allocate.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN inventory/stock_allocate.p.
END.

ON CHOOSE OF MENU-ITEM m5 DO:
  RUN shared/security.p (INPUT "inventory/reorder_calc.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN inventory/reorder_calc.p.
END.

ON CHOOSE OF MENU-ITEM m6 DO:
  RUN shared/security.p (INPUT "inventory/stock_inquiry.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN inventory/stock_inquiry.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m7 DO:
  RUN shared/security.p (INPUT "inventory/inv_valuation.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN inventory/inv_valuation.p.
END.

ON CHOOSE OF MENU-ITEM m8 DO:
  RUN shared/security.p (INPUT "inventory/inv_movement_rpt.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN inventory/inv_movement_rpt.p.
END.

ON CHOOSE OF MENU-ITEM m9 DO:
  RUN shared/security.p (INPUT "inventory/inv_adjust.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN inventory/inv_adjust.p.
END.

ON CHOOSE OF MENU-ITEM m10 DO:
  RUN shared/security.p (INPUT "inventory/catalog_export.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN inventory/catalog_export.p.
END.

ON CHOOSE OF MENU-ITEM m11 DO:
  RUN shared/security.p (INPUT "inventory/abc_classify.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN inventory/abc_classify.p.
END.

ON CHOOSE OF MENU-ITEM m12 DO:
  RUN shared/security.p (INPUT "inventory/inv_trans_post.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN inventory/inv_trans_post.p.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Inventory" MENUBAR = MENU mbMain:HANDLE.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

