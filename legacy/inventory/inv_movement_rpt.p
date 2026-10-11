/*------------------------------------------------------------------------
    File        : inv_movement_rpt.p
    Purpose     : Inventory movement by transaction type
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2012-06  mab  fix rounding
 *  2009-05  kpo  Y2K date window
 *  2016-02  tlw  add lock retry
 *  2000-07  mab  add lock retry
 *  2001-03  ssp  performance: use index
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.
DEFINE STREAM sOut.
DEFINE VARIABLE dLine AS DECIMAL NO-UNDO.
DEFINE VARIABLE dGrand AS DECIMAL NO-UNDO.

OUTPUT STREAM sOut TO VALUE(pcDest) PAGED PAGE-SIZE 66.
PUT STREAM sOut UNFORMATTED gCompanyName SKIP "Inventory movement by transaction type" SKIP(1).

FOR EACH InventoryTrans NO-LOCK
    BREAK BY InventoryTrans.InvType:
    dLine = 0.
    FOR EACH Item NO-LOCK WHERE Item.Itemnum = InventoryTrans.Itemnum:
        dLine = dLine + Item.Price.
    END.
    dGrand = dGrand + dLine.
    ACCUMULATE dLine (TOTAL SUB-TOTAL BY InventoryTrans.InvType).
    DISPLAY STREAM sOut InventoryTrans.InvTransNum InventoryTrans.WarehouseNum InventoryTrans.BinNum InventoryTrans.Qty dLine LABEL "Amount" FORMAT "->>>,>>>,>>9.99"
        WITH FRAME fLine DOWN WIDTH 132 STREAM-IO.
    IF LAST-OF(InventoryTrans.InvType) THEN
        PUT STREAM sOut UNFORMATTED SKIP "  Type total: " ACCUM SUB-TOTAL BY InventoryTrans.InvType dLine SKIP(1).
END.
PUT STREAM sOut UNFORMATTED SKIP(1) "Grand total: " dGrand SKIP.
OUTPUT STREAM sOut CLOSE.

PROCEDURE reset-inventory-trans-qty0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bInventoryTrans FOR InventoryTrans.
  FIND bInventoryTrans WHERE ROWID(bInventoryTrans) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bInventoryTrans THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bInventoryTrans.Qty < 0 THEN plOk = NO.
    WHEN bInventoryTrans.Qty > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "InventoryTrans.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-item-onorder1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.OnOrder < 0 THEN plOk = NO.
    WHEN bItem.OnOrder > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.OnOrder above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

