/*------------------------------------------------------------------------
    File        : order_batch.p
    Purpose     : Nightly Order housekeeping
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-05  kpo  Y2K date window
 *  2010-09  rdh  credit hold rule
 *  2000-10  kpo  add lock retry
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "order_batch.log") APPEND.
PUT UNFORMATTED "Order batch started " STRING(NOW) SKIP.

FOR EACH Order EXCLUSIVE-LOCK
    WHERE Order.OrderDate <> ?
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF Order.Carrier <> TRIM(Order.Carrier) THEN
        ASSIGN Order.Carrier = TRIM(Order.Carrier) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "Order batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

