/*------------------------------------------------------------------------
    File        : warehouse_batch.p
    Purpose     : Nightly Warehouse housekeeping
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-06  ssp  remove dead code
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "warehouse_batch.log") APPEND.
PUT UNFORMATTED "Warehouse batch started " STRING(NOW) SKIP.

FOR EACH Warehouse EXCLUSIVE-LOCK
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF Warehouse.WarehouseName <> TRIM(Warehouse.WarehouseName) THEN
        ASSIGN Warehouse.WarehouseName = TRIM(Warehouse.WarehouseName) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "Warehouse batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

