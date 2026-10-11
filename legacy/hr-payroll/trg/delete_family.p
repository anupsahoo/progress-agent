/*------------------------------------------------------------------------
    File        : delete_family.p
    Purpose     : schema DELETE trigger for Family, referential integrity
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-12  rdh  add lock retry
 *  2012-08  kpo  appserver split
 */

/* trg/delete_family.p : schema DELETE trigger for Family, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF Family.

{shared/sysdefs.i}

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/family_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT Family.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of Family by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/family.q") APPEND.
EXPORT "Family" "D" STRING(NOW) Family.EmpNum Family.RelativeName.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "Family", INPUT STRING(ROWID(Family)), INPUT "DELETE").

