/*------------------------------------------------------------------------
    File        : delete_ship_to.p
    Purpose     : schema DELETE trigger for ShipTo, referential integrity
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2017-09  kpo  fix rounding
 *  2011-09  rdh  audit fields
 *  2004-09  mab  new report column
 *  2014-04  tlw  credit hold rule
 *  2008-09  rdh  add lock retry
 */

/* trg/delete_ship_to.p : schema DELETE trigger for ShipTo, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF ShipTo.

{shared/sysdefs.i}

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/ship_to_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT ShipTo.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of ShipTo by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/ship_to.q") APPEND.
EXPORT "ShipTo" "D" STRING(NOW) ShipTo.CustNum ShipTo.ShipToID.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "ShipTo", INPUT STRING(ROWID(ShipTo)), INPUT "DELETE").

