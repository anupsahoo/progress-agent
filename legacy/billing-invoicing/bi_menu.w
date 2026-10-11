&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : bi_menu.w
    Purpose     : Billing & Invoicing menu
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE lAllowed AS LOGICAL NO-UNDO.
DEFINE SUB-MENU mProg
    MENU-ITEM m0 LABEL "Invoice maintenance"
    MENU-ITEM m1 LABEL "Invoice report"
    MENU-ITEM m2 LABEL "BillTo maintenance"
    MENU-ITEM m3 LABEL "BillTo report"
    MENU-ITEM m4 LABEL "Generate invoices from shipped orders"
    MENU-ITEM m5 LABEL "Invoice print run"
    MENU-ITEM m6 LABEL "Apply customer payments to invoices"
    MENU-ITEM m7 LABEL "Invoice adjustment with approval"
    MENU-ITEM m8 LABEL "Accounts receivable aging"
    MENU-ITEM m9 LABEL "Billing month-end close"
    MENU-ITEM m10 LABEL "E-invoice export (UBL)"
    MENU-ITEM m11 LABEL "Shipping charge calculation"
    MENU-ITEM m12 LABEL "Bill-to address wizard"
    .
DEFINE MENU mbMain MENUBAR SUB-MENU mProg LABEL "&Billing and Invoicing".

ON CHOOSE OF MENU-ITEM m0 DO:
  RUN shared/security.p (INPUT "billing-invoicing/invoice_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN billing-invoicing/invoice_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m1 DO:
  RUN shared/security.p (INPUT "billing-invoicing/invoice_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN billing-invoicing/invoice_report.p.
END.

ON CHOOSE OF MENU-ITEM m2 DO:
  RUN shared/security.p (INPUT "billing-invoicing/bill_to_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN billing-invoicing/bill_to_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m3 DO:
  RUN shared/security.p (INPUT "billing-invoicing/bill_to_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN billing-invoicing/bill_to_report.p.
END.

ON CHOOSE OF MENU-ITEM m4 DO:
  RUN shared/security.p (INPUT "billing-invoicing/invoice_gen.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN billing-invoicing/invoice_gen.p.
END.

ON CHOOSE OF MENU-ITEM m5 DO:
  RUN shared/security.p (INPUT "billing-invoicing/invoice_print.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN billing-invoicing/invoice_print.p.
END.

ON CHOOSE OF MENU-ITEM m6 DO:
  RUN shared/security.p (INPUT "billing-invoicing/payment_apply.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN billing-invoicing/payment_apply.p.
END.

ON CHOOSE OF MENU-ITEM m7 DO:
  RUN shared/security.p (INPUT "billing-invoicing/invoice_adjust.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN billing-invoicing/invoice_adjust.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m8 DO:
  RUN shared/security.p (INPUT "billing-invoicing/ar_aging.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN billing-invoicing/ar_aging.p.
END.

ON CHOOSE OF MENU-ITEM m9 DO:
  RUN shared/security.p (INPUT "billing-invoicing/month_end_close.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN billing-invoicing/month_end_close.p.
END.

ON CHOOSE OF MENU-ITEM m10 DO:
  RUN shared/security.p (INPUT "billing-invoicing/einvoice_export.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN billing-invoicing/einvoice_export.p.
END.

ON CHOOSE OF MENU-ITEM m11 DO:
  RUN shared/security.p (INPUT "billing-invoicing/ship_charge_calc.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN billing-invoicing/ship_charge_calc.p.
END.

ON CHOOSE OF MENU-ITEM m12 DO:
  RUN shared/security.p (INPUT "billing-invoicing/billto_maint_wiz.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN billing-invoicing/billto_maint_wiz.w PERSISTENT.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Billing & Invoicing" MENUBAR = MENU mbMain:HANDLE.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

