/*------------------------------------------------------------------------
    File        : write_state.p
    Purpose     : schema WRITE trigger for State, field-level audit
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-02  rdh  performance: use index
 *  2013-01  kpo  add lock retry
 *  2006-12  mab  appserver split
 *  2009-05  ssp  credit hold rule
 *  2008-04  tlw  remove dead code
 */

/* trg/write_state.p : schema WRITE trigger for State, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF State OLD BUFFER oldState.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN sales-territories/state_val.p (INPUT ROWID(State), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "State write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF State.State <> oldState.State THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "State.State", INPUT STRING(oldState.State), INPUT STRING(State.State)).
END.
IF State.StateName <> oldState.StateName THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "State.StateName", INPUT STRING(oldState.StateName), INPUT STRING(State.StateName)).
END.
IF State.Region <> oldState.Region THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "State.Region", INPUT STRING(oldState.Region), INPUT STRING(State.Region)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/state.q") APPEND.
  EXPORT "State" "W" STRING(NOW) State.State.
  OUTPUT CLOSE.
END.

