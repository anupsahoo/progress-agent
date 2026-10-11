/*------------------------------------------------------------------------
    File        : benefits_batch.p
    Purpose     : Nightly Benefits housekeeping
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2017-06  rdh  appserver split
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "benefits_batch.log") APPEND.
PUT UNFORMATTED "Benefits batch started " STRING(NOW) SKIP.

FOR EACH Benefits EXCLUSIVE-LOCK
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF Benefits.LifeInsurance < 0 THEN DO:
        PUT UNFORMATTED "Negative Life Insurance on " STRING(Benefits.EmpNum) SKIP.
        ASSIGN Benefits.LifeInsurance = 0 iChanged = iChanged + 1.
    END.
    IF Benefits.HealthCare <> TRIM(Benefits.HealthCare) THEN
        ASSIGN Benefits.HealthCare = TRIM(Benefits.HealthCare) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "Benefits batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

