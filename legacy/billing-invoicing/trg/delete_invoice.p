/*------------------------------------------------------------------------
    File        : delete_invoice.p
    Purpose     : schema DELETE trigger for Invoice, referential integrity
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-07  mab  Y2K date window
 *  2002-08  jkm  performance: use index
 *  2008-12  rdh  remove dead code
 *  2017-09  ssp  audit fields
 */

/* trg/delete_invoice.p : schema DELETE trigger for Invoice, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF Invoice.

{shared/sysdefs.i}

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/invoice_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT Invoice.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of Invoice by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/invoice.q") APPEND.
EXPORT "Invoice" "D" STRING(NOW) Invoice.Invoicenum.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "Invoice", INPUT STRING(ROWID(Invoice)), INPUT "DELETE").

