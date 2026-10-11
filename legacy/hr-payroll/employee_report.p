/*------------------------------------------------------------------------
    File        : employee_report.p
    Purpose     : Employee listing with control-break totals
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2009-06  tlw  performance: use index
 *  2001-08  kpo  new report column
 *  2005-03  ssp  remove dead code
 *  2001-05  tlw  Y2K date window
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.
DEFINE VARIABLE dTotVacationDaysLeft AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE dTotSickDaysLeft AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "Employee Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "employee_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH Employee NO-LOCK
    BREAK BY Employee.City:
    iCount = iCount + 1.
    ACCUMULATE Employee.VacationDaysLeft (TOTAL SUB-TOTAL BY Employee.City).
    ACCUMULATE Employee.SickDaysLeft (TOTAL SUB-TOTAL BY Employee.City).
    IF FIRST-OF(Employee.City) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "City: " Employee.City SKIP.
    DISPLAY STREAM sRpt Employee.EmpNum Employee.LastName Employee.FirstName Employee.Address Employee.Address2 Employee.City Employee.State
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
    IF LAST-OF(Employee.City) THEN DO:
        PUT STREAM sRpt UNFORMATTED "  Subtotal Vacation Days Left: " STRING(ACCUM SUB-TOTAL BY Employee.City Employee.VacationDaysLeft, "->>>,>>>,>>9.99") SKIP.
        PUT STREAM sRpt UNFORMATTED "  Subtotal Sick Days Left: " STRING(ACCUM SUB-TOTAL BY Employee.City Employee.SickDaysLeft, "->>>,>>>,>>9.99") SKIP.
    END.
END.

dTotVacationDaysLeft = ACCUM TOTAL Employee.VacationDaysLeft.
dTotSickDaysLeft = ACCUM TOTAL Employee.SickDaysLeft.
PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
PUT STREAM sRpt UNFORMATTED "Total Vacation Days Left: " STRING(dTotVacationDaysLeft, "->>>,>>>,>>9.99") SKIP.
PUT STREAM sRpt UNFORMATTED "Total Sick Days Left: " STRING(dTotSickDaysLeft, "->>>,>>>,>>9.99") SKIP.
OUTPUT STREAM sRpt CLOSE.

