/*------------------------------------------------------------------------
    File        : TimeSheetBE.cls
    Purpose     : business entity for TimeSheet (OpenEdge 11 OO ABL)
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-03  rdh  audit fields
 *  2002-06  tlw  new report column
 */

/* TimeSheetBE.cls : business entity for TimeSheet (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS HR.TimeSheetBE:

  DEFINE PUBLIC PROPERTY EmpNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY DayRecorded AS DATE NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY TypeRecorded AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY AMTimeIn AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY AMTimeOut AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY PMTimeIn AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY PMTimeOut AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY RegularHours AS DECIMAL NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY OvertimeHours AS DECIMAL NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC TimeSheetBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pEmpNum AS INTEGER, INPUT pDayRecorded AS DATE):
    FIND FIRST TimeSheet NO-LOCK WHERE TimeSheet.EmpNum = pEmpNum AND TimeSheet.DayRecorded = pDayRecorded NO-ERROR.
    IF NOT AVAILABLE TimeSheet THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:EmpNum = TimeSheet.EmpNum
           THIS-OBJECT:DayRecorded = TimeSheet.DayRecorded
           THIS-OBJECT:TypeRecorded = TimeSheet.TypeRecorded
           THIS-OBJECT:AMTimeIn = TimeSheet.AMTimeIn
           THIS-OBJECT:AMTimeOut = TimeSheet.AMTimeOut
           THIS-OBJECT:PMTimeIn = TimeSheet.PMTimeIn
           THIS-OBJECT:PMTimeOut = TimeSheet.PMTimeOut
           THIS-OBJECT:RegularHours = TimeSheet.RegularHours
           THIS-OBJECT:OvertimeHours = TimeSheet.OvertimeHours
           rRow = ROWID(TimeSheet) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:EmpNum = 0 THEN cErr = cErr + "Emp No is required.~n".
    IF THIS-OBJECT:DayRecorded = ? THEN cErr = cErr + "Day Recorded is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE TimeSheet.
      ELSE FIND TimeSheet WHERE ROWID(TimeSheet) = rRow EXCLUSIVE-LOCK.
      ASSIGN TimeSheet.EmpNum = THIS-OBJECT:EmpNum
             TimeSheet.DayRecorded = THIS-OBJECT:DayRecorded
             TimeSheet.TypeRecorded = THIS-OBJECT:TypeRecorded
             TimeSheet.AMTimeIn = THIS-OBJECT:AMTimeIn
             TimeSheet.AMTimeOut = THIS-OBJECT:AMTimeOut
             TimeSheet.PMTimeIn = THIS-OBJECT:PMTimeIn
             TimeSheet.PMTimeOut = THIS-OBJECT:PMTimeOut
             TimeSheet.RegularHours = THIS-OBJECT:RegularHours
             TimeSheet.OvertimeHours = THIS-OBJECT:OvertimeHours.
      rRow = ROWID(TimeSheet).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND TimeSheet WHERE ROWID(TimeSheet) = rRow EXCLUSIVE-LOCK.
      DELETE TimeSheet.
    END.
  END METHOD.

END CLASS.

