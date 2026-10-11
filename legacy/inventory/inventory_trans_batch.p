/*------------------------------------------------------------------------
    File        : inventory_trans_batch.p
    Purpose     : Nightly InventoryTrans housekeeping
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-06  jkm  add lock retry
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "inventory_trans_batch.log") APPEND.
PUT UNFORMATTED "InventoryTrans batch started " STRING(NOW) SKIP.

FOR EACH InventoryTrans EXCLUSIVE-LOCK
    WHERE InventoryTrans.TransDate <> ?
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF InventoryTrans.Qty < 0 THEN DO:
        PUT UNFORMATTED "Negative Qty on " STRING(InventoryTrans.InvTransNum) SKIP.
        ASSIGN InventoryTrans.Qty = 0 iChanged = iChanged + 1.
    END.
    IF InventoryTrans.InvType <> TRIM(InventoryTrans.InvType) THEN
        ASSIGN InventoryTrans.InvType = TRIM(InventoryTrans.InvType) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "InventoryTrans batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

