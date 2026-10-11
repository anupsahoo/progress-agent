/*------------------------------------------------------------------------
    File        : purchase_order_export.p
    Purpose     : Export PurchaseOrder to CSV
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2015-03  jkm  performance: use index
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "purchase_order_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "PO Num,Date Entered,Supplier ID,Date Received,PO Status" SKIP.
FOR EACH PurchaseOrder NO-LOCK
    WHERE PurchaseOrder.DateEntered = ? OR PurchaseOrder.DateEntered >= TODAY - 3650
    BY PurchaseOrder.PONum:
    EXPORT DELIMITER "," PurchaseOrder.PONum PurchaseOrder.DateEntered PurchaseOrder.SupplierIDNum PurchaseOrder.ReceiveDate PurchaseOrder.POStatus.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=PurchaseOrder" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "PurchaseOrder export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

