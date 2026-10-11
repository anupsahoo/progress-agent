/*------------------------------------------------------------------------
    File        : si_inventory_trans.p
    Purpose     : AppServer service interface for InventoryTrans
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

{inventory/tt_inventory_trans.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsInventoryTrans.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcInventoryTrans FOR InventoryTrans.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttInventoryTrans:ATTACH-DATA-SOURCE(DATA-SOURCE srcInventoryTrans:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcInventoryTrans:FILL-WHERE-STRING = pcWhere.
    DATASET dsInventoryTrans:FILL().
    BUFFER ttInventoryTrans:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttInventoryTrans:ATTACH-DATA-SOURCE(DATA-SOURCE srcInventoryTrans:HANDLE).
    FOR EACH btInventoryTrans:
      BUFFER btInventoryTrans:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btInventoryTrans:ERROR THEN pcError = pcError + BUFFER btInventoryTrans:ERROR-STRING + "~n".
    END.
    BUFFER ttInventoryTrans:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttInventoryTrans:
      FIND FIRST InventoryTrans EXCLUSIVE-LOCK WHERE InventoryTrans.InvTransNum = ttInventoryTrans.InvTransNum NO-WAIT NO-ERROR.
      IF LOCKED InventoryTrans THEN DO:
        pcError = pcError + "InventoryTrans is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE InventoryTrans THEN DELETE InventoryTrans.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER InventoryTrans:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH InventoryTrans NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_inventory_trans " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

