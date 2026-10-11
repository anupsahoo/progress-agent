/*------------------------------------------------------------------------
    File        : customer_export.p
    Purpose     : Export Customer to CSV
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2004-10  jkm  new report column
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "customer_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Cust Num,Country,Name,Address,Address2,City,State,Postal Code,Contact,Phone,Sales Rep,Credit Limit,Balance,Terms,Discount,Comments,Fax,Email" SKIP.
FOR EACH Customer NO-LOCK
    BY Customer.CustNum:
    EXPORT DELIMITER "," Customer.CustNum Customer.Country Customer.Name Customer.Address Customer.Address2 Customer.City Customer.State Customer.PostalCode Customer.Contact Customer.Phone Customer.SalesRep Customer.CreditLimit Customer.Balance Customer.Terms Customer.Discount Customer.Comments Customer.Fax Customer.EmailAddress.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=Customer" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "Customer export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

