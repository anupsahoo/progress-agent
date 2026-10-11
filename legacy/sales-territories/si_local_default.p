/*------------------------------------------------------------------------
    File        : si_local_default.p
    Purpose     : AppServer service interface for LocalDefault
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

{sales-territories/tt_local_default.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsLocalDefault.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcLocalDefault FOR LocalDefault.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttLocalDefault:ATTACH-DATA-SOURCE(DATA-SOURCE srcLocalDefault:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcLocalDefault:FILL-WHERE-STRING = pcWhere.
    DATASET dsLocalDefault:FILL().
    BUFFER ttLocalDefault:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttLocalDefault:ATTACH-DATA-SOURCE(DATA-SOURCE srcLocalDefault:HANDLE).
    FOR EACH btLocalDefault:
      BUFFER btLocalDefault:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btLocalDefault:ERROR THEN pcError = pcError + BUFFER btLocalDefault:ERROR-STRING + "~n".
    END.
    BUFFER ttLocalDefault:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttLocalDefault:
      FIND FIRST LocalDefault EXCLUSIVE-LOCK WHERE LocalDefault.LocalDefNum = ttLocalDefault.LocalDefNum NO-WAIT NO-ERROR.
      IF LOCKED LocalDefault THEN DO:
        pcError = pcError + "LocalDefault is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE LocalDefault THEN DELETE LocalDefault.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER LocalDefault:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH LocalDefault NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_local_default " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

