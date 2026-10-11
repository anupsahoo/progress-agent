/*------------------------------------------------------------------------
    File        : delete_feedback.p
    Purpose     : schema DELETE trigger for Feedback, referential integrity
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2006-12  tlw  add lock retry
 */

/* trg/delete_feedback.p : schema DELETE trigger for Feedback, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF Feedback.

{shared/sysdefs.i}

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/feedback_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT Feedback.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of Feedback by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/feedback.q") APPEND.
EXPORT "Feedback" "D" STRING(NOW) Feedback.Department.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "Feedback", INPUT STRING(ROWID(Feedback)), INPUT "DELETE").

