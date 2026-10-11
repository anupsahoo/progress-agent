/*------------------------------------------------------------------------
    File        : order_line_report.p
    Purpose     : OrderLine listing with control-break totals
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2003-01  kpo  credit hold rule
 *  1999-08  jkm  audit fields
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
    "OrderLine Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "order_line_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH OrderLine NO-LOCK
    BREAK BY OrderLine.OrderLineStatus:
    iCount = iCount + 1.
    ACCUMULATE OrderLine.Price (TOTAL SUB-TOTAL BY OrderLine.OrderLineStatus).
    ACCUMULATE OrderLine.Qty (TOTAL SUB-TOTAL BY OrderLine.OrderLineStatus).
    ACCUMULATE OrderLine.Discount (TOTAL SUB-TOTAL BY OrderLine.OrderLineStatus).
    ACCUMULATE OrderLine.ExtendedPrice (TOTAL SUB-TOTAL BY OrderLine.OrderLineStatus).
    IF FIRST-OF(OrderLine.OrderLineStatus) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "Order Line Status: " OrderLine.OrderLineStatus SKIP.
    DISPLAY STREAM sRpt OrderLine.Ordernum OrderLine.Linenum OrderLine.Itemnum OrderLine.Price OrderLine.Qty OrderLine.Discount OrderLine.ExtendedPrice
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
    IF LAST-OF(OrderLine.OrderLineStatus) THEN DO:
        PUT STREAM sRpt UNFORMATTED "  Subtotal Price: " STRING(ACCUM SUB-TOTAL BY OrderLine.OrderLineStatus OrderLine.Price, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Qty: " STRING(ACCUM SUB-TOTAL BY OrderLine.OrderLineStatus OrderLine.Qty, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Discount: " STRING(ACCUM SUB-TOTAL BY OrderLine.OrderLineStatus OrderLine.Discount, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Extended Price: " STRING(ACCUM SUB-TOTAL BY OrderLine.OrderLineStatus OrderLine.ExtendedPrice, "->>>,>>>,>>9.99") SKIP.
    END.
END.

dTotPrice = ACCUM TOTAL OrderLine.Price.
dTotQty = ACCUM TOTAL OrderLine.Qty.
dTotDiscount = ACCUM TOTAL OrderLine.Discount.
dTotExtendedPrice = ACCUM TOTAL OrderLine.ExtendedPrice.
PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
PUT STREAM sRpt UNFORMATTED "Total Price: " STRING(dTotPrice, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Qty: " STRING(dTotQty, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Discount: " STRING(dTotDiscount, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Extended Price: " STRING(dTotExtendedPrice, "->>>,>>>,>>9.99") SKIP.
OUTPUT STREAM sRpt CLOSE.

