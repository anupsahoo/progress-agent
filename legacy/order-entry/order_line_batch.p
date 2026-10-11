/*------------------------------------------------------------------------
    File        : order_line_batch.p
    Purpose     : Nightly OrderLine housekeeping
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2002-09  tlw  audit fields
 *  2003-08  jkm  performance: use index
 *  2014-06  kpo  appserver split
 *  2008-02  kpo  fix rounding
 *  2016-02  kpo  Y2K date window
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "order_line_batch.log") APPEND.
PUT UNFORMATTED "OrderLine batch started " STRING(NOW) SKIP.

FOR EACH OrderLine EXCLUSIVE-LOCK
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF OrderLine.Price < 0 THEN DO:
        PUT UNFORMATTED "Negative Price on " STRING(OrderLine.Ordernum) "/" STRING(OrderLine.Linenum) SKIP.
        ASSIGN OrderLine.Price = 0 iChanged = iChanged + 1.
    END.
    IF OrderLine.OrderLineStatus <> TRIM(OrderLine.OrderLineStatus) THEN
        ASSIGN OrderLine.OrderLineStatus = TRIM(OrderLine.OrderLineStatus) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "OrderLine batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

