/*------------------------------------------------------------------------
    File        : feedback_import.p
    Purpose     : Import Feedback from CSV with upsert
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

{customer-management/tt_feedback.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttFeedback.
    IMPORT DELIMITER "," ttFeedback.Contact ttFeedback.Company ttFeedback.EmailAddress ttFeedback.Phone ttFeedback.Fax ttFeedback.Comments ttFeedback.Department ttFeedback.Rating NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttFeedback.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttFeedback:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST Feedback EXCLUSIVE-LOCK WHERE Feedback.Department = ttFeedback.Department NO-ERROR.
        IF NOT AVAILABLE Feedback THEN CREATE Feedback.
        BUFFER-COPY ttFeedback EXCEPT RowState ErrorMsg TO Feedback.
        RUN customer-management/feedback_val.p (INPUT ROWID(Feedback), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

