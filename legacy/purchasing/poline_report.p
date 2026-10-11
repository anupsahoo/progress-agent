/*------------------------------------------------------------------------
    File        : poline_report.p
    Purpose     : POLine listing with control-break totals
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-03  rdh  add lock retry
 *  2013-05  jkm  appserver split
 *  2010-09  tlw  performance: use index
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.
DEFINE VARIABLE dTotPrice AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotQty AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotDiscount AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotExtendedPrice AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "POLine Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "poline_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH POLine NO-LOCK
    BREAK BY POLine.POLineStatus:
    iCount = iCount + 1.
    ACCUMULATE POLine.Price (TOTAL SUB-TOTAL BY POLine.POLineStatus).
    ACCUMULATE POLine.Qty (TOTAL SUB-TOTAL BY POLine.POLineStatus).
    ACCUMULATE POLine.Discount (TOTAL SUB-TOTAL BY POLine.POLineStatus).
    ACCUMULATE POLine.ExtendedPrice (TOTAL SUB-TOTAL BY POLine.POLineStatus).
    IF FIRST-OF(POLine.POLineStatus) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "PO Line Status: " POLine.POLineStatus SKIP.
    DISPLAY STREAM sRpt POLine.Linenum POLine.Itemnum POLine.Price POLine.Qty POLine.Discount POLine.ExtendedPrice POLine.PONum
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
    IF LAST-OF(POLine.POLineStatus) THEN DO:
        PUT STREAM sRpt UNFORMATTED "  Subtotal Price: " STRING(ACCUM SUB-TOTAL BY POLine.POLineStatus POLine.Price, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Qty: " STRING(ACCUM SUB-TOTAL BY POLine.POLineStatus POLine.Qty, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Discount: " STRING(ACCUM SUB-TOTAL BY POLine.POLineStatus POLine.Discount, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Extended Price: " STRING(ACCUM SUB-TOTAL BY POLine.POLineStatus POLine.ExtendedPrice, "->>>,>>>,>>9.99") SKIP.
    END.
END.

dTotPrice = ACCUM TOTAL POLine.Price.
dTotQty = ACCUM TOTAL POLine.Qty.
dTotDiscount = ACCUM TOTAL POLine.Discount.
dTotExtendedPrice = ACCUM TOTAL POLine.ExtendedPrice.
PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
PUT STREAM sRpt UNFORMATTED "Total Price: " STRING(dTotPrice, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Qty: " STRING(dTotQty, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Discount: " STRING(dTotDiscount, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Extended Price: " STRING(dTotExtendedPrice, "->>>,>>>,>>9.99") SKIP.
OUTPUT STREAM sRpt CLOSE.

