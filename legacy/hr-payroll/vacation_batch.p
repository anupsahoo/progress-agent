/*------------------------------------------------------------------------
    File        : vacation_batch.p
    Purpose     : Nightly Vacation housekeeping
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2001-06  mab  fix rounding
 *  2003-08  ssp  performance: use index
 *  2006-02  ssp  remove dead code
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "vacation_batch.log") APPEND.
PUT UNFORMATTED "Vacation batch started " STRING(NOW) SKIP.

FOR EACH Vacation EXCLUSIVE-LOCK
    WHERE Vacation.StartDate <> ?
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "Vacation batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

