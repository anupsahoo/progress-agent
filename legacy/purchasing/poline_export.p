/*------------------------------------------------------------------------
    File        : poline_export.p
    Purpose     : Export POLine to CSV
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2012-05  ssp  appserver split
 *  2016-11  tlw  remove dead code
 *  2017-05  jkm  Y2K date window
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "poline_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Line Num,Item Num,Price,Qty,Discount,Extended Price,Order Num,PO Line Status" SKIP.
FOR EACH POLine NO-LOCK
    BY POLine.PONum:
    EXPORT DELIMITER "," POLine.Linenum POLine.Itemnum POLine.Price POLine.Qty POLine.Discount POLine.ExtendedPrice POLine.PONum POLine.POLineStatus.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=POLine" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "POLine export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

