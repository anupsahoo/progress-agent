/*------------------------------------------------------------------------
    File        : inventory_trans_export.p
    Purpose     : Export InventoryTrans to CSV
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-06  mab  credit hold rule
 *  1999-02  rdh  credit hold rule
 *  2013-03  rdh  performance: use index
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "inventory_trans_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Inventory Trans Num,Warehouse Num,Bin Num,Qty,Item Num,Trans Date,Type,PO Num,Order Num,Trans Time" SKIP.
FOR EACH InventoryTrans NO-LOCK
    WHERE InventoryTrans.TransDate = ? OR InventoryTrans.TransDate >= TODAY - 3650
    BY InventoryTrans.InvTransNum:
    EXPORT DELIMITER "," InventoryTrans.InvTransNum InventoryTrans.WarehouseNum InventoryTrans.BinNum InventoryTrans.Qty InventoryTrans.Itemnum InventoryTrans.TransDate InventoryTrans.InvType InventoryTrans.PONum InventoryTrans.Ordernum InventoryTrans.Transtime.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=InventoryTrans" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "InventoryTrans export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

