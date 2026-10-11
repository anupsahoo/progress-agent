/*------------------------------------------------------------------------
    File        : warehouse_report.p
    Purpose     : Warehouse listing with control-break totals
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2001-02  tlw  fix rounding
 *  2007-07  ssp  fix rounding
 *  2007-05  mab  new report column
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "Warehouse Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "warehouse_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH Warehouse NO-LOCK
    BREAK BY Warehouse.Country:
    iCount = iCount + 1.
    IF FIRST-OF(Warehouse.Country) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "Country: " Warehouse.Country SKIP.
    DISPLAY STREAM sRpt Warehouse.WarehouseNum Warehouse.WarehouseName Warehouse.Country Warehouse.Address Warehouse.Address2 Warehouse.City Warehouse.State
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
END.

PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
OUTPUT STREAM sRpt CLOSE.

