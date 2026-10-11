/*------------------------------------------------------------------------
    File        : EmployeeBE.cls
    Purpose     : business entity for Employee (OpenEdge 11 OO ABL)
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2014-04  ssp  performance: use index
 *  2011-08  tlw  add lock retry
 */

/* EmployeeBE.cls : business entity for Employee (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS HR.EmployeeBE:

  DEFINE PUBLIC PROPERTY EmpNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY LastName AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY FirstName AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Address AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Address2 AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY City AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY State AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY PostalCode AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY HomePhone AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY WorkPhone AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY DeptCode AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Position AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Birthdate AS DATE NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY StartDate AS DATE NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY VacationDaysLeft AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY SickDaysLeft AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC EmployeeBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pEmpNum AS INTEGER):
    FIND FIRST Employee NO-LOCK WHERE Employee.EmpNum = pEmpNum NO-ERROR.
    IF NOT AVAILABLE Employee THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:EmpNum = Employee.EmpNum
           THIS-OBJECT:LastName = Employee.LastName
           THIS-OBJECT:FirstName = Employee.FirstName
           THIS-OBJECT:Address = Employee.Address
           THIS-OBJECT:Address2 = Employee.Address2
           THIS-OBJECT:City = Employee.City
           THIS-OBJECT:State = Employee.State
           THIS-OBJECT:PostalCode = Employee.PostalCode
           THIS-OBJECT:HomePhone = Employee.HomePhone
           THIS-OBJECT:WorkPhone = Employee.WorkPhone
           THIS-OBJECT:DeptCode = Employee.DeptCode
           THIS-OBJECT:Position = Employee.Position
           THIS-OBJECT:Birthdate = Employee.Birthdate
           THIS-OBJECT:StartDate = Employee.StartDate
           THIS-OBJECT:VacationDaysLeft = Employee.VacationDaysLeft
           THIS-OBJECT:SickDaysLeft = Employee.SickDaysLeft
           rRow = ROWID(Employee) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:EmpNum = 0 THEN cErr = cErr + "Emp No is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE Employee.
      ELSE FIND Employee WHERE ROWID(Employee) = rRow EXCLUSIVE-LOCK.
      ASSIGN Employee.EmpNum = THIS-OBJECT:EmpNum
             Employee.LastName = THIS-OBJECT:LastName
             Employee.FirstName = THIS-OBJECT:FirstName
             Employee.Address = THIS-OBJECT:Address
             Employee.Address2 = THIS-OBJECT:Address2
             Employee.City = THIS-OBJECT:City
             Employee.State = THIS-OBJECT:State
             Employee.PostalCode = THIS-OBJECT:PostalCode
             Employee.HomePhone = THIS-OBJECT:HomePhone
             Employee.WorkPhone = THIS-OBJECT:WorkPhone
             Employee.DeptCode = THIS-OBJECT:DeptCode
             Employee.Position = THIS-OBJECT:Position
             Employee.Birthdate = THIS-OBJECT:Birthdate
             Employee.StartDate = THIS-OBJECT:StartDate
             Employee.VacationDaysLeft = THIS-OBJECT:VacationDaysLeft
             Employee.SickDaysLeft = THIS-OBJECT:SickDaysLeft.
      rRow = ROWID(Employee).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND Employee WHERE ROWID(Employee) = rRow EXCLUSIVE-LOCK.
      DELETE Employee.
    END.
  END METHOD.

END CLASS.

