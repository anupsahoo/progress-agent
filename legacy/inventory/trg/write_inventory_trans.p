/*------------------------------------------------------------------------
    File        : write_inventory_trans.p
    Purpose     : schema WRITE trigger for InventoryTrans, field-level audit
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2003-11  rdh  appserver split
 *  2002-08  ssp  Y2K date window
 *  2012-02  tlw  appserver split
 *  2005-06  mab  add lock retry
 *  2002-05  rdh  add lock retry
 */

/* trg/write_inventory_trans.p : schema WRITE trigger for InventoryTrans, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF InventoryTrans OLD BUFFER oldInventoryTrans.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN inventory/inventory_trans_val.p (INPUT ROWID(InventoryTrans), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "InventoryTrans write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF InventoryTrans.InvTransNum <> oldInventoryTrans.InvTransNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "InventoryTrans.InvTransNum", INPUT STRING(oldInventoryTrans.InvTransNum), INPUT STRING(InventoryTrans.InvTransNum)).
END.
IF InventoryTrans.WarehouseNum <> oldInventoryTrans.WarehouseNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "InventoryTrans.WarehouseNum", INPUT STRING(oldInventoryTrans.WarehouseNum), INPUT STRING(InventoryTrans.WarehouseNum)).
END.
IF InventoryTrans.BinNum <> oldInventoryTrans.BinNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "InventoryTrans.BinNum", INPUT STRING(oldInventoryTrans.BinNum), INPUT STRING(InventoryTrans.BinNum)).
END.
IF InventoryTrans.Qty <> oldInventoryTrans.Qty THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "InventoryTrans.Qty", INPUT STRING(oldInventoryTrans.Qty), INPUT STRING(InventoryTrans.Qty)).
END.
IF InventoryTrans.Itemnum <> oldInventoryTrans.Itemnum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "InventoryTrans.Itemnum", INPUT STRING(oldInventoryTrans.Itemnum), INPUT STRING(InventoryTrans.Itemnum)).
END.
IF InventoryTrans.TransDate <> oldInventoryTrans.TransDate THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "InventoryTrans.TransDate", INPUT STRING(oldInventoryTrans.TransDate), INPUT STRING(InventoryTrans.TransDate)).
END.
IF InventoryTrans.InvType <> oldInventoryTrans.InvType THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "InventoryTrans.InvType", INPUT STRING(oldInventoryTrans.InvType), INPUT STRING(InventoryTrans.InvType)).
END.
IF InventoryTrans.PONum <> oldInventoryTrans.PONum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "InventoryTrans.PONum", INPUT STRING(oldInventoryTrans.PONum), INPUT STRING(InventoryTrans.PONum)).
END.
IF InventoryTrans.Ordernum <> oldInventoryTrans.Ordernum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "InventoryTrans.Ordernum", INPUT STRING(oldInventoryTrans.Ordernum), INPUT STRING(InventoryTrans.Ordernum)).
END.
IF InventoryTrans.Transtime <> oldInventoryTrans.Transtime THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "InventoryTrans.Transtime", INPUT STRING(oldInventoryTrans.Transtime), INPUT STRING(InventoryTrans.Transtime)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/inventory_trans.q") APPEND.
  EXPORT "InventoryTrans" "W" STRING(NOW) InventoryTrans.InvTransNum.
  OUTPUT CLOSE.
END.

