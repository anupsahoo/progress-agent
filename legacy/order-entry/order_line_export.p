/*------------------------------------------------------------------------
    File        : order_line_export.p
    Purpose     : Export OrderLine to CSV
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-04  ssp  new report column
 *  2014-07  ssp  audit fields
 *  2016-01  mab  Y2K date window
 *  2015-11  ssp  appserver split
 *  2013-01  mab  appserver split
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "order_line_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Order Num,Line Num,Item Num,Price,Qty,Discount,Extended Price,Order Line Status" SKIP.
FOR EACH OrderLine NO-LOCK
    BY OrderLine.Ordernum:
    EXPORT DELIMITER "," OrderLine.Ordernum OrderLine.Linenum OrderLine.Itemnum OrderLine.Price OrderLine.Qty OrderLine.Discount OrderLine.ExtendedPrice OrderLine.OrderLineStatus.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=OrderLine" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "OrderLine export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

