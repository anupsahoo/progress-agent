/*------------------------------------------------------------------------
    File        : time_sheet_batch.p
    Purpose     : Nightly TimeSheet housekeeping
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-02  tlw  credit hold rule
 *  2003-05  jkm  appserver split
 *  2002-04  ssp  credit hold rule
 *  2012-01  tlw  credit hold rule
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "time_sheet_batch.log") APPEND.
PUT UNFORMATTED "TimeSheet batch started " STRING(NOW) SKIP.

FOR EACH TimeSheet EXCLUSIVE-LOCK
    WHERE TimeSheet.DayRecorded <> ?
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF TimeSheet.RegularHours < 0 THEN DO:
        PUT UNFORMATTED "Negative Regular Hours on " STRING(TimeSheet.EmpNum) "/" STRING(TimeSheet.DayRecorded) SKIP.
        ASSIGN TimeSheet.RegularHours = 0 iChanged = iChanged + 1.
    END.
    IF TimeSheet.TypeRecorded <> TRIM(TimeSheet.TypeRecorded) THEN
        ASSIGN TimeSheet.TypeRecorded = TRIM(TimeSheet.TypeRecorded) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "TimeSheet batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

