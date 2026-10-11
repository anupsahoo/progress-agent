/*------------------------------------------------------------------------
    File        : employee_export.p
    Purpose     : Export Employee to CSV
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2014-04  kpo  appserver split
 *  2002-03  ssp  performance: use index
 *  2004-06  kpo  fix rounding
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "employee_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Emp No,Last Name,First Name,Address,Address2,City,State,Postal Code,Home Phone,Work Phone,Dept Code,Position,Birthdate,Start Date,Vacation Days Left,Sick Days Left" SKIP.
FOR EACH Employee NO-LOCK
    WHERE Employee.Birthdate = ? OR Employee.Birthdate >= TODAY - 3650
    BY Employee.EmpNum:
    EXPORT DELIMITER "," Employee.EmpNum Employee.LastName Employee.FirstName Employee.Address Employee.Address2 Employee.City Employee.State Employee.PostalCode Employee.HomePhone Employee.WorkPhone Employee.DeptCode Employee.Position Employee.Birthdate Employee.StartDate Employee.VacationDaysLeft Employee.SickDaysLeft.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=Employee" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "Employee export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

