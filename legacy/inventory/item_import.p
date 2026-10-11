/*------------------------------------------------------------------------
    File        : item_import.p
    Purpose     : Import Item from CSV with upsert
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

{inventory/tt_item.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttItem.
    IMPORT DELIMITER "," ttItem.Itemnum ttItem.ItemName ttItem.Price ttItem.Onhand ttItem.Allocated ttItem.ReOrder ttItem.OnOrder ttItem.CatPage ttItem.CatDescription ttItem.Category1 ttItem.Category2 ttItem.Special ttItem.Weight ttItem.Minqty NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttItem.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttItem:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST Item EXCLUSIVE-LOCK WHERE Item.Itemnum = ttItem.Itemnum NO-ERROR.
        IF NOT AVAILABLE Item THEN CREATE Item.
        BUFFER-COPY ttItem EXCEPT RowState ErrorMsg TO Item.
        RUN inventory/item_val.p (INPUT ROWID(Item), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

