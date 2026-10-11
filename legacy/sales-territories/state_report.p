/*------------------------------------------------------------------------
    File        : state_report.p
    Purpose     : State listing with control-break totals
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2016-09  rdh  remove dead code
 *  2009-08  rdh  new report column
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "State Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "state_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH State NO-LOCK
    BREAK BY State.State:
    iCount = iCount + 1.
    IF FIRST-OF(State.State) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "State: " State.State SKIP.
    DISPLAY STREAM sRpt State.State State.StateName State.Region
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
END.

PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
OUTPUT STREAM sRpt CLOSE.

