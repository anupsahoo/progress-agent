/*------------------------------------------------------------------------
    File        : order_report.p
    Purpose     : Order listing with control-break totals
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2001-07  rdh  new report column
 *  2014-12  rdh  appserver split
 *  2003-07  ssp  appserver split
 *  2006-10  ssp  Y2K date window
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "Order Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "order_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH Order NO-LOCK
    BREAK BY Order.SalesRep:
    iCount = iCount + 1.
    IF FIRST-OF(Order.SalesRep) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "Sales Rep: " Order.SalesRep SKIP.
    DISPLAY STREAM sRpt Order.Ordernum Order.CustNum Order.OrderDate Order.ShipDate Order.PromiseDate Order.Carrier Order.Instructions
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
END.

PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
OUTPUT STREAM sRpt CLOSE.

