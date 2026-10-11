/*------------------------------------------------------------------------
    File        : bin_import.p
    Purpose     : Import Bin from CSV with upsert
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

{warehousing/tt_bin.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttBin.
    IMPORT DELIMITER "," ttBin.WarehouseNum ttBin.Itemnum ttBin.Qty ttBin.BinNum ttBin.BinName NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttBin.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttBin:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST Bin EXCLUSIVE-LOCK WHERE Bin.BinNum = ttBin.BinNum NO-ERROR.
        IF NOT AVAILABLE Bin THEN CREATE Bin.
        BUFFER-COPY ttBin EXCEPT RowState ErrorMsg TO Bin.
        RUN warehousing/bin_val.p (INPUT ROWID(Bin), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

