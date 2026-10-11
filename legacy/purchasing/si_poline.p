/*------------------------------------------------------------------------
    File        : si_poline.p
    Purpose     : AppServer service interface for POLine
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

{purchasing/tt_poline.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsPOLine.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcPOLine FOR POLine.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttPOLine:ATTACH-DATA-SOURCE(DATA-SOURCE srcPOLine:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcPOLine:FILL-WHERE-STRING = pcWhere.
    DATASET dsPOLine:FILL().
    BUFFER ttPOLine:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttPOLine:ATTACH-DATA-SOURCE(DATA-SOURCE srcPOLine:HANDLE).
    FOR EACH btPOLine:
      BUFFER btPOLine:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btPOLine:ERROR THEN pcError = pcError + BUFFER btPOLine:ERROR-STRING + "~n".
    END.
    BUFFER ttPOLine:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttPOLine:
      FIND FIRST POLine EXCLUSIVE-LOCK WHERE POLine.PONum = ttPOLine.PONum AND POLine.Linenum = ttPOLine.Linenum NO-WAIT NO-ERROR.
      IF LOCKED POLine THEN DO:
        pcError = pcError + "POLine is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE POLine THEN DELETE POLine.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER POLine:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH POLine NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_poline " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

