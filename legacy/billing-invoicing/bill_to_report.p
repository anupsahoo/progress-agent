/*------------------------------------------------------------------------
    File        : bill_to_report.p
    Purpose     : BillTo listing with control-break totals
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2004-09  kpo  credit hold rule
 *  2002-01  jkm  audit fields
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "BillTo Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "bill_to_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH BillTo NO-LOCK
    BREAK BY BillTo.City:
    iCount = iCount + 1.
    IF FIRST-OF(BillTo.City) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "City: " BillTo.City SKIP.
    DISPLAY STREAM sRpt BillTo.CustNum BillTo.BillToID BillTo.Name BillTo.Address BillTo.Address2 BillTo.City BillTo.State
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
END.

PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
OUTPUT STREAM sRpt CLOSE.

