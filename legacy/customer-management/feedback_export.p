/*------------------------------------------------------------------------
    File        : feedback_export.p
    Purpose     : Export Feedback to CSV
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-02  mab  credit hold rule
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "feedback_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Contact Name,Company,Email,Phone,Fax,Comments,Department,Rating" SKIP.
FOR EACH Feedback NO-LOCK
    BY Feedback.Department:
    EXPORT DELIMITER "," Feedback.Contact Feedback.Company Feedback.EmailAddress Feedback.Phone Feedback.Fax Feedback.Comments Feedback.Department Feedback.Rating.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=Feedback" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "Feedback export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

