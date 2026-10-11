/*------------------------------------------------------------------------
    File        : bill_to_export.p
    Purpose     : Export BillTo to CSV
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2008-04  jkm  remove dead code
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "bill_to_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Cust Num,BillToID,Name,Address,Address2,City,State,Postal Code,Contact,Phone" SKIP.
FOR EACH BillTo NO-LOCK
    BY BillTo.CustNum:
    EXPORT DELIMITER "," BillTo.CustNum BillTo.BillToID BillTo.Name BillTo.Address BillTo.Address2 BillTo.City BillTo.State BillTo.PostalCode BillTo.Contact BillTo.Phone.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=BillTo" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "BillTo export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

