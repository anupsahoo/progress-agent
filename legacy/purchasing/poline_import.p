/*------------------------------------------------------------------------
    File        : poline_import.p
    Purpose     : Import POLine from CSV with upsert
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

{purchasing/tt_poline.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttPOLine.
    IMPORT DELIMITER "," ttPOLine.Linenum ttPOLine.Itemnum ttPOLine.Price ttPOLine.Qty ttPOLine.Discount ttPOLine.ExtendedPrice ttPOLine.PONum ttPOLine.POLineStatus NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttPOLine.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttPOLine:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST POLine EXCLUSIVE-LOCK WHERE POLine.PONum = ttPOLine.PONum AND POLine.Linenum = ttPOLine.Linenum NO-ERROR.
        IF NOT AVAILABLE POLine THEN CREATE POLine.
        BUFFER-COPY ttPOLine EXCEPT RowState ErrorMsg TO POLine.
        RUN purchasing/poline_val.p (INPUT ROWID(POLine), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

