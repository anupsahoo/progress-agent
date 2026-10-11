/*------------------------------------------------------------------------
    File        : si_order.p
    Purpose     : AppServer service interface for Order
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

{order-entry/tt_order.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsOrder.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcOrder FOR Order.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttOrder:ATTACH-DATA-SOURCE(DATA-SOURCE srcOrder:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcOrder:FILL-WHERE-STRING = pcWhere.
    DATASET dsOrder:FILL().
    BUFFER ttOrder:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttOrder:ATTACH-DATA-SOURCE(DATA-SOURCE srcOrder:HANDLE).
    FOR EACH btOrder:
      BUFFER btOrder:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btOrder:ERROR THEN pcError = pcError + BUFFER btOrder:ERROR-STRING + "~n".
    END.
    BUFFER ttOrder:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttOrder:
      FIND FIRST Order EXCLUSIVE-LOCK WHERE Order.Ordernum = ttOrder.Ordernum NO-WAIT NO-ERROR.
      IF LOCKED Order THEN DO:
        pcError = pcError + "Order is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE Order THEN DELETE Order.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER Order:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH Order NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_order " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

