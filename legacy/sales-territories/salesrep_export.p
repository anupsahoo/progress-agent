/*------------------------------------------------------------------------
    File        : salesrep_export.p
    Purpose     : Export Salesrep to CSV
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2004-10  jkm  credit hold rule
 *  2014-12  tlw  Y2K date window
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "salesrep_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Sales Rep,Rep Name,Region" SKIP.
FOR EACH Salesrep NO-LOCK
    BY Salesrep.SalesRep:
    EXPORT DELIMITER "," Salesrep.SalesRep Salesrep.RepName Salesrep.Region.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=Salesrep" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "Salesrep export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

