/*------------------------------------------------------------------------
    File        : benefits_export.p
    Purpose     : Export Benefits to CSV
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-07  mab  audit fields
 *  2000-04  mab  appserver split
 *  2000-10  rdh  performance: use index
 *  2017-09  jkm  new report column
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "benefits_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Emp No,Health Care,Life Insurance,Pension401K,Stock Purchase,Medical Spending,Dependent Care" SKIP.
FOR EACH Benefits NO-LOCK
    BY Benefits.EmpNum:
    EXPORT DELIMITER "," Benefits.EmpNum Benefits.HealthCare Benefits.LifeInsurance Benefits.Pension401K Benefits.StockPurchase Benefits.MedicalSpending Benefits.DependentCare.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=Benefits" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "Benefits export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

