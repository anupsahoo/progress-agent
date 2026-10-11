/*------------------------------------------------------------------------
    File        : item_report.p
    Purpose     : Item listing with control-break totals
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2002-12  rdh  credit hold rule
 *  2005-08  ssp  add lock retry
 *  2001-04  kpo  remove dead code
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.
DEFINE VARIABLE dTotPrice AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotOnhand AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotAllocated AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotReOrder AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotOnOrder AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotCatPage AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotWeight AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotMinqty AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "Item Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "item_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH Item NO-LOCK
    BREAK BY Item.Category1:
    iCount = iCount + 1.
    ACCUMULATE Item.Price (TOTAL SUB-TOTAL BY Item.Category1).
    ACCUMULATE Item.Onhand (TOTAL SUB-TOTAL BY Item.Category1).
    ACCUMULATE Item.Allocated (TOTAL SUB-TOTAL BY Item.Category1).
    ACCUMULATE Item.ReOrder (TOTAL SUB-TOTAL BY Item.Category1).
    ACCUMULATE Item.OnOrder (TOTAL SUB-TOTAL BY Item.Category1).
    ACCUMULATE Item.CatPage (TOTAL SUB-TOTAL BY Item.Category1).
    ACCUMULATE Item.Weight (TOTAL SUB-TOTAL BY Item.Category1).
    ACCUMULATE Item.Minqty (TOTAL SUB-TOTAL BY Item.Category1).
    IF FIRST-OF(Item.Category1) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "Category1: " Item.Category1 SKIP.
    DISPLAY STREAM sRpt Item.Itemnum Item.ItemName Item.Price Item.Onhand Item.Allocated Item.ReOrder Item.OnOrder
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
    IF LAST-OF(Item.Category1) THEN DO:
        PUT STREAM sRpt UNFORMATTED "  Subtotal Price: " STRING(ACCUM SUB-TOTAL BY Item.Category1 Item.Price, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal On Hand: " STRING(ACCUM SUB-TOTAL BY Item.Category1 Item.Onhand, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Allocated: " STRING(ACCUM SUB-TOTAL BY Item.Category1 Item.Allocated, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Re Order: " STRING(ACCUM SUB-TOTAL BY Item.Category1 Item.ReOrder, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal On Order: " STRING(ACCUM SUB-TOTAL BY Item.Category1 Item.OnOrder, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Cat Page: " STRING(ACCUM SUB-TOTAL BY Item.Category1 Item.CatPage, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Weight: " STRING(ACCUM SUB-TOTAL BY Item.Category1 Item.Weight, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Min Qty: " STRING(ACCUM SUB-TOTAL BY Item.Category1 Item.Minqty, "->>>,>>>,>>9.99") SKIP.
    END.
END.

dTotPrice = ACCUM TOTAL Item.Price.
dTotOnhand = ACCUM TOTAL Item.Onhand.
dTotAllocated = ACCUM TOTAL Item.Allocated.
dTotReOrder = ACCUM TOTAL Item.ReOrder.
dTotOnOrder = ACCUM TOTAL Item.OnOrder.
dTotCatPage = ACCUM TOTAL Item.CatPage.
dTotWeight = ACCUM TOTAL Item.Weight.
dTotMinqty = ACCUM TOTAL Item.Minqty.
PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
PUT STREAM sRpt UNFORMATTED "Total Price: " STRING(dTotPrice, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total On Hand: " STRING(dTotOnhand, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Allocated: " STRING(dTotAllocated, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Re Order: " STRING(dTotReOrder, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total On Order: " STRING(dTotOnOrder, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Cat Page: " STRING(dTotCatPage, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Weight: " STRING(dTotWeight, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Min Qty: " STRING(dTotMinqty, "->>>,>>>,>>9.99") SKIP.
OUTPUT STREAM sRpt CLOSE.

