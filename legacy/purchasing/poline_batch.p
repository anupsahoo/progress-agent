/*------------------------------------------------------------------------
    File        : poline_batch.p
    Purpose     : Nightly POLine housekeeping
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2012-05  jkm  performance: use index
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "poline_batch.log") APPEND.
PUT UNFORMATTED "POLine batch started " STRING(NOW) SKIP.

FOR EACH POLine EXCLUSIVE-LOCK
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF POLine.Price < 0 THEN DO:
        PUT UNFORMATTED "Negative Price on " STRING(POLine.PONum) "/" STRING(POLine.Linenum) SKIP.
        ASSIGN POLine.Price = 0 iChanged = iChanged + 1.
    END.
    IF POLine.POLineStatus <> TRIM(POLine.POLineStatus) THEN
        ASSIGN POLine.POLineStatus = TRIM(POLine.POLineStatus) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "POLine batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

