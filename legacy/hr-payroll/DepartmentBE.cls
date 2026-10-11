/*------------------------------------------------------------------------
    File        : DepartmentBE.cls
    Purpose     : business entity for Department (OpenEdge 11 OO ABL)
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2003-11  ssp  Y2K date window
 *  2006-04  mab  fix rounding
 *  2009-05  ssp  appserver split
 */

/* DepartmentBE.cls : business entity for Department (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS HR.DepartmentBE:

  DEFINE PUBLIC PROPERTY DeptCode AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY DeptName AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC DepartmentBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pDeptCode AS CHARACTER):
    FIND FIRST Department NO-LOCK WHERE Department.DeptCode = pDeptCode NO-ERROR.
    IF NOT AVAILABLE Department THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:DeptCode = Department.DeptCode
           THIS-OBJECT:DeptName = Department.DeptName
           rRow = ROWID(Department) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:DeptCode = "" THEN cErr = cErr + "Dept Code is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE Department.
      ELSE FIND Department WHERE ROWID(Department) = rRow EXCLUSIVE-LOCK.
      ASSIGN Department.DeptCode = THIS-OBJECT:DeptCode
             Department.DeptName = THIS-OBJECT:DeptName.
      rRow = ROWID(Department).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND Department WHERE ROWID(Department) = rRow EXCLUSIVE-LOCK.
      DELETE Department.
    END.
  END METHOD.

END CLASS.

