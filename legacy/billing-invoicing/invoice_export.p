/*------------------------------------------------------------------------
    File        : invoice_export.p
    Purpose     : Export Invoice to CSV
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2015-01  mab  credit hold rule
 *  2008-04  kpo  remove dead code
 *  2015-04  rdh  performance: use index
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "invoice_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Invoice Num,Cust Num,Invoice Date,Amount,Total Paid,Adjustment,Order Num,Ship Charge" SKIP.
FOR EACH Invoice NO-LOCK
    WHERE Invoice.InvoiceDate = ? OR Invoice.InvoiceDate >= TODAY - 3650
    BY Invoice.Invoicenum:
    EXPORT DELIMITER "," Invoice.Invoicenum Invoice.CustNum Invoice.InvoiceDate Invoice.Amount Invoice.TotalPaid Invoice.Adjustment Invoice.OrderNum Invoice.ShipCharge.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=Invoice" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "Invoice export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

