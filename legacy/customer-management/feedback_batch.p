/*------------------------------------------------------------------------
    File        : feedback_batch.p
    Purpose     : Nightly Feedback housekeeping
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-09  rdh  fix rounding
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "feedback_batch.log") APPEND.
PUT UNFORMATTED "Feedback batch started " STRING(NOW) SKIP.

FOR EACH Feedback EXCLUSIVE-LOCK
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF Feedback.Rating < 0 THEN DO:
        PUT UNFORMATTED "Negative Rating on " STRING(Feedback.Department) SKIP.
        ASSIGN Feedback.Rating = 0 iChanged = iChanged + 1.
    END.
    IF Feedback.Contact <> TRIM(Feedback.Contact) THEN
        ASSIGN Feedback.Contact = TRIM(Feedback.Contact) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "Feedback batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

