/*------------------------------------------------------------------------
    File        : state_val.p
    Purpose     : Business validation for State
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bState FOR State.

FIND bState WHERE ROWID(bState) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bState THEN DO:
  ASSIGN plOk = NO pcMsg = "State record not found.".
  RETURN.
END.

IF TRIM(bState.State) = "" THEN RUN add-error ("State is required.").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

