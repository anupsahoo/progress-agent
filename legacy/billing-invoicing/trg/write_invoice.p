/*------------------------------------------------------------------------
    File        : write_invoice.p
    Purpose     : schema WRITE trigger for Invoice, field-level audit
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-11  ssp  remove dead code
 */

/* trg/write_invoice.p : schema WRITE trigger for Invoice, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF Invoice OLD BUFFER oldInvoice.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN billing-invoicing/invoice_val.p (INPUT ROWID(Invoice), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "Invoice write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF Invoice.Invoicenum <> oldInvoice.Invoicenum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Invoice.Invoicenum", INPUT STRING(oldInvoice.Invoicenum), INPUT STRING(Invoice.Invoicenum)).
END.
IF Invoice.CustNum <> oldInvoice.CustNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Invoice.CustNum", INPUT STRING(oldInvoice.CustNum), INPUT STRING(Invoice.CustNum)).
END.
IF Invoice.InvoiceDate <> oldInvoice.InvoiceDate THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Invoice.InvoiceDate", INPUT STRING(oldInvoice.InvoiceDate), INPUT STRING(Invoice.InvoiceDate)).
END.
IF Invoice.Amount <> oldInvoice.Amount THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Invoice.Amount", INPUT STRING(oldInvoice.Amount), INPUT STRING(Invoice.Amount)).
END.
IF Invoice.TotalPaid <> oldInvoice.TotalPaid THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Invoice.TotalPaid", INPUT STRING(oldInvoice.TotalPaid), INPUT STRING(Invoice.TotalPaid)).
END.
IF Invoice.Adjustment <> oldInvoice.Adjustment THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Invoice.Adjustment", INPUT STRING(oldInvoice.Adjustment), INPUT STRING(Invoice.Adjustment)).
END.
IF Invoice.OrderNum <> oldInvoice.OrderNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Invoice.OrderNum", INPUT STRING(oldInvoice.OrderNum), INPUT STRING(Invoice.OrderNum)).
END.
IF Invoice.ShipCharge <> oldInvoice.ShipCharge THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Invoice.ShipCharge", INPUT STRING(oldInvoice.ShipCharge), INPUT STRING(Invoice.ShipCharge)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/invoice.q") APPEND.
  EXPORT "Invoice" "W" STRING(NOW) Invoice.Invoicenum.
  OUTPUT CLOSE.
END.

