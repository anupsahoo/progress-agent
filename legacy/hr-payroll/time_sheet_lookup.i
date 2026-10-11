/*------------------------------------------------------------------------
    File        : time_sheet_lookup.i
    Purpose     : TimeSheet lookup helpers. {&NO-TIMESHEET-FUNCS} suppresses the functions.
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-02  ssp  credit hold rule
 *  2004-12  kpo  fix rounding
 */

/* time_sheet_lookup.i : TimeSheet lookup helpers. {&NO-TIMESHEET-FUNCS} suppresses the functions. */

&IF DEFINED(TIME_SHEET_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE TIME_SHEET_LOOKUP_I YES

DEFINE BUFFER bLkTimeSheet FOR TimeSheet.

FUNCTION TimeSheetExists RETURNS LOGICAL (INPUT pEmpNum AS INTEGER, INPUT pDayRecorded AS DATE):
  RETURN CAN-FIND(FIRST bLkTimeSheet WHERE bLkTimeSheet.EmpNum = pEmpNum AND bLkTimeSheet.DayRecorded = pDayRecorded).
END FUNCTION.

FUNCTION TimeSheetDesc RETURNS CHARACTER (INPUT pEmpNum AS INTEGER, INPUT pDayRecorded AS DATE):
  FIND FIRST bLkTimeSheet NO-LOCK WHERE bLkTimeSheet.EmpNum = pEmpNum AND bLkTimeSheet.DayRecorded = pDayRecorded NO-ERROR.
  RETURN (IF AVAILABLE bLkTimeSheet THEN bLkTimeSheet.TypeRecorded ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-time_sheet :
  DEFINE INPUT  PARAMETER pEmpNum AS INTEGER NO-UNDO.
  DEFINE INPUT  PARAMETER pDayRecorded AS DATE NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkTimeSheet NO-LOCK WHERE bLkTimeSheet.EmpNum = pEmpNum AND bLkTimeSheet.DayRecorded = pDayRecorded NO-ERROR.
  pRowid = IF AVAILABLE bLkTimeSheet THEN ROWID(bLkTimeSheet) ELSE ?.
END PROCEDURE.

&ENDIF

