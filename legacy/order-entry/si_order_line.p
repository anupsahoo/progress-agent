/*------------------------------------------------------------------------
    File        : si_order_line.p
    Purpose     : AppServer service interface for OrderLine
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

{order-entry/tt_order_line.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsOrderLine.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcOrderLine FOR OrderLine.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttOrderLine:ATTACH-DATA-SOURCE(DATA-SOURCE srcOrderLine:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcOrderLine:FILL-WHERE-STRING = pcWhere.
    DATASET dsOrderLine:FILL().
    BUFFER ttOrderLine:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttOrderLine:ATTACH-DATA-SOURCE(DATA-SOURCE srcOrderLine:HANDLE).
    FOR EACH btOrderLine:
      BUFFER btOrderLine:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btOrderLine:ERROR THEN pcError = pcError + BUFFER btOrderLine:ERROR-STRING + "~n".
    END.
    BUFFER ttOrderLine:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttOrderLine:
      FIND FIRST OrderLine EXCLUSIVE-LOCK WHERE OrderLine.Ordernum = ttOrderLine.Ordernum AND OrderLine.Linenum = ttOrderLine.Linenum NO-WAIT NO-ERROR.
      IF LOCKED OrderLine THEN DO:
        pcError = pcError + "OrderLine is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE OrderLine THEN DELETE OrderLine.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER OrderLine:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH OrderLine NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_order_line " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

