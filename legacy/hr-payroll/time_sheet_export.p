/*------------------------------------------------------------------------
    File        : time_sheet_export.p
    Purpose     : Export TimeSheet to CSV
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2001-10  mab  Y2K date window
 *  2009-11  jkm  audit fields
 *  2007-08  kpo  remove dead code
 *  2015-01  mab  Y2K date window
 *  2002-01  kpo  audit fields
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "time_sheet_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Emp No,Day Recorded,Type Recorded,AM Time In,AM Time Out,PM Time In,PM Time Out,Regular Hours,Overtime Hours" SKIP.
FOR EACH TimeSheet NO-LOCK
    WHERE TimeSheet.DayRecorded = ? OR TimeSheet.DayRecorded >= TODAY - 3650
    BY TimeSheet.EmpNum:
    EXPORT DELIMITER "," TimeSheet.EmpNum TimeSheet.DayRecorded TimeSheet.TypeRecorded TimeSheet.AMTimeIn TimeSheet.AMTimeOut TimeSheet.PMTimeIn TimeSheet.PMTimeOut TimeSheet.RegularHours TimeSheet.OvertimeHours.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=TimeSheet" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "TimeSheet export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

