/*------------------------------------------------------------------------
    File        : write_feedback.p
    Purpose     : schema WRITE trigger for Feedback, field-level audit
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2003-09  jkm  new report column
 *  2002-01  kpo  appserver split
 */

/* trg/write_feedback.p : schema WRITE trigger for Feedback, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF Feedback OLD BUFFER oldFeedback.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN customer-management/feedback_val.p (INPUT ROWID(Feedback), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "Feedback write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF Feedback.Contact <> oldFeedback.Contact THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Feedback.Contact", INPUT STRING(oldFeedback.Contact), INPUT STRING(Feedback.Contact)).
END.
IF Feedback.Company <> oldFeedback.Company THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Feedback.Company", INPUT STRING(oldFeedback.Company), INPUT STRING(Feedback.Company)).
END.
IF Feedback.EmailAddress <> oldFeedback.EmailAddress THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Feedback.EmailAddress", INPUT STRING(oldFeedback.EmailAddress), INPUT STRING(Feedback.EmailAddress)).
END.
IF Feedback.Phone <> oldFeedback.Phone THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Feedback.Phone", INPUT STRING(oldFeedback.Phone), INPUT STRING(Feedback.Phone)).
END.
IF Feedback.Fax <> oldFeedback.Fax THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Feedback.Fax", INPUT STRING(oldFeedback.Fax), INPUT STRING(Feedback.Fax)).
END.
IF Feedback.Comments <> oldFeedback.Comments THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Feedback.Comments", INPUT STRING(oldFeedback.Comments), INPUT STRING(Feedback.Comments)).
END.
IF Feedback.Department <> oldFeedback.Department THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Feedback.Department", INPUT STRING(oldFeedback.Department), INPUT STRING(Feedback.Department)).
END.
IF Feedback.Rating <> oldFeedback.Rating THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Feedback.Rating", INPUT STRING(oldFeedback.Rating), INPUT STRING(Feedback.Rating)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/feedback.q") APPEND.
  EXPORT "Feedback" "W" STRING(NOW) Feedback.Department.
  OUTPUT CLOSE.
END.

