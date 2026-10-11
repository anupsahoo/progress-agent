/*------------------------------------------------------------------------
    File        : delete_bill_to.p
    Purpose     : schema DELETE trigger for BillTo, referential integrity
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-05  rdh  remove dead code
 *  2004-05  rdh  fix rounding
 *  2001-11  jkm  appserver split
 *  2008-11  rdh  performance: use index
 *  2011-08  rdh  add lock retry
 */

/* trg/delete_bill_to.p : schema DELETE trigger for BillTo, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF BillTo.

{shared/sysdefs.i}

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/bill_to_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT BillTo.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of BillTo by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/bill_to.q") APPEND.
EXPORT "BillTo" "D" STRING(NOW) BillTo.CustNum BillTo.BillToID.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "BillTo", INPUT STRING(ROWID(BillTo)), INPUT "DELETE").

