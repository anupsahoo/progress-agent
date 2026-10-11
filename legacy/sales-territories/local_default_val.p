/*------------------------------------------------------------------------
    File        : local_default_val.p
    Purpose     : Business validation for LocalDefault
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bLocalDefault FOR LocalDefault.

FIND bLocalDefault WHERE ROWID(bLocalDefault) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bLocalDefault THEN DO:
  ASSIGN plOk = NO pcMsg = "LocalDefault record not found.".
  RETURN.
END.

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

