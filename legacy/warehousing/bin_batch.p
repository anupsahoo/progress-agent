/*------------------------------------------------------------------------
    File        : bin_batch.p
    Purpose     : Nightly Bin housekeeping
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2003-06  mab  new report column
 *  2008-11  tlw  remove dead code
 *  2000-12  tlw  add lock retry
 *  2002-04  jkm  appserver split
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "bin_batch.log") APPEND.
PUT UNFORMATTED "Bin batch started " STRING(NOW) SKIP.

FOR EACH Bin EXCLUSIVE-LOCK
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF Bin.Qty < 0 THEN DO:
        PUT UNFORMATTED "Negative Qty on " STRING(Bin.BinNum) SKIP.
        ASSIGN Bin.Qty = 0 iChanged = iChanged + 1.
    END.
    IF Bin.BinName <> TRIM(Bin.BinName) THEN
        ASSIGN Bin.BinName = TRIM(Bin.BinName) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "Bin batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

