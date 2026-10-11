/*------------------------------------------------------------------------
    File        : feedback_val.p
    Purpose     : Business validation for Feedback
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bFeedback FOR Feedback.

FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bFeedback THEN DO:
  ASSIGN plOk = NO pcMsg = "Feedback record not found.".
  RETURN.
END.

IF bFeedback.EmailAddress > "" AND INDEX(bFeedback.EmailAddress, "@") = 0 THEN
  RUN add-error ("Email must be a valid e-mail address.").

IF TRIM(bFeedback.Department) = "" THEN RUN add-error ("Department is required.").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

