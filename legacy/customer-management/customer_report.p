/*------------------------------------------------------------------------
    File        : customer_report.p
    Purpose     : Customer listing with control-break totals
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-12  rdh  remove dead code
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.
DEFINE VARIABLE dTotCreditLimit AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotBalance AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotDiscount AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "Customer Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "customer_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH Customer NO-LOCK
    BREAK BY Customer.Country:
    iCount = iCount + 1.
    ACCUMULATE Customer.CreditLimit (TOTAL SUB-TOTAL BY Customer.Country).
    ACCUMULATE Customer.Balance (TOTAL SUB-TOTAL BY Customer.Country).
    ACCUMULATE Customer.Discount (TOTAL SUB-TOTAL BY Customer.Country).
    IF FIRST-OF(Customer.Country) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "Country: " Customer.Country SKIP.
    DISPLAY STREAM sRpt Customer.CustNum Customer.Country Customer.Name Customer.Address Customer.Address2 Customer.City Customer.State
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
    IF LAST-OF(Customer.Country) THEN DO:
        PUT STREAM sRpt UNFORMATTED "  Subtotal Credit Limit: " STRING(ACCUM SUB-TOTAL BY Customer.Country Customer.CreditLimit, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Balance: " STRING(ACCUM SUB-TOTAL BY Customer.Country Customer.Balance, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Discount: " STRING(ACCUM SUB-TOTAL BY Customer.Country Customer.Discount, "->>>,>>>,>>9.99") SKIP.
    END.
END.

dTotCreditLimit = ACCUM TOTAL Customer.CreditLimit.
dTotBalance = ACCUM TOTAL Customer.Balance.
dTotDiscount = ACCUM TOTAL Customer.Discount.
PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
PUT STREAM sRpt UNFORMATTED "Total Credit Limit: " STRING(dTotCreditLimit, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Balance: " STRING(dTotBalance, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Discount: " STRING(dTotDiscount, "->>>,>>>,>>9.99") SKIP.
OUTPUT STREAM sRpt CLOSE.

