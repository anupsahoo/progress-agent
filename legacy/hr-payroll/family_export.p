/*------------------------------------------------------------------------
    File        : family_export.p
    Purpose     : Export Family to CSV
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-03  jkm  audit fields
 *  2011-03  tlw  Y2K date window
 *  2005-06  mab  appserver split
 *  2008-11  tlw  audit fields
 *  2003-07  tlw  audit fields
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "family_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Emp No,Relative Name,Relation,Birthdate,Covered On Benefits,Benefit Date" SKIP.
FOR EACH Family NO-LOCK
    WHERE Family.Birthdate = ? OR Family.Birthdate >= TODAY - 3650
    BY Family.EmpNum:
    EXPORT DELIMITER "," Family.EmpNum Family.RelativeName Family.Relation Family.Birthdate Family.CoveredOnBenefits Family.BenefitDate.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=Family" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "Family export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

