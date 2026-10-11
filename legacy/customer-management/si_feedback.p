/*------------------------------------------------------------------------
    File        : si_feedback.p
    Purpose     : AppServer service interface for Feedback
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

{customer-management/tt_feedback.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsFeedback.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcFeedback FOR Feedback.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttFeedback:ATTACH-DATA-SOURCE(DATA-SOURCE srcFeedback:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcFeedback:FILL-WHERE-STRING = pcWhere.
    DATASET dsFeedback:FILL().
    BUFFER ttFeedback:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttFeedback:ATTACH-DATA-SOURCE(DATA-SOURCE srcFeedback:HANDLE).
    FOR EACH btFeedback:
      BUFFER btFeedback:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btFeedback:ERROR THEN pcError = pcError + BUFFER btFeedback:ERROR-STRING + "~n".
    END.
    BUFFER ttFeedback:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttFeedback:
      FIND FIRST Feedback EXCLUSIVE-LOCK WHERE Feedback.Department = ttFeedback.Department NO-WAIT NO-ERROR.
      IF LOCKED Feedback THEN DO:
        pcError = pcError + "Feedback is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE Feedback THEN DELETE Feedback.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER Feedback:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH Feedback NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_feedback " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

