/*------------------------------------------------------------------------
    File        : ship_to_batch.p
    Purpose     : Nightly ShipTo housekeeping
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2002-07  rdh  new report column
 *  2002-08  tlw  audit fields
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "ship_to_batch.log") APPEND.
PUT UNFORMATTED "ShipTo batch started " STRING(NOW) SKIP.

FOR EACH ShipTo EXCLUSIVE-LOCK
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF ShipTo.Contact <> TRIM(ShipTo.Contact) THEN
        ASSIGN ShipTo.Contact = TRIM(ShipTo.Contact) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "ShipTo batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

