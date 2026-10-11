/*------------------------------------------------------------------------
    File        : ref_call_import.p
    Purpose     : Import RefCall from CSV with upsert
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

{credit-management/tt_ref_call.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttRefCall.
    IMPORT DELIMITER "," ttRefCall.CallNum ttRefCall.CustNum ttRefCall.CallDate ttRefCall.SalesRep ttRefCall.Parent ttRefCall.Txt NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttRefCall.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttRefCall:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST RefCall EXCLUSIVE-LOCK WHERE RefCall.CallNum = ttRefCall.CallNum NO-ERROR.
        IF NOT AVAILABLE RefCall THEN CREATE RefCall.
        BUFFER-COPY ttRefCall EXCEPT RowState ErrorMsg TO RefCall.
        RUN credit-management/ref_call_val.p (INPUT ROWID(RefCall), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

