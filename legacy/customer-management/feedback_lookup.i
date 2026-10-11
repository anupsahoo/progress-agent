/*------------------------------------------------------------------------
    File        : feedback_lookup.i
    Purpose     : Feedback lookup helpers. {&NO-FEEDBACK-FUNCS} suppresses the functions.
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2015-11  mab  performance: use index
 *  1999-03  ssp  performance: use index
 *  2005-01  kpo  audit fields
 */

/* feedback_lookup.i : Feedback lookup helpers. {&NO-FEEDBACK-FUNCS} suppresses the functions. */

&IF DEFINED(FEEDBACK_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE FEEDBACK_LOOKUP_I YES

DEFINE BUFFER bLkFeedback FOR Feedback.

FUNCTION FeedbackExists RETURNS LOGICAL (INPUT pDepartment AS CHARACTER):
  RETURN CAN-FIND(FIRST bLkFeedback WHERE bLkFeedback.Department = pDepartment).
END FUNCTION.

FUNCTION FeedbackDesc RETURNS CHARACTER (INPUT pDepartment AS CHARACTER):
  FIND FIRST bLkFeedback NO-LOCK WHERE bLkFeedback.Department = pDepartment NO-ERROR.
  RETURN (IF AVAILABLE bLkFeedback THEN bLkFeedback.Contact ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-feedback :
  DEFINE INPUT  PARAMETER pDepartment AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkFeedback NO-LOCK WHERE bLkFeedback.Department = pDepartment NO-ERROR.
  pRowid = IF AVAILABLE bLkFeedback THEN ROWID(bLkFeedback) ELSE ?.
END PROCEDURE.

&ENDIF

