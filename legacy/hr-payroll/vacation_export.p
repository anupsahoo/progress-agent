/*------------------------------------------------------------------------
    File        : vacation_export.p
    Purpose     : Export Vacation to CSV
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2003-04  rdh  credit hold rule
 *  2011-10  jkm  performance: use index
 *  2011-07  mab  performance: use index
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "vacation_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Emp No,Start Date,End Date" SKIP.
FOR EACH Vacation NO-LOCK
    WHERE Vacation.StartDate = ? OR Vacation.StartDate >= TODAY - 3650
    BY Vacation.EmpNum:
    EXPORT DELIMITER "," Vacation.EmpNum Vacation.StartDate Vacation.EndDate.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=Vacation" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "Vacation export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

