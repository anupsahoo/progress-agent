/*------------------------------------------------------------------------
    File        : si_ref_call.p
    Purpose     : AppServer service interface for RefCall
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

{credit-management/tt_ref_call.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsRefCall.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcRefCall FOR RefCall.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttRefCall:ATTACH-DATA-SOURCE(DATA-SOURCE srcRefCall:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcRefCall:FILL-WHERE-STRING = pcWhere.
    DATASET dsRefCall:FILL().
    BUFFER ttRefCall:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttRefCall:ATTACH-DATA-SOURCE(DATA-SOURCE srcRefCall:HANDLE).
    FOR EACH btRefCall:
      BUFFER btRefCall:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btRefCall:ERROR THEN pcError = pcError + BUFFER btRefCall:ERROR-STRING + "~n".
    END.
    BUFFER ttRefCall:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttRefCall:
      FIND FIRST RefCall EXCLUSIVE-LOCK WHERE RefCall.CallNum = ttRefCall.CallNum NO-WAIT NO-ERROR.
      IF LOCKED RefCall THEN DO:
        pcError = pcError + "RefCall is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE RefCall THEN DELETE RefCall.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER RefCall:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH RefCall NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_ref_call " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

