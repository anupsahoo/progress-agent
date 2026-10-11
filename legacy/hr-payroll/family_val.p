/*------------------------------------------------------------------------
    File        : family_val.p
    Purpose     : Business validation for Family
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bFamily FOR Family.

FIND bFamily WHERE ROWID(bFamily) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bFamily THEN DO:
  ASSIGN plOk = NO pcMsg = "Family record not found.".
  RETURN.
END.

/* EmpNum: CAN-FIND(employee OF family) */
IF NOT CAN-FIND(FIRST Employee WHERE Employee.EmpNum = bFamily.EmpNum) THEN
  RUN add-error ("Employee must exist.").

IF TRIM(bFamily.RelativeName) = "" THEN RUN add-error ("Relative Name is required.").

IF bFamily.Birthdate <> ? AND YEAR(bFamily.Birthdate) < 1950 THEN
  RUN add-error ("Birthdate is before the 1950 date window.").

IF bFamily.BenefitDate <> ? AND YEAR(bFamily.BenefitDate) < 1950 THEN
  RUN add-error ("Benefit Date is before the 1950 date window.").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

