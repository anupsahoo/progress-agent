/*------------------------------------------------------------------------
    File        : time_sheet_report.p
    Purpose     : TimeSheet listing with control-break totals
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2016-01  mab  audit fields
 *  2008-11  kpo  fix rounding
 *  2004-11  ssp  audit fields
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.
DEFINE VARIABLE dTotRegularHours AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotOvertimeHours AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "TimeSheet Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "time_sheet_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH TimeSheet NO-LOCK
    BREAK BY TimeSheet.TypeRecorded:
    iCount = iCount + 1.
    ACCUMULATE TimeSheet.RegularHours (TOTAL SUB-TOTAL BY TimeSheet.TypeRecorded).
    ACCUMULATE TimeSheet.OvertimeHours (TOTAL SUB-TOTAL BY TimeSheet.TypeRecorded).
    IF FIRST-OF(TimeSheet.TypeRecorded) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "Type Recorded: " TimeSheet.TypeRecorded SKIP.
    DISPLAY STREAM sRpt TimeSheet.EmpNum TimeSheet.DayRecorded TimeSheet.TypeRecorded TimeSheet.AMTimeIn TimeSheet.AMTimeOut TimeSheet.PMTimeIn TimeSheet.PMTimeOut
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
    IF LAST-OF(TimeSheet.TypeRecorded) THEN DO:
        PUT STREAM sRpt UNFORMATTED "  Subtotal Regular Hours: " STRING(ACCUM SUB-TOTAL BY TimeSheet.TypeRecorded TimeSheet.RegularHours, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Overtime Hours: " STRING(ACCUM SUB-TOTAL BY TimeSheet.TypeRecorded TimeSheet.OvertimeHours, "->>>,>>>,>>9.99") SKIP.
    END.
END.

dTotRegularHours = ACCUM TOTAL TimeSheet.RegularHours.
dTotOvertimeHours = ACCUM TOTAL TimeSheet.OvertimeHours.
PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
PUT STREAM sRpt UNFORMATTED "Total Regular Hours: " STRING(dTotRegularHours, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Overtime Hours: " STRING(dTotOvertimeHours, "->>>,>>>,>>9.99") SKIP.
OUTPUT STREAM sRpt CLOSE.

