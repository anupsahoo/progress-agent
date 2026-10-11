/*------------------------------------------------------------------------
    File        : si_salesrep.p
    Purpose     : AppServer service interface for Salesrep
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

{sales-territories/tt_salesrep.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsSalesrep.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcSalesrep FOR Salesrep.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttSalesrep:ATTACH-DATA-SOURCE(DATA-SOURCE srcSalesrep:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcSalesrep:FILL-WHERE-STRING = pcWhere.
    DATASET dsSalesrep:FILL().
    BUFFER ttSalesrep:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttSalesrep:ATTACH-DATA-SOURCE(DATA-SOURCE srcSalesrep:HANDLE).
    FOR EACH btSalesrep:
      BUFFER btSalesrep:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btSalesrep:ERROR THEN pcError = pcError + BUFFER btSalesrep:ERROR-STRING + "~n".
    END.
    BUFFER ttSalesrep:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttSalesrep:
      FIND FIRST Salesrep EXCLUSIVE-LOCK WHERE Salesrep.SalesRep = ttSalesrep.SalesRep NO-WAIT NO-ERROR.
      IF LOCKED Salesrep THEN DO:
        pcError = pcError + "Salesrep is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE Salesrep THEN DELETE Salesrep.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER Salesrep:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH Salesrep NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_salesrep " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

