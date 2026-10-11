&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : cm_menu.w
    Purpose     : Customer Management menu
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE lAllowed AS LOGICAL NO-UNDO.
DEFINE SUB-MENU mProg
    MENU-ITEM m0 LABEL "Customer maintenance"
    MENU-ITEM m1 LABEL "Customer report"
    MENU-ITEM m2 LABEL "Feedback maintenance"
    MENU-ITEM m3 LABEL "Feedback report"
    MENU-ITEM m4 LABEL "Merge duplicate customer records and re-"
    MENU-ITEM m5 LABEL "Recalculate credit headroom from balance"
    MENU-ITEM m6 LABEL "Customer 360 inquiry: profile, ship-to a"
    MENU-ITEM m7 LABEL "Nightly duplicate detection by name and "
    MENU-ITEM m8 LABEL "Customer balance aging by sales rep"
    MENU-ITEM m9 LABEL "Outbound CRM feed of changed customers"
    MENU-ITEM m10 LABEL "Route customer feedback to the owning de"
    MENU-ITEM m11 LABEL "Standardise addresses using state and po"
    MENU-ITEM m12 LABEL "New customer onboarding wizard"
    .
DEFINE MENU mbMain MENUBAR SUB-MENU mProg LABEL "&Customer Management".

ON CHOOSE OF MENU-ITEM m0 DO:
  RUN shared/security.p (INPUT "customer-management/customer_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN customer-management/customer_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m1 DO:
  RUN shared/security.p (INPUT "customer-management/customer_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN customer-management/customer_report.p.
END.

ON CHOOSE OF MENU-ITEM m2 DO:
  RUN shared/security.p (INPUT "customer-management/feedback_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN customer-management/feedback_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m3 DO:
  RUN shared/security.p (INPUT "customer-management/feedback_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN customer-management/feedback_report.p.
END.

ON CHOOSE OF MENU-ITEM m4 DO:
  RUN shared/security.p (INPUT "customer-management/cust_merge.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN customer-management/cust_merge.p.
END.

ON CHOOSE OF MENU-ITEM m5 DO:
  RUN shared/security.p (INPUT "customer-management/cust_credit_review.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN customer-management/cust_credit_review.p.
END.

ON CHOOSE OF MENU-ITEM m6 DO:
  RUN shared/security.p (INPUT "customer-management/cust_360.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN customer-management/cust_360.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m7 DO:
  RUN shared/security.p (INPUT "customer-management/cust_dedupe_batch.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN customer-management/cust_dedupe_batch.p.
END.

ON CHOOSE OF MENU-ITEM m8 DO:
  RUN shared/security.p (INPUT "customer-management/cust_aging_rpt.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN customer-management/cust_aging_rpt.p.
END.

ON CHOOSE OF MENU-ITEM m9 DO:
  RUN shared/security.p (INPUT "customer-management/cust_crm_feed.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN customer-management/cust_crm_feed.p.
END.

ON CHOOSE OF MENU-ITEM m10 DO:
  RUN shared/security.p (INPUT "customer-management/feedback_triage.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN customer-management/feedback_triage.p.
END.

ON CHOOSE OF MENU-ITEM m11 DO:
  RUN shared/security.p (INPUT "customer-management/cust_address_std.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN customer-management/cust_address_std.p.
END.

ON CHOOSE OF MENU-ITEM m12 DO:
  RUN shared/security.p (INPUT "customer-management/cust_onboard.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN customer-management/cust_onboard.w PERSISTENT.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Customer Management" MENUBAR = MENU mbMain:HANDLE.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

