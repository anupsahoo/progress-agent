/*------------------------------------------------------------------------
    File        : ship_to_export.p
    Purpose     : Export ShipTo to CSV
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2009-11  ssp  credit hold rule
 *  2000-10  rdh  appserver split
 *  2013-12  tlw  fix rounding
 *  2002-03  rdh  performance: use index
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "ship_to_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Cust Num,Ship To ID,Contact,Address,Address2,City,State,Postal Code,Phone,Comments,Name" SKIP.
FOR EACH ShipTo NO-LOCK
    BY ShipTo.CustNum:
    EXPORT DELIMITER "," ShipTo.CustNum ShipTo.ShipToID ShipTo.Contact ShipTo.Address ShipTo.Address2 ShipTo.City ShipTo.State ShipTo.PostalCode ShipTo.Phone ShipTo.Comments ShipTo.Name.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=ShipTo" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "ShipTo export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

