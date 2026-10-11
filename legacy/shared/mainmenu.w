&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : main_menu.w
    Purpose     : Sports2000 Enterprise menu
    Module      : Sports2000 Enterprise
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE lAllowed AS LOGICAL NO-UNDO.
DEFINE SUB-MENU mProg
    MENU-ITEM m0 LABEL "Customer Management"
    MENU-ITEM m1 LABEL "Sales & Territories"
    MENU-ITEM m2 LABEL "Supplier Management"
    MENU-ITEM m3 LABEL "Inventory"
    MENU-ITEM m4 LABEL "Warehousing"
    MENU-ITEM m5 LABEL "Purchasing"
    MENU-ITEM m6 LABEL "Order Entry"
    MENU-ITEM m7 LABEL "Order Fulfilment"
    MENU-ITEM m8 LABEL "Credit Management"
    MENU-ITEM m9 LABEL "Billing & Invoicing"
    MENU-ITEM m10 LABEL "HR & Payroll"
    MENU-ITEM m11 LABEL "Reporting & Batch"
    .
DEFINE MENU mbMain MENUBAR SUB-MENU mProg LABEL "&Sports2000 Enterprise".

ON CHOOSE OF MENU-ITEM m0 DO:
  RUN shared/security.p (INPUT "customer-management/cm_menu.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN customer-management/cm_menu.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m1 DO:
  RUN shared/security.p (INPUT "sales-territories/st_menu.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN sales-territories/st_menu.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m2 DO:
  RUN shared/security.p (INPUT "supplier-management/sm_menu.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN supplier-management/sm_menu.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m3 DO:
  RUN shared/security.p (INPUT "inventory/in_menu.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN inventory/in_menu.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m4 DO:
  RUN shared/security.p (INPUT "warehousing/wh_menu.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN warehousing/wh_menu.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m5 DO:
  RUN shared/security.p (INPUT "purchasing/po_menu.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN purchasing/po_menu.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m6 DO:
  RUN shared/security.p (INPUT "order-entry/oe_menu.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-entry/oe_menu.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m7 DO:
  RUN shared/security.p (INPUT "order-fulfilment/of_menu.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-fulfilment/of_menu.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m8 DO:
  RUN shared/security.p (INPUT "credit-management/cr_menu.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN credit-management/cr_menu.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m9 DO:
  RUN shared/security.p (INPUT "billing-invoicing/bi_menu.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN billing-invoicing/bi_menu.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m10 DO:
  RUN shared/security.p (INPUT "hr-payroll/hr_menu.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN hr-payroll/hr_menu.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m11 DO:
  RUN shared/security.p (INPUT "reporting-batch/rb_menu.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN reporting-batch/rb_menu.w PERSISTENT.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Sports2000 Enterprise" MENUBAR = MENU mbMain:HANDLE.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

