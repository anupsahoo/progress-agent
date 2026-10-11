/*------------------------------------------------------------------------
    File        : delete_state.p
    Purpose     : schema DELETE trigger for State, referential integrity
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2002-02  mab  credit hold rule
 *  2017-10  tlw  performance: use index
 */

/* trg/delete_state.p : schema DELETE trigger for State, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF State.

{shared/sysdefs.i}

IF CAN-FIND(FIRST BillTo WHERE BillTo.State = State.State) THEN DO:
  MESSAGE "Cannot delete State: BillTo records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST Customer WHERE Customer.State = State.State) THEN DO:
  MESSAGE "Cannot delete State: Customer records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST Employee WHERE Employee.State = State.State) THEN DO:
  MESSAGE "Cannot delete State: Employee records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST ShipTo WHERE ShipTo.State = State.State) THEN DO:
  MESSAGE "Cannot delete State: ShipTo records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST Supplier WHERE Supplier.State = State.State) THEN DO:
  MESSAGE "Cannot delete State: Supplier records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

/* Table VALEXP: NOT (CAN-FIND(FIRST customer OF state)) */

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/state_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT State.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of State by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/state.q") APPEND.
EXPORT "State" "D" STRING(NOW) State.State.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "State", INPUT STRING(ROWID(State)), INPUT "DELETE").

