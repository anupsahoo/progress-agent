/*------------------------------------------------------------------------
    File        : bin_report.p
    Purpose     : Bin listing with control-break totals
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-12  mab  audit fields
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.
DEFINE VARIABLE dTotQty AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "Bin Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "bin_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH Bin NO-LOCK
    BREAK BY Bin.BinName:
    iCount = iCount + 1.
    ACCUMULATE Bin.Qty (TOTAL SUB-TOTAL BY Bin.BinName).
    IF FIRST-OF(Bin.BinName) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "Bin Name: " Bin.BinName SKIP.
    DISPLAY STREAM sRpt Bin.WarehouseNum Bin.Itemnum Bin.Qty Bin.BinNum Bin.BinName
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
    IF LAST-OF(Bin.BinName) THEN DO:
        PUT STREAM sRpt UNFORMATTED "  Subtotal Qty: " STRING(ACCUM SUB-TOTAL BY Bin.BinName Bin.Qty, "->>>,>>>,>>9.99") SKIP.
    END.
END.

dTotQty = ACCUM TOTAL Bin.Qty.
PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
PUT STREAM sRpt UNFORMATTED "Total Qty: " STRING(dTotQty, "->>>,>>>,>>9.99") SKIP.
OUTPUT STREAM sRpt CLOSE.

