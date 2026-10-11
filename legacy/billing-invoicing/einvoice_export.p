/*------------------------------------------------------------------------
    File        : einvoice_export.p
    Purpose     : E-invoice export (UBL)
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2015-03  jkm  remove dead code
 *  2015-11  mab  Y2K date window
 *  2011-03  tlw  credit hold rule
 */

{shared/sysdefs.i}
{billing-invoicing/tt_invoice.i}

DEFINE INPUT PARAMETER pcDir AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRecs AS INTEGER   NO-UNDO.
DEFINE VARIABLE lcDoc AS LONGCHAR  NO-UNDO.

cFile = pcDir + "/einvoice_export_" + STRING(TODAY, "99999999") + ".dat".

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

RUN shared/log_msg.p (INPUT "INFO", INPUT "einvoice_export.p: " + STRING(iRecs) + " records written").

PROCEDURE load-invoice-totalpaid0 :
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
    WHEN bInvoice.TotalPaid > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Invoice.TotalPaid above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE calc-invoice-amount1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bInvoice FOR Invoice.
  FIND bInvoice WHERE ROWID(bInvoice) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bInvoice THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bInvoice.Amount < 0 THEN plOk = NO.
    WHEN bInvoice.Amount > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Invoice.Amount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-invoice-amount2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bInvoice FOR Invoice.
  FIND bInvoice WHERE ROWID(bInvoice) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bInvoice THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bInvoice.Amount < 0 THEN plOk = NO.
    WHEN bInvoice.Amount > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Invoice.Amount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-bill-to-state3 :
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

