/*------------------------------------------------------------------------
    File        : state_import.p
    Purpose     : Import State from CSV with upsert
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

{sales-territories/tt_state.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttState.
    IMPORT DELIMITER "," ttState.State ttState.StateName ttState.Region NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttState.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttState:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST State EXCLUSIVE-LOCK WHERE State.State = ttState.State NO-ERROR.
        IF NOT AVAILABLE State THEN CREATE State.
        BUFFER-COPY ttState EXCEPT RowState ErrorMsg TO State.
        RUN sales-territories/state_val.p (INPUT ROWID(State), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

