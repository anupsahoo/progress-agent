/*------------------------------------------------------------------------
    File        : benefits_val.p
    Purpose     : Business validation for Benefits
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bBenefits FOR Benefits.

FIND bBenefits WHERE ROWID(bBenefits) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bBenefits THEN DO:
  ASSIGN plOk = NO pcMsg = "Benefits record not found.".
  RETURN.
END.

/* EmpNum: CAN-FIND(employee OF benefits) */
IF NOT CAN-FIND(FIRST Employee WHERE Employee.EmpNum = bBenefits.EmpNum) THEN
  RUN add-error ("Employee must exist.").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

