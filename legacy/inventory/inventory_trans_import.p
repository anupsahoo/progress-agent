/*------------------------------------------------------------------------
    File        : inventory_trans_import.p
    Purpose     : Import InventoryTrans from CSV with upsert
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

{inventory/tt_inventory_trans.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttInventoryTrans.
    IMPORT DELIMITER "," ttInventoryTrans.InvTransNum ttInventoryTrans.WarehouseNum ttInventoryTrans.BinNum ttInventoryTrans.Qty ttInventoryTrans.Itemnum ttInventoryTrans.TransDate ttInventoryTrans.InvType ttInventoryTrans.PONum ttInventoryTrans.Ordernum ttInventoryTrans.Transtime NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttInventoryTrans.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttInventoryTrans:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST InventoryTrans EXCLUSIVE-LOCK WHERE InventoryTrans.InvTransNum = ttInventoryTrans.InvTransNum NO-ERROR.
        IF NOT AVAILABLE InventoryTrans THEN CREATE InventoryTrans.
        BUFFER-COPY ttInventoryTrans EXCEPT RowState ErrorMsg TO InventoryTrans.
        RUN inventory/inventory_trans_val.p (INPUT ROWID(InventoryTrans), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

