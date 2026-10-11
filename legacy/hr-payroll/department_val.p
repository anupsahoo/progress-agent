/*------------------------------------------------------------------------
    File        : department_val.p
    Purpose     : Business validation for Department
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bDepartment FOR Department.

FIND bDepartment WHERE ROWID(bDepartment) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bDepartment THEN DO:
  ASSIGN plOk = NO pcMsg = "Department record not found.".
  RETURN.
END.

IF TRIM(bDepartment.DeptCode) = "" THEN RUN add-error ("Dept Code is required.").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

