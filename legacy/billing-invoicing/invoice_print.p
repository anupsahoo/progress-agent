/*------------------------------------------------------------------------
    File        : invoice_print.p
    Purpose     : Invoice print run
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2001-04  mab  credit hold rule
 *  2001-11  ssp  appserver split
 *  2014-12  rdh  performance: use index
 *  2007-01  tlw  new report column
 *  2001-01  ssp  fix rounding
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.
DEFINE STREAM sOut.
DEFINE VARIABLE dLine AS DECIMAL NO-UNDO.
DEFINE VARIABLE dGrand AS DECIMAL NO-UNDO.

OUTPUT STREAM sOut TO VALUE(pcDest) PAGED PAGE-SIZE 66.
PUT STREAM sOut UNFORMATTED gCompanyName SKIP "Invoice print run" SKIP(1).

FOR EACH Invoice NO-LOCK:
    dLine = 0.
    dGrand = dGrand + dLine.
    ACCUMULATE dLine (TOTAL).
    DISPLAY STREAM sOut Invoice.Invoicenum Invoice.CustNum Invoice.InvoiceDate Invoice.Amount dLine LABEL "Amount" FORMAT "->>>,>>>,>>9.99"
        WITH FRAME fLine DOWN WIDTH 132 STREAM-IO.
END.
PUT STREAM sOut UNFORMATTED SKIP(1) "Grand total: " dGrand SKIP.
OUTPUT STREAM sOut CLOSE.

PROCEDURE round-bill-to-address0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBillTo FOR BillTo.
  FIND bBillTo WHERE ROWID(bBillTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBillTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bBillTo.Address = "" OR bBillTo.Address = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "BillTo.Address is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bBillTo.Address) > 35 THEN plOk = NO.
END PROCEDURE.

PROCEDURE apply-bill-to-state1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBillTo FOR BillTo.
  FIND bBillTo WHERE ROWID(bBillTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBillTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bBillTo.State = "" OR bBillTo.State = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "BillTo.State is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bBillTo.State) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE reset-invoice-shipcharge2 :
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

PROCEDURE flag-bill-to-state3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBillTo FOR BillTo.
  FIND bBillTo WHERE ROWID(bBillTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBillTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bBillTo.State = "" OR bBillTo.State = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "BillTo.State is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bBillTo.State) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE check-bill-to-name4 :
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

PROCEDURE reset-invoice-shipcharge5 :
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

PROCEDURE check-bill-to-contact6 :
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

