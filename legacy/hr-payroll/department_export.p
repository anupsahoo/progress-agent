/*------------------------------------------------------------------------
    File        : department_export.p
    Purpose     : Export Department to CSV
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2012-08  rdh  remove dead code
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "department_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Dept Code,Dept Name" SKIP.
FOR EACH Department NO-LOCK
    BY Department.DeptCode:
    EXPORT DELIMITER "," Department.DeptCode Department.DeptName.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=Department" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "Department export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

