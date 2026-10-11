/*------------------------------------------------------------------------
    File        : delete_ref_call.p
    Purpose     : schema DELETE trigger for RefCall, referential integrity
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-10  jkm  add lock retry
 *  2014-01  mab  fix rounding
 *  2016-03  kpo  credit hold rule
 *  2017-09  mab  fix rounding
 *  2007-09  mab  appserver split
 */

/* trg/delete_ref_call.p : schema DELETE trigger for RefCall, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF RefCall.

{shared/sysdefs.i}

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/ref_call_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT RefCall.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of RefCall by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/ref_call.q") APPEND.
EXPORT "RefCall" "D" STRING(NOW) RefCall.CallNum.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "RefCall", INPUT STRING(ROWID(RefCall)), INPUT "DELETE").

