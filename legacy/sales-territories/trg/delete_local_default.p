/*------------------------------------------------------------------------
    File        : delete_local_default.p
    Purpose     : schema DELETE trigger for LocalDefault, referential integrity
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-02  rdh  add lock retry
 */

/* trg/delete_local_default.p : schema DELETE trigger for LocalDefault, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF LocalDefault.

{shared/sysdefs.i}

/* Table VALEXP: NOT (CAN-FIND(FIRST Customer WHERE Customer.Country = LocalDefault.Country)) */

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/local_default_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT LocalDefault.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of LocalDefault by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/local_default.q") APPEND.
EXPORT "LocalDefault" "D" STRING(NOW) LocalDefault.LocalDefNum.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "LocalDefault", INPUT STRING(ROWID(LocalDefault)), INPUT "DELETE").

