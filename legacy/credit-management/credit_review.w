&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : credit_review.w
    Purpose     : Credit review approval screen
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}
{credit-management/cr_defs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qMaster FOR Customer SCROLLING.
DEFINE BROWSE brMaster QUERY qMaster NO-LOCK DISPLAY
    Customer.CustNum COLUMN-LABEL "Cust Num"
    Customer.Country COLUMN-LABEL "Country"
    Customer.Name COLUMN-LABEL "Name"
    Customer.Address COLUMN-LABEL "Address"
    Customer.Address2 COLUMN-LABEL "Address2"
    Customer.City COLUMN-LABEL "City"
    WITH SIZE 120 BY 9 SEPARATORS.

DEFINE QUERY qDetail FOR Invoice SCROLLING.
DEFINE BROWSE brDetail QUERY qDetail NO-LOCK DISPLAY
    Invoice.Invoicenum COLUMN-LABEL "Invoice Num"
    Invoice.CustNum COLUMN-LABEL "Cust Num"
    Invoice.InvoiceDate COLUMN-LABEL "Invoice Date"
    Invoice.Amount COLUMN-LABEL "Amount"
    Invoice.TotalPaid COLUMN-LABEL "Total Paid"
    Invoice.Adjustment COLUMN-LABEL "Adjustment"
    WITH SIZE 120 BY 8 SEPARATORS.

DEFINE BUTTON btnRefresh LABEL "Refresh" SIZE 12 BY 1.14.
DEFINE BUTTON btnOpen LABEL "Open" SIZE 12 BY 1.14.
DEFINE BUTTON btnPrint LABEL "Print" SIZE 12 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 12 BY 1.14.

DEFINE FRAME fMain
    brMaster AT ROW 1.5 COL 2
    brDetail AT ROW 11 COL 2
    btnRefresh AT ROW 20 COL 2 btnOpen btnPrint btnClose
    WITH THREE-D SIZE 124 BY 22 TITLE "Credit review approval screen".

ON VALUE-CHANGED OF brMaster IN FRAME fMain DO:
  OPEN QUERY qDetail FOR EACH Invoice NO-LOCK WHERE Invoice.CustNum = Customer.CustNum.
END.

ON CHOOSE OF btnRefresh IN FRAME fMain DO:
  OPEN QUERY qMaster FOR EACH Customer NO-LOCK.
  APPLY "VALUE-CHANGED":U TO brMaster.
END.

ON CHOOSE OF btnOpen IN FRAME fMain DO:
  IF AVAILABLE Customer THEN RUN customer-management/customer_maint.p.
END.

ON CHOOSE OF btnClose IN FRAME fMain DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Credit review approval screen" HEIGHT = 22 WIDTH = 124.
CURRENT-WINDOW = wWin.
ENABLE ALL WITH FRAME fMain.
APPLY "CHOOSE":U TO btnRefresh.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

PROCEDURE calc-invoice-shipcharge0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bInvoice FOR Invoice.
  FIND bInvoice WHERE ROWID(bInvoice) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bInvoice THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bInvoice.ShipCharge < 0 THEN plOk = NO.
    WHEN bInvoice.ShipCharge > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Invoice.ShipCharge above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-invoice-shipcharge1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bInvoice FOR Invoice.
  FIND bInvoice WHERE ROWID(bInvoice) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bInvoice THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bInvoice.ShipCharge < 0 THEN plOk = NO.
    WHEN bInvoice.ShipCharge > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Invoice.ShipCharge above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-invoice-adjustment2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bInvoice FOR Invoice.
  FIND bInvoice WHERE ROWID(bInvoice) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bInvoice THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bInvoice.Adjustment < 0 THEN plOk = NO.
    WHEN bInvoice.Adjustment > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Invoice.Adjustment above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE derive-customer-discount3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bCustomer FOR Customer.
  FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bCustomer THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bCustomer.Discount < 0 THEN plOk = NO.
    WHEN bCustomer.Discount > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-invoice-shipcharge4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bInvoice FOR Invoice.
  FIND bInvoice WHERE ROWID(bInvoice) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bInvoice THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bInvoice.ShipCharge < 0 THEN plOk = NO.
    WHEN bInvoice.ShipCharge > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Invoice.ShipCharge above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

