/*------------------------------------------------------------------------
    File        : local_default_report.p
    Purpose     : LocalDefault listing with control-break totals
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-02  tlw  remove dead code
 *  2015-12  mab  Y2K date window
 *  2005-12  mab  performance: use index
 *  2016-12  mab  audit fields
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "LocalDefault Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "local_default_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH LocalDefault NO-LOCK
    BREAK BY LocalDefault.Country:
    iCount = iCount + 1.
    IF FIRST-OF(LocalDefault.Country) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "Country: " LocalDefault.Country SKIP.
    DISPLAY STREAM sRpt LocalDefault.Country LocalDefault.Region1Label LocalDefault.Region2Label LocalDefault.PostalLabel LocalDefault.PostalFormat LocalDefault.TelFormat LocalDefault.CurrencySymbol
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
END.

PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
OUTPUT STREAM sRpt CLOSE.

