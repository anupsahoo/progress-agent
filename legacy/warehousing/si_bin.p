/*------------------------------------------------------------------------
    File        : si_bin.p
    Purpose     : AppServer service interface for Bin
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

{warehousing/tt_bin.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsBin.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcBin FOR Bin.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttBin:ATTACH-DATA-SOURCE(DATA-SOURCE srcBin:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcBin:FILL-WHERE-STRING = pcWhere.
    DATASET dsBin:FILL().
    BUFFER ttBin:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttBin:ATTACH-DATA-SOURCE(DATA-SOURCE srcBin:HANDLE).
    FOR EACH btBin:
      BUFFER btBin:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btBin:ERROR THEN pcError = pcError + BUFFER btBin:ERROR-STRING + "~n".
    END.
    BUFFER ttBin:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttBin:
      FIND FIRST Bin EXCLUSIVE-LOCK WHERE Bin.BinNum = ttBin.BinNum NO-WAIT NO-ERROR.
      IF LOCKED Bin THEN DO:
        pcError = pcError + "Bin is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE Bin THEN DELETE Bin.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER Bin:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH Bin NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_bin " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

