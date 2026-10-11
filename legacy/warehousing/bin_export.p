/*------------------------------------------------------------------------
    File        : bin_export.p
    Purpose     : Export Bin to CSV
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2012-06  mab  Y2K date window
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "bin_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Warehouse Num,Item Num,Qty,Bin Num,Bin Name" SKIP.
FOR EACH Bin NO-LOCK
    BY Bin.BinNum:
    EXPORT DELIMITER "," Bin.WarehouseNum Bin.Itemnum Bin.Qty Bin.BinNum Bin.BinName.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=Bin" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "Bin export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

