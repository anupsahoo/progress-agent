/*------------------------------------------------------------------------
    File        : employee_val.p
    Purpose     : Business validation for Employee
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bEmployee FOR Employee.

FIND bEmployee WHERE ROWID(bEmployee) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bEmployee THEN DO:
  ASSIGN plOk = NO pcMsg = "Employee record not found.".
  RETURN.
END.

/* DeptCode: CAN-FIND(department of employee) */
IF NOT CAN-FIND(FIRST Department WHERE Department.DeptCode = bEmployee.DeptCode) THEN
  RUN add-error ("Department must exist.").

IF bEmployee.Birthdate <> ? AND YEAR(bEmployee.Birthdate) < 1950 THEN
  RUN add-error ("Birthdate is before the 1950 date window.").

IF bEmployee.StartDate <> ? AND YEAR(bEmployee.StartDate) < 1950 THEN
  RUN add-error ("Start Date is before the 1950 date window.").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

