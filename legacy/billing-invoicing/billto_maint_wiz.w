&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : billto_maint_wiz.w
    Purpose     : Bill-to address wizard
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}
{billing-invoicing/bi_defs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qMaster FOR BillTo SCROLLING.
DEFINE BROWSE brMaster QUERY qMaster NO-LOCK DISPLAY
    BillTo.CustNum COLUMN-LABEL "Cust Num"
    BillTo.BillToID COLUMN-LABEL "BillToID"
    BillTo.Name COLUMN-LABEL "Name"
    BillTo.Address COLUMN-LABEL "Address"
    BillTo.Address2 COLUMN-LABEL "Address2"
    BillTo.City COLUMN-LABEL "City"
    WITH SIZE 120 BY 9 SEPARATORS.

DEFINE QUERY qDetail FOR Customer SCROLLING.
DEFINE BROWSE brDetail QUERY qDetail NO-LOCK DISPLAY
    Customer.CustNum COLUMN-LABEL "Cust Num"
    Customer.Country COLUMN-LABEL "Country"
    Customer.Name COLUMN-LABEL "Name"
    Customer.Address COLUMN-LABEL "Address"
    Customer.Address2 COLUMN-LABEL "Address2"
    Customer.City COLUMN-LABEL "City"
    WITH SIZE 120 BY 8 SEPARATORS.

DEFINE BUTTON btnRefresh LABEL "Refresh" SIZE 12 BY 1.14.
DEFINE BUTTON btnOpen LABEL "Open" SIZE 12 BY 1.14.
DEFINE BUTTON btnPrint LABEL "Print" SIZE 12 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 12 BY 1.14.

DEFINE FRAME fMain
    brMaster AT ROW 1.5 COL 2
    brDetail AT ROW 11 COL 2
    btnRefresh AT ROW 20 COL 2 btnOpen btnPrint btnClose
    WITH THREE-D SIZE 124 BY 22 TITLE "Bill-to address wizard".

ON VALUE-CHANGED OF brMaster IN FRAME fMain DO:
  OPEN QUERY qDetail FOR EACH Customer NO-LOCK WHERE Customer.CustNum = BillTo.CustNum.
END.

ON CHOOSE OF btnRefresh IN FRAME fMain DO:
  OPEN QUERY qMaster FOR EACH BillTo NO-LOCK.
  APPLY "VALUE-CHANGED":U TO brMaster.
END.

ON CHOOSE OF btnOpen IN FRAME fMain DO:
  IF AVAILABLE BillTo THEN RUN billing-invoicing/bill_to_maint.p.
END.

ON CHOOSE OF btnClose IN FRAME fMain DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Bill-to address wizard" HEIGHT = 22 WIDTH = 124.
CURRENT-WINDOW = wWin.
ENABLE ALL WITH FRAME fMain.
APPLY "CHOOSE":U TO btnRefresh.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

PROCEDURE map-bill-to-contact0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBillTo FOR BillTo.
  FIND bBillTo WHERE ROWID(bBillTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBillTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bBillTo.Contact = "" OR bBillTo.Contact = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "BillTo.Contact is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bBillTo.Contact) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE reset-bill-to-name1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBillTo FOR BillTo.
  FIND bBillTo WHERE ROWID(bBillTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBillTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bBillTo.Name = "" OR bBillTo.Name = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "BillTo.Name is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bBillTo.Name) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE round-bill-to-address22 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBillTo FOR BillTo.
  FIND bBillTo WHERE ROWID(bBillTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBillTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bBillTo.Address2 = "" OR bBillTo.Address2 = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "BillTo.Address2 is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bBillTo.Address2) > 35 THEN plOk = NO.
END PROCEDURE.

PROCEDURE load-customer-balance3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bCustomer FOR Customer.
  FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bCustomer THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bCustomer.Balance < 0 THEN plOk = NO.
    WHEN bCustomer.Balance > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.Balance above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

