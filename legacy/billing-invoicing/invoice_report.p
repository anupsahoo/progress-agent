/*------------------------------------------------------------------------
    File        : invoice_report.p
    Purpose     : Invoice listing with control-break totals
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2015-07  jkm  add lock retry
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.
DEFINE VARIABLE dTotAmount AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotTotalPaid AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotAdjustment AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotShipCharge AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "Invoice Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "invoice_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH Invoice NO-LOCK
    :
    iCount = iCount + 1.
    ACCUMULATE Invoice.Amount (TOTAL).
    ACCUMULATE Invoice.TotalPaid (TOTAL).
    ACCUMULATE Invoice.Adjustment (TOTAL).
    ACCUMULATE Invoice.ShipCharge (TOTAL).
    DISPLAY STREAM sRpt Invoice.Invoicenum Invoice.CustNum Invoice.InvoiceDate Invoice.Amount Invoice.TotalPaid Invoice.Adjustment Invoice.OrderNum
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
END.

dTotAmount = ACCUM TOTAL Invoice.Amount.
dTotTotalPaid = ACCUM TOTAL Invoice.TotalPaid.
dTotAdjustment = ACCUM TOTAL Invoice.Adjustment.
dTotShipCharge = ACCUM TOTAL Invoice.ShipCharge.
PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
PUT STREAM sRpt UNFORMATTED "Total Amount: " STRING(dTotAmount, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Total Paid: " STRING(dTotTotalPaid, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Adjustment: " STRING(dTotAdjustment, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Ship Charge: " STRING(dTotShipCharge, "->>>,>>>,>>9.99") SKIP.
OUTPUT STREAM sRpt CLOSE.

