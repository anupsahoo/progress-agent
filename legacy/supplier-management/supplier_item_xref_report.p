/*------------------------------------------------------------------------
    File        : supplier_item_xref_report.p
    Purpose     : SupplierItemXref listing with control-break totals
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-02  mab  new report column
 *  2012-04  rdh  new report column
 *  2010-11  rdh  fix rounding
 *  2013-03  kpo  Y2K date window
 *  2017-10  mab  credit hold rule
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "SupplierItemXref Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "supplier_item_xref_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH SupplierItemXref NO-LOCK
    :
    iCount = iCount + 1.
    DISPLAY STREAM sRpt SupplierItemXref.SupplierIDNum SupplierItemXref.Itemnum
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
END.

PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
OUTPUT STREAM sRpt CLOSE.

