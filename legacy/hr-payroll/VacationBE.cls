/*------------------------------------------------------------------------
    File        : VacationBE.cls
    Purpose     : business entity for Vacation (OpenEdge 11 OO ABL)
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2001-01  jkm  add lock retry
 *  2016-08  tlw  remove dead code
 *  2003-03  tlw  fix rounding
 *  2010-04  kpo  new report column
 */

/* VacationBE.cls : business entity for Vacation (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS HR.VacationBE:

  DEFINE PUBLIC PROPERTY EmpNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY StartDate AS DATE NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY EndDate AS DATE NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC VacationBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pEmpNum AS INTEGER, INPUT pStartDate AS DATE):
    FIND FIRST Vacation NO-LOCK WHERE Vacation.EmpNum = pEmpNum AND Vacation.StartDate = pStartDate NO-ERROR.
    IF NOT AVAILABLE Vacation THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:EmpNum = Vacation.EmpNum
           THIS-OBJECT:StartDate = Vacation.StartDate
           THIS-OBJECT:EndDate = Vacation.EndDate
           rRow = ROWID(Vacation) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:EmpNum = 0 THEN cErr = cErr + "Emp No is required.~n".
    IF THIS-OBJECT:StartDate = ? THEN cErr = cErr + "Start Date is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE Vacation.
      ELSE FIND Vacation WHERE ROWID(Vacation) = rRow EXCLUSIVE-LOCK.
      ASSIGN Vacation.EmpNum = THIS-OBJECT:EmpNum
             Vacation.StartDate = THIS-OBJECT:StartDate
             Vacation.EndDate = THIS-OBJECT:EndDate.
      rRow = ROWID(Vacation).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND Vacation WHERE ROWID(Vacation) = rRow EXCLUSIVE-LOCK.
      DELETE Vacation.
    END.
  END METHOD.

END CLASS.

