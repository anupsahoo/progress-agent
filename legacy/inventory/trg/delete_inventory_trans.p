/*------------------------------------------------------------------------
    File        : delete_inventory_trans.p
    Purpose     : schema DELETE trigger for InventoryTrans, referential integrity
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2014-07  kpo  Y2K date window
 *  2004-08  kpo  remove dead code
 *  2006-06  jkm  fix rounding
 */

/* trg/delete_inventory_trans.p : schema DELETE trigger for InventoryTrans, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF InventoryTrans.

{shared/sysdefs.i}

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/inventory_trans_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT InventoryTrans.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of InventoryTrans by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/inventory_trans.q") APPEND.
EXPORT "InventoryTrans" "D" STRING(NOW) InventoryTrans.InvTransNum.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "InventoryTrans", INPUT STRING(ROWID(InventoryTrans)), INPUT "DELETE").

