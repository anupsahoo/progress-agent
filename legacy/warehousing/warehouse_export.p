/*------------------------------------------------------------------------
    File        : warehouse_export.p
    Purpose     : Export Warehouse to CSV
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2003-05  jkm  new report column
 *  2015-04  ssp  audit fields
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "warehouse_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Warehouse Num,Warehouse Name,Country,Address,Address2,City,State,Postal Code,Phone" SKIP.
FOR EACH Warehouse NO-LOCK
    BY Warehouse.WarehouseNum:
    EXPORT DELIMITER "," Warehouse.WarehouseNum Warehouse.WarehouseName Warehouse.Country Warehouse.Address Warehouse.Address2 Warehouse.City Warehouse.State Warehouse.PostalCode Warehouse.Phone.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=Warehouse" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "Warehouse export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

