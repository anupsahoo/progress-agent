/*------------------------------------------------------------------------
    File        : credit_exposure_rpt.p
    Purpose     : Credit exposure by customer
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-02  jkm  credit hold rule
 *  2002-11  mab  credit hold rule
 *  2016-05  tlw  performance: use index
 *  2010-08  kpo  appserver split
 *  2014-11  tlw  add lock retry
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.
DEFINE STREAM sOut.
DEFINE VARIABLE dLine AS DECIMAL NO-UNDO.
DEFINE VARIABLE dGrand AS DECIMAL NO-UNDO.

OUTPUT STREAM sOut TO VALUE(pcDest) PAGED PAGE-SIZE 66.
PUT STREAM sOut UNFORMATTED gCompanyName SKIP "Credit exposure by customer" SKIP(1).

FOR EACH Customer NO-LOCK
    BREAK BY Customer.City:
    dLine = 0.
    FOR EACH Invoice NO-LOCK WHERE Invoice.CustNum = Customer.CustNum:
        dLine = dLine + Invoice.Amount.
    END.
    dGrand = dGrand + dLine.
    ACCUMULATE dLine (TOTAL SUB-TOTAL BY Customer.City).
    DISPLAY STREAM sOut Customer.CustNum Customer.Country Customer.Name Customer.Address dLine LABEL "Amount" FORMAT "->>>,>>>,>>9.99"
        WITH FRAME fLine DOWN WIDTH 132 STREAM-IO.
    IF LAST-OF(Customer.City) THEN
        PUT STREAM sOut UNFORMATTED SKIP "  City total: " ACCUM SUB-TOTAL BY Customer.City dLine SKIP(1).
END.
PUT STREAM sOut UNFORMATTED SKIP(1) "Grand total: " dGrand SKIP.
OUTPUT STREAM sOut CLOSE.

PROCEDURE calc-customer-discount0 :
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
    WHEN bCustomer.Discount > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-customer-creditlimit1 :
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

PROCEDURE load-invoice-shipcharge2 :
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
    WHEN bInvoice.ShipCharge > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Invoice.ShipCharge above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE apply-invoice-shipcharge3 :
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

