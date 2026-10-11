/*------------------------------------------------------------------------
    File        : vacation_val.p
    Purpose     : Business validation for Vacation
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bVacation FOR Vacation.

FIND bVacation WHERE ROWID(bVacation) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bVacation THEN DO:
  ASSIGN plOk = NO pcMsg = "Vacation record not found.".
  RETURN.
END.

IF bVacation.StartDate <> ? AND YEAR(bVacation.StartDate) < 1950 THEN
  RUN add-error ("Start Date is before the 1950 date window.").

IF bVacation.EndDate <> ? AND YEAR(bVacation.EndDate) < 1950 THEN
  RUN add-error ("End Date is before the 1950 date window.").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

