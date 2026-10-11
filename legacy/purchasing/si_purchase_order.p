/*------------------------------------------------------------------------
    File        : si_purchase_order.p
    Purpose     : AppServer service interface for PurchaseOrder
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

{purchasing/tt_purchase_order.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsPurchaseOrder.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcPurchaseOrder FOR PurchaseOrder.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttPurchaseOrder:ATTACH-DATA-SOURCE(DATA-SOURCE srcPurchaseOrder:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcPurchaseOrder:FILL-WHERE-STRING = pcWhere.
    DATASET dsPurchaseOrder:FILL().
    BUFFER ttPurchaseOrder:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttPurchaseOrder:ATTACH-DATA-SOURCE(DATA-SOURCE srcPurchaseOrder:HANDLE).
    FOR EACH btPurchaseOrder:
      BUFFER btPurchaseOrder:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btPurchaseOrder:ERROR THEN pcError = pcError + BUFFER btPurchaseOrder:ERROR-STRING + "~n".
    END.
    BUFFER ttPurchaseOrder:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttPurchaseOrder:
      FIND FIRST PurchaseOrder EXCLUSIVE-LOCK WHERE PurchaseOrder.PONum = ttPurchaseOrder.PONum NO-WAIT NO-ERROR.
      IF LOCKED PurchaseOrder THEN DO:
        pcError = pcError + "PurchaseOrder is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE PurchaseOrder THEN DELETE PurchaseOrder.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER PurchaseOrder:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH PurchaseOrder NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_purchase_order " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

