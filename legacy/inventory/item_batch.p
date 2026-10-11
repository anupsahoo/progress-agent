/*------------------------------------------------------------------------
    File        : item_batch.p
    Purpose     : Nightly Item housekeeping
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-08  kpo  credit hold rule
 *  2008-04  ssp  appserver split
 *  2015-04  rdh  new report column
 *  2014-07  kpo  new report column
 *  2012-06  ssp  performance: use index
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "item_batch.log") APPEND.
PUT UNFORMATTED "Item batch started " STRING(NOW) SKIP.

FOR EACH Item EXCLUSIVE-LOCK
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF Item.Price < 0 THEN DO:
        PUT UNFORMATTED "Negative Price on " STRING(Item.Itemnum) SKIP.
        ASSIGN Item.Price = 0 iChanged = iChanged + 1.
    END.
    IF Item.ItemName <> TRIM(Item.ItemName) THEN
        ASSIGN Item.ItemName = TRIM(Item.ItemName) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "Item batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

