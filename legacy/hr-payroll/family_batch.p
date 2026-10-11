/*------------------------------------------------------------------------
    File        : family_batch.p
    Purpose     : Nightly Family housekeeping
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-02  jkm  add lock retry
 *  2009-07  kpo  appserver split
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "family_batch.log") APPEND.
PUT UNFORMATTED "Family batch started " STRING(NOW) SKIP.

FOR EACH Family EXCLUSIVE-LOCK
    WHERE Family.Birthdate <> ?
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF Family.Relation <> TRIM(Family.Relation) THEN
        ASSIGN Family.Relation = TRIM(Family.Relation) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "Family batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

