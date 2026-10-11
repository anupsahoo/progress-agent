&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : cust_onboard.w
    Purpose     : New customer onboarding wizard
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}
{customer-management/cm_defs.i}

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

DEFINE QUERY qDetail FOR Salesrep SCROLLING.
DEFINE BROWSE brDetail QUERY qDetail NO-LOCK DISPLAY
    Salesrep.SalesRep COLUMN-LABEL "Sales Rep"
    Salesrep.RepName COLUMN-LABEL "Rep Name"
    Salesrep.Region COLUMN-LABEL "Region"
    WITH SIZE 120 BY 8 SEPARATORS.

DEFINE BUTTON btnRefresh LABEL "Refresh" SIZE 12 BY 1.14.
DEFINE BUTTON btnOpen LABEL "Open" SIZE 12 BY 1.14.
DEFINE BUTTON btnPrint LABEL "Print" SIZE 12 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 12 BY 1.14.

DEFINE FRAME fMain
    brMaster AT ROW 1.5 COL 2
    brDetail AT ROW 11 COL 2
    btnRefresh AT ROW 20 COL 2 btnOpen btnPrint btnClose
    WITH THREE-D SIZE 124 BY 22 TITLE "New customer onboarding wizard".

ON VALUE-CHANGED OF brMaster IN FRAME fMain DO:
  OPEN QUERY qDetail FOR EACH Salesrep NO-LOCK WHERE Salesrep.SalesRep = Customer.SalesRep.
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

CREATE WINDOW wWin ASSIGN TITLE = "New customer onboarding wizard" HEIGHT = 22 WIDTH = 124.
CURRENT-WINDOW = wWin.
ENABLE ALL WITH FRAME fMain.
APPLY "CHOOSE":U TO btnRefresh.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

PROCEDURE check-salesrep-repname0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSalesrep FOR Salesrep.
  FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSalesrep THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bSalesrep.RepName = "" OR bSalesrep.RepName = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Salesrep.RepName is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bSalesrep.RepName) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE apply-customer-creditlimit1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bCustomer FOR Customer.
  FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bCustomer THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bCustomer.CreditLimit < 0 THEN plOk = NO.
    WHEN bCustomer.CreditLimit > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.CreditLimit above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE calc-salesrep-region2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSalesrep FOR Salesrep.
  FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSalesrep THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bSalesrep.Region = "" OR bSalesrep.Region = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Salesrep.Region is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bSalesrep.Region) > 8 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-salesrep-repname3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSalesrep FOR Salesrep.
  FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSalesrep THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bSalesrep.RepName = "" OR bSalesrep.RepName = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Salesrep.RepName is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bSalesrep.RepName) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE post-customer-discount4 :
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
    WHEN bCustomer.Discount > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-customer-creditlimit5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bCustomer FOR Customer.
  FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bCustomer THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bCustomer.CreditLimit < 0 THEN plOk = NO.
    WHEN bCustomer.CreditLimit > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.CreditLimit above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-customer-discount6 :
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

PROCEDURE reset-customer-creditlimit7 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bCustomer FOR Customer.
  FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bCustomer THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bCustomer.CreditLimit < 0 THEN plOk = NO.
    WHEN bCustomer.CreditLimit > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.CreditLimit above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-salesrep-salesrep8 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSalesrep FOR Salesrep.
  FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSalesrep THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bSalesrep.SalesRep = "" OR bSalesrep.SalesRep = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Salesrep.SalesRep is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bSalesrep.SalesRep) > 4 THEN plOk = NO.
END PROCEDURE.

