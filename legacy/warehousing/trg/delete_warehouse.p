/*------------------------------------------------------------------------
    File        : delete_warehouse.p
    Purpose     : schema DELETE trigger for Warehouse, referential integrity
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2009-09  rdh  performance: use index
 *  2014-02  rdh  performance: use index
 */

/* trg/delete_warehouse.p : schema DELETE trigger for Warehouse, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF Warehouse.

{shared/sysdefs.i}

IF CAN-FIND(FIRST Bin WHERE Bin.WarehouseNum = Warehouse.WarehouseNum) THEN DO:
  MESSAGE "Cannot delete Warehouse: Bin records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST InventoryTrans WHERE InventoryTrans.WarehouseNum = Warehouse.WarehouseNum) THEN DO:
  MESSAGE "Cannot delete Warehouse: InventoryTrans records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST Order WHERE Order.WarehouseNum = Warehouse.WarehouseNum) THEN DO:
  MESSAGE "Cannot delete Warehouse: Order records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/warehouse_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT Warehouse.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of Warehouse by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/warehouse.q") APPEND.
EXPORT "Warehouse" "D" STRING(NOW) Warehouse.WarehouseNum.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "Warehouse", INPUT STRING(ROWID(Warehouse)), INPUT "DELETE").

