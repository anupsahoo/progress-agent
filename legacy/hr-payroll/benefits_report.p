/*------------------------------------------------------------------------
    File        : benefits_report.p
    Purpose     : Benefits listing with control-break totals
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-11  ssp  new report column
 *  2015-10  tlw  audit fields
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.
DEFINE VARIABLE dTotLifeInsurance AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotPension401K AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotStockPurchase AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotMedicalSpending AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotDependentCare AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "Benefits Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "benefits_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH Benefits NO-LOCK
    BREAK BY Benefits.HealthCare:
    iCount = iCount + 1.
    ACCUMULATE Benefits.LifeInsurance (TOTAL SUB-TOTAL BY Benefits.HealthCare).
    ACCUMULATE Benefits.Pension401K (TOTAL SUB-TOTAL BY Benefits.HealthCare).
    ACCUMULATE Benefits.StockPurchase (TOTAL SUB-TOTAL BY Benefits.HealthCare).
    ACCUMULATE Benefits.MedicalSpending (TOTAL SUB-TOTAL BY Benefits.HealthCare).
    ACCUMULATE Benefits.DependentCare (TOTAL SUB-TOTAL BY Benefits.HealthCare).
    IF FIRST-OF(Benefits.HealthCare) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "Health Care: " Benefits.HealthCare SKIP.
    DISPLAY STREAM sRpt Benefits.EmpNum Benefits.HealthCare Benefits.LifeInsurance Benefits.Pension401K Benefits.StockPurchase Benefits.MedicalSpending Benefits.DependentCare
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
    IF LAST-OF(Benefits.HealthCare) THEN DO:
        PUT STREAM sRpt UNFORMATTED "  Subtotal Life Insurance: " STRING(ACCUM SUB-TOTAL BY Benefits.HealthCare Benefits.LifeInsurance, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Pension401K: " STRING(ACCUM SUB-TOTAL BY Benefits.HealthCare Benefits.Pension401K, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Stock Purchase: " STRING(ACCUM SUB-TOTAL BY Benefits.HealthCare Benefits.StockPurchase, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Medical Spending: " STRING(ACCUM SUB-TOTAL BY Benefits.HealthCare Benefits.MedicalSpending, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Dependent Care: " STRING(ACCUM SUB-TOTAL BY Benefits.HealthCare Benefits.DependentCare, "->>>,>>>,>>9.99") SKIP.
    END.
END.

dTotLifeInsurance = ACCUM TOTAL Benefits.LifeInsurance.
dTotPension401K = ACCUM TOTAL Benefits.Pension401K.
dTotStockPurchase = ACCUM TOTAL Benefits.StockPurchase.
dTotMedicalSpending = ACCUM TOTAL Benefits.MedicalSpending.
dTotDependentCare = ACCUM TOTAL Benefits.DependentCare.
PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
PUT STREAM sRpt UNFORMATTED "Total Life Insurance: " STRING(dTotLifeInsurance, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Pension401K: " STRING(dTotPension401K, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Stock Purchase: " STRING(dTotStockPurchase, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Medical Spending: " STRING(dTotMedicalSpending, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Dependent Care: " STRING(dTotDependentCare, "->>>,>>>,>>9.99") SKIP.
OUTPUT STREAM sRpt CLOSE.

