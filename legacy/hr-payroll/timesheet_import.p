/*------------------------------------------------------------------------
    File        : timesheet_import.p
    Purpose     : Time clock import
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-02  rdh  credit hold rule
 */

{shared/sysdefs.i}
{hr-payroll/tt_time_sheet.i}

DEFINE INPUT PARAMETER pcDir AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRecs AS INTEGER   NO-UNDO.
DEFINE VARIABLE lcDoc AS LONGCHAR  NO-UNDO.

cFile = pcDir + "/timesheet_import_" + STRING(TODAY, "99999999") + ".dat".

FOR EACH TimeSheet NO-LOCK:
    CREATE ttTimeSheet.
    BUFFER-COPY TimeSheet TO ttTimeSheet.
    iRecs = iRecs + 1.
END.

DATASET dsTimeSheet:WRITE-JSON("LONGCHAR", lcDoc, TRUE).
COPY-LOB FROM lcDoc TO FILE cFile.

OUTPUT TO VALUE(cFile + ".ctl").
PUT UNFORMATTED "RECORDS=" iRecs SKIP "SOURCE=TimeSheet" SKIP "FIELDS=EmpNum,DayRecorded,TypeRecorded,AMTimeIn,AMTimeOut,PMTimeIn,PMTimeOut,RegularHours,OvertimeHours" SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "timesheet_import.p: " + STRING(iRecs) + " records written").

