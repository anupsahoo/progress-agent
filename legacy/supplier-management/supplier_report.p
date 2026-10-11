/*------------------------------------------------------------------------
    File        : supplier_report.p
    Purpose     : Supplier listing with control-break totals
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2017-11  kpo  Y2K date window
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.
DEFINE VARIABLE dTotShipAmount AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotDiscount AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "Supplier Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "supplier_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH Supplier NO-LOCK
    BREAK BY Supplier.City:
    iCount = iCount + 1.
    ACCUMULATE Supplier.ShipAmount (TOTAL SUB-TOTAL BY Supplier.City).
    ACCUMULATE Supplier.Discount (TOTAL SUB-TOTAL BY Supplier.City).
    IF FIRST-OF(Supplier.City) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "City: " Supplier.City SKIP.
    DISPLAY STREAM sRpt Supplier.SupplierIDNum Supplier.Name Supplier.Address Supplier.Address2 Supplier.City Supplier.State Supplier.PostalCode
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
    IF LAST-OF(Supplier.City) THEN DO:
        PUT STREAM sRpt UNFORMATTED "  Subtotal Ship Amount: " STRING(ACCUM SUB-TOTAL BY Supplier.City Supplier.ShipAmount, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Discount: " STRING(ACCUM SUB-TOTAL BY Supplier.City Supplier.Discount, "->>>,>>>,>>9.99") SKIP.
    END.
END.

dTotShipAmount = ACCUM TOTAL Supplier.ShipAmount.
dTotDiscount = ACCUM TOTAL Supplier.Discount.
PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
PUT STREAM sRpt UNFORMATTED "Total Ship Amount: " STRING(dTotShipAmount, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Discount: " STRING(dTotDiscount, "->>>,>>>,>>9.99") SKIP.
OUTPUT STREAM sRpt CLOSE.

