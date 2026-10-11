/*------------------------------------------------------------------------
    File        : delete_order_line.p
    Purpose     : schema DELETE trigger for OrderLine, referential integrity
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2004-05  kpo  new report column
 *  2013-01  ssp  audit fields
 */

/* trg/delete_order_line.p : schema DELETE trigger for OrderLine, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF OrderLine.

{shared/sysdefs.i}

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/order_line_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT OrderLine.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of OrderLine by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/order_line.q") APPEND.
EXPORT "OrderLine" "D" STRING(NOW) OrderLine.Ordernum OrderLine.Linenum.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "OrderLine", INPUT STRING(ROWID(OrderLine)), INPUT "DELETE").

