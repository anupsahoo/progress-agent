/*------------------------------------------------------------------------
    File        : purchase_order_batch.p
    Purpose     : Nightly PurchaseOrder housekeeping
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-01  ssp  credit hold rule
 *  2002-10  rdh  performance: use index
 *  2009-03  jkm  audit fields
 *  2003-07  rdh  add lock retry
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "purchase_order_batch.log") APPEND.
PUT UNFORMATTED "PurchaseOrder batch started " STRING(NOW) SKIP.

FOR EACH PurchaseOrder EXCLUSIVE-LOCK
    WHERE PurchaseOrder.DateEntered <> ?
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF PurchaseOrder.POStatus <> TRIM(PurchaseOrder.POStatus) THEN
        ASSIGN PurchaseOrder.POStatus = TRIM(PurchaseOrder.POStatus) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "PurchaseOrder batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

