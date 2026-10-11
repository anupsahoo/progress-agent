/*------------------------------------------------------------------------
    File        : salesrep_report.p
    Purpose     : Salesrep listing with control-break totals
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2017-06  mab  fix rounding
 *  2003-07  jkm  credit hold rule
 *  2004-08  tlw  Y2K date window
 *  2003-11  tlw  Y2K date window
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "Salesrep Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "salesrep_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH Salesrep NO-LOCK
    BREAK BY Salesrep.SalesRep:
    iCount = iCount + 1.
    IF FIRST-OF(Salesrep.SalesRep) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "Sales Rep: " Salesrep.SalesRep SKIP.
    DISPLAY STREAM sRpt Salesrep.SalesRep Salesrep.RepName Salesrep.Region
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
END.

PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
OUTPUT STREAM sRpt CLOSE.

