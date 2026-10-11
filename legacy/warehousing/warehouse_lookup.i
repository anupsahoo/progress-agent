/*------------------------------------------------------------------------
    File        : warehouse_lookup.i
    Purpose     : Warehouse lookup helpers. {&NO-WAREHOUSE-FUNCS} suppresses the functions.
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2011-09  ssp  add lock retry
 *  2017-05  ssp  Y2K date window
 */

/* warehouse_lookup.i : Warehouse lookup helpers. {&NO-WAREHOUSE-FUNCS} suppresses the functions. */

&IF DEFINED(WAREHOUSE_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE WAREHOUSE_LOOKUP_I YES

DEFINE BUFFER bLkWarehouse FOR Warehouse.

FUNCTION WarehouseExists RETURNS LOGICAL (INPUT pWarehouseNum AS INTEGER):
  RETURN CAN-FIND(FIRST bLkWarehouse WHERE bLkWarehouse.WarehouseNum = pWarehouseNum).
END FUNCTION.

FUNCTION WarehouseDesc RETURNS CHARACTER (INPUT pWarehouseNum AS INTEGER):
  FIND FIRST bLkWarehouse NO-LOCK WHERE bLkWarehouse.WarehouseNum = pWarehouseNum NO-ERROR.
  RETURN (IF AVAILABLE bLkWarehouse THEN bLkWarehouse.WarehouseName ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-warehouse :
  DEFINE INPUT  PARAMETER pWarehouseNum AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkWarehouse NO-LOCK WHERE bLkWarehouse.WarehouseNum = pWarehouseNum NO-ERROR.
  pRowid = IF AVAILABLE bLkWarehouse THEN ROWID(bLkWarehouse) ELSE ?.
END PROCEDURE.

&ENDIF

