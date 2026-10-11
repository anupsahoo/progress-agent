/*------------------------------------------------------------------------
    File        : warehouse_val.p
    Purpose     : Business validation for Warehouse
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bWarehouse FOR Warehouse.

FIND bWarehouse WHERE ROWID(bWarehouse) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bWarehouse THEN DO:
  ASSIGN plOk = NO pcMsg = "Warehouse record not found.".
  RETURN.
END.

/* WarehouseNum: warehousenum > 0 */
IF NOT (bWarehouse.WarehouseNum > 0) THEN
  RUN add-error ("Entrer a number greater than zero").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

