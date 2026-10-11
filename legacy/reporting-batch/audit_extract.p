/*------------------------------------------------------------------------
    File        : audit_extract.p
    Purpose     : Auditor extract
    Module      : Reporting & Batch
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2001-07  ssp  new report column
 */

{shared/sysdefs.i}
{billing-invoicing/tt_invoice.i}

DEFINE INPUT PARAMETER pcDir AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRecs AS INTEGER   NO-UNDO.
DEFINE VARIABLE lcDoc AS LONGCHAR  NO-UNDO.

cFile = pcDir + "/audit_extract_" + STRING(TODAY, "99999999") + ".dat".

FOR EACH Invoice NO-LOCK:
    CREATE ttInvoice.
    BUFFER-COPY Invoice TO ttInvoice.
    iRecs = iRecs + 1.
END.

DATASET dsInvoice:WRITE-JSON("LONGCHAR", lcDoc, TRUE).
COPY-LOB FROM lcDoc TO FILE cFile.

OUTPUT TO VALUE(cFile + ".ctl").
PUT UNFORMATTED "RECORDS=" iRecs SKIP "SOURCE=Invoice" SKIP "FIELDS=Invoicenum,CustNum,InvoiceDate,Amount,TotalPaid,Adjustment,OrderNum,ShipCharge" SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "audit_extract.p: " + STRING(iRecs) + " records written").

PROCEDURE apply-customer-discount0 :
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

PROCEDURE flag-invoice-totalpaid1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bInvoice FOR Invoice.
  FIND bInvoice WHERE ROWID(bInvoice) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bInvoice THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bInvoice.TotalPaid < 0 THEN plOk = NO.
    WHEN bInvoice.TotalPaid > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Invoice.TotalPaid above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-invoice-adjustment2 :
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
    WHEN bInvoice.Adjustment > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Invoice.Adjustment above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE calc-invoice-shipcharge3 :
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

