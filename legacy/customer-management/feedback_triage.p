/*------------------------------------------------------------------------
    File        : feedback_triage.p
    Purpose     : Route customer feedback to the owning department
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2011-08  jkm  new report column
 *  2002-10  ssp  add lock retry
 *  2008-03  kpo  performance: use index
 *  2003-07  kpo  credit hold rule
 *  2010-03  ssp  new report column
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{shared/lockretry.i}
{customer-management/cm_defs.i}

DEFINE INPUT PARAMETER pDepartment AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcResult AS CHARACTER NO-UNDO.

DEFINE BUFFER bFeedback FOR Feedback.
DEFINE VARIABLE iTouched AS INTEGER NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE ttWork NO-UNDO
    FIELD SrcRow AS ROWID
    FIELD Action AS CHARACTER
    FIELD Note   AS CHARACTER
    INDEX ixRow IS PRIMARY SrcRow.

MAIN-TX:
DO TRANSACTION ON ERROR UNDO MAIN-TX, LEAVE MAIN-TX:
    FIND FIRST bFeedback EXCLUSIVE-LOCK WHERE bFeedback.Department = pDepartment NO-WAIT NO-ERROR.
    IF LOCKED bFeedback THEN DO:
        pcResult = "LOCKED: Feedback in use".
        UNDO MAIN-TX, LEAVE MAIN-TX.
    END.
    IF NOT AVAILABLE bFeedback THEN DO:
        pcResult = "NOT-FOUND".
        LEAVE MAIN-TX.
    END.

    /* Never leave a negative Rating behind */
    ASSIGN bFeedback.Rating = MAX(0, bFeedback.Rating).
    RUN shared/audit_log.p (INPUT "Feedback", INPUT STRING(ROWID(bFeedback)), INPUT "feedback_triage.p").
    pcResult = "OK:" + STRING(iTouched).
END. /* MAIN-TX */

FOR EACH ttWork:
    RUN shared/log_msg.p (INPUT "INFO", INPUT ttWork.Action + " " + STRING(ttWork.SrcRow) + " " + ttWork.Note).
END.

PROCEDURE round-feedback-rating0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-feedback-rating1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-feedback-rating2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-feedback-rating3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-feedback-rating4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE apply-feedback-rating5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE calc-feedback-rating6 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-feedback-rating7 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-feedback-rating8 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-feedback-rating9 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE derive-feedback-rating10 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-feedback-rating11 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE derive-feedback-rating12 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE derive-feedback-rating13 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-feedback-rating14 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-feedback-rating15 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-feedback-rating16 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE calc-feedback-rating17 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE apply-feedback-rating18 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-feedback-rating19 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE calc-feedback-rating20 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-feedback-rating21 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFeedback FOR Feedback.
  FIND bFeedback WHERE ROWID(bFeedback) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFeedback THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bFeedback.Rating < 0 THEN plOk = NO.
    WHEN bFeedback.Rating > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Feedback.Rating above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

