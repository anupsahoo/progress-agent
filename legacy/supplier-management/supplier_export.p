/*------------------------------------------------------------------------
    File        : supplier_export.p
    Purpose     : Export Supplier to CSV
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2006-12  tlw  Y2K date window
 *  2008-10  tlw  new report column
 *  2002-09  jkm  fix rounding
 *  2017-02  mab  new report column
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "supplier_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Supplier ID,Name,Address,Address2,City,State,ZipCode,Country,Phone,Comments,Password,Login Date,Ship Amount,Discount" SKIP.
FOR EACH Supplier NO-LOCK
    WHERE Supplier.LoginDate = ? OR Supplier.LoginDate >= TODAY - 3650
    BY Supplier.SupplierIDNum:
    EXPORT DELIMITER "," Supplier.SupplierIDNum Supplier.Name Supplier.Address Supplier.Address2 Supplier.City Supplier.State Supplier.PostalCode Supplier.Country Supplier.Phone Supplier.Comments Supplier.Password Supplier.LoginDate Supplier.ShipAmount Supplier.Discount.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=Supplier" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "Supplier export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

