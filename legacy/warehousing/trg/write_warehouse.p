/*------------------------------------------------------------------------
    File        : write_warehouse.p
    Purpose     : schema WRITE trigger for Warehouse, field-level audit
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2011-10  jkm  fix rounding
 */

/* trg/write_warehouse.p : schema WRITE trigger for Warehouse, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF Warehouse OLD BUFFER oldWarehouse.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN warehousing/warehouse_val.p (INPUT ROWID(Warehouse), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "Warehouse write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF Warehouse.WarehouseNum <> oldWarehouse.WarehouseNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Warehouse.WarehouseNum", INPUT STRING(oldWarehouse.WarehouseNum), INPUT STRING(Warehouse.WarehouseNum)).
END.
IF Warehouse.WarehouseName <> oldWarehouse.WarehouseName THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Warehouse.WarehouseName", INPUT STRING(oldWarehouse.WarehouseName), INPUT STRING(Warehouse.WarehouseName)).
END.
IF Warehouse.Country <> oldWarehouse.Country THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Warehouse.Country", INPUT STRING(oldWarehouse.Country), INPUT STRING(Warehouse.Country)).
END.
IF Warehouse.Address <> oldWarehouse.Address THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Warehouse.Address", INPUT STRING(oldWarehouse.Address), INPUT STRING(Warehouse.Address)).
END.
IF Warehouse.Address2 <> oldWarehouse.Address2 THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Warehouse.Address2", INPUT STRING(oldWarehouse.Address2), INPUT STRING(Warehouse.Address2)).
END.
IF Warehouse.City <> oldWarehouse.City THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Warehouse.City", INPUT STRING(oldWarehouse.City), INPUT STRING(Warehouse.City)).
END.
IF Warehouse.State <> oldWarehouse.State THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Warehouse.State", INPUT STRING(oldWarehouse.State), INPUT STRING(Warehouse.State)).
END.
IF Warehouse.PostalCode <> oldWarehouse.PostalCode THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Warehouse.PostalCode", INPUT STRING(oldWarehouse.PostalCode), INPUT STRING(Warehouse.PostalCode)).
END.
IF Warehouse.Phone <> oldWarehouse.Phone THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Warehouse.Phone", INPUT STRING(oldWarehouse.Phone), INPUT STRING(Warehouse.Phone)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/warehouse.q") APPEND.
  EXPORT "Warehouse" "W" STRING(NOW) Warehouse.WarehouseNum.
  OUTPUT CLOSE.
END.

