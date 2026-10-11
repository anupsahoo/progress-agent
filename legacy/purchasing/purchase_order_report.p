/*------------------------------------------------------------------------
    File        : purchase_order_report.p
    Purpose     : PurchaseOrder listing with control-break totals
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-02  tlw  audit fields
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "PurchaseOrder Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "purchase_order_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH PurchaseOrder NO-LOCK
    BREAK BY PurchaseOrder.POStatus:
    iCount = iCount + 1.
    IF FIRST-OF(PurchaseOrder.POStatus) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "PO Status: " PurchaseOrder.POStatus SKIP.
    DISPLAY STREAM sRpt PurchaseOrder.PONum PurchaseOrder.DateEntered PurchaseOrder.SupplierIDNum PurchaseOrder.ReceiveDate PurchaseOrder.POStatus
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
END.

PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
OUTPUT STREAM sRpt CLOSE.

