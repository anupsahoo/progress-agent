/*------------------------------------------------------------------------
    File        : delete_poline.p
    Purpose     : schema DELETE trigger for POLine, referential integrity
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-04  tlw  performance: use index
 *  2016-07  tlw  credit hold rule
 */

/* trg/delete_poline.p : schema DELETE trigger for POLine, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF POLine.

{shared/sysdefs.i}

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/poline_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT POLine.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of POLine by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/poline.q") APPEND.
EXPORT "POLine" "D" STRING(NOW) POLine.PONum POLine.Linenum.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "POLine", INPUT STRING(ROWID(POLine)), INPUT "DELETE").

