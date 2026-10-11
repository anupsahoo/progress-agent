/*------------------------------------------------------------------------
    File        : si_state.p
    Purpose     : AppServer service interface for State
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

{sales-territories/tt_state.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsState.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcState FOR State.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttState:ATTACH-DATA-SOURCE(DATA-SOURCE srcState:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcState:FILL-WHERE-STRING = pcWhere.
    DATASET dsState:FILL().
    BUFFER ttState:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttState:ATTACH-DATA-SOURCE(DATA-SOURCE srcState:HANDLE).
    FOR EACH btState:
      BUFFER btState:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btState:ERROR THEN pcError = pcError + BUFFER btState:ERROR-STRING + "~n".
    END.
    BUFFER ttState:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttState:
      FIND FIRST State EXCLUSIVE-LOCK WHERE State.State = ttState.State NO-WAIT NO-ERROR.
      IF LOCKED State THEN DO:
        pcError = pcError + "State is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE State THEN DELETE State.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER State:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH State NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_state " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

