/*------------------------------------------------------------------------
    File        : local_default_batch.p
    Purpose     : Nightly LocalDefault housekeeping
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2015-12  mab  audit fields
 *  2010-10  mab  add lock retry
 *  2006-11  tlw  credit hold rule
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "local_default_batch.log") APPEND.
PUT UNFORMATTED "LocalDefault batch started " STRING(NOW) SKIP.

FOR EACH LocalDefault EXCLUSIVE-LOCK
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF LocalDefault.Country <> TRIM(LocalDefault.Country) THEN
        ASSIGN LocalDefault.Country = TRIM(LocalDefault.Country) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "LocalDefault batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

