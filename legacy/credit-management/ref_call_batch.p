/*------------------------------------------------------------------------
    File        : ref_call_batch.p
    Purpose     : Nightly RefCall housekeeping
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2004-01  kpo  add lock retry
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "ref_call_batch.log") APPEND.
PUT UNFORMATTED "RefCall batch started " STRING(NOW) SKIP.

FOR EACH RefCall EXCLUSIVE-LOCK
    WHERE RefCall.CallDate <> ?
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF RefCall.SalesRep <> TRIM(RefCall.SalesRep) THEN
        ASSIGN RefCall.SalesRep = TRIM(RefCall.SalesRep) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "RefCall batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

