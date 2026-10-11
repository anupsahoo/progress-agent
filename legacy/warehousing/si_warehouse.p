/*------------------------------------------------------------------------
    File        : si_warehouse.p
    Purpose     : AppServer service interface for Warehouse
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

{warehousing/tt_warehouse.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsWarehouse.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcWarehouse FOR Warehouse.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttWarehouse:ATTACH-DATA-SOURCE(DATA-SOURCE srcWarehouse:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcWarehouse:FILL-WHERE-STRING = pcWhere.
    DATASET dsWarehouse:FILL().
    BUFFER ttWarehouse:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttWarehouse:ATTACH-DATA-SOURCE(DATA-SOURCE srcWarehouse:HANDLE).
    FOR EACH btWarehouse:
      BUFFER btWarehouse:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btWarehouse:ERROR THEN pcError = pcError + BUFFER btWarehouse:ERROR-STRING + "~n".
    END.
    BUFFER ttWarehouse:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttWarehouse:
      FIND FIRST Warehouse EXCLUSIVE-LOCK WHERE Warehouse.WarehouseNum = ttWarehouse.WarehouseNum NO-WAIT NO-ERROR.
      IF LOCKED Warehouse THEN DO:
        pcError = pcError + "Warehouse is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE Warehouse THEN DELETE Warehouse.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER Warehouse:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH Warehouse NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_warehouse " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

