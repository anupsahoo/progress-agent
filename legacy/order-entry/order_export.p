/*------------------------------------------------------------------------
    File        : order_export.p
    Purpose     : Export Order to CSV
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-05  kpo  credit hold rule
 *  2000-01  jkm  appserver split
 *  2006-06  ssp  new report column
 *  1999-05  ssp  fix rounding
 *  2003-09  ssp  credit hold rule
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "order_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Order Num,Cust Num,Ordered,Shipped,Promised,Carrier,Instructions,PO,Terms,Sales Rep,Bill To ID,Ship To ID,Order Status,Warehouse Num,Credit Card" SKIP.
FOR EACH Order NO-LOCK
    WHERE Order.OrderDate = ? OR Order.OrderDate >= TODAY - 3650
    BY Order.Ordernum:
    EXPORT DELIMITER "," Order.Ordernum Order.CustNum Order.OrderDate Order.ShipDate Order.PromiseDate Order.Carrier Order.Instructions Order.PO Order.Terms Order.SalesRep Order.BillToID Order.ShipToID Order.OrderStatus Order.WarehouseNum Order.Creditcard.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=Order" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "Order export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

