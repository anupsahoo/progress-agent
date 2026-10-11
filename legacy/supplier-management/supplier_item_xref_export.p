/*------------------------------------------------------------------------
    File        : supplier_item_xref_export.p
    Purpose     : Export SupplierItemXref to CSV
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2014-06  rdh  new report column
 *  2017-02  kpo  audit fields
 *  2006-07  ssp  appserver split
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "supplier_item_xref_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Supplier ID,Item #" SKIP.
FOR EACH SupplierItemXref NO-LOCK
    BY SupplierItemXref.SupplierIDNum:
    EXPORT DELIMITER "," SupplierItemXref.SupplierIDNum SupplierItemXref.Itemnum.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=SupplierItemXref" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "SupplierItemXref export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

