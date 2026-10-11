/*------------------------------------------------------------------------
    File        : write_local_default.p
    Purpose     : schema WRITE trigger for LocalDefault, field-level audit
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2014-09  jkm  remove dead code
 */

/* trg/write_local_default.p : schema WRITE trigger for LocalDefault, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF LocalDefault OLD BUFFER oldLocalDefault.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN sales-territories/local_default_val.p (INPUT ROWID(LocalDefault), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "LocalDefault write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF LocalDefault.Country <> oldLocalDefault.Country THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "LocalDefault.Country", INPUT STRING(oldLocalDefault.Country), INPUT STRING(LocalDefault.Country)).
END.
IF LocalDefault.Region1Label <> oldLocalDefault.Region1Label THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "LocalDefault.Region1Label", INPUT STRING(oldLocalDefault.Region1Label), INPUT STRING(LocalDefault.Region1Label)).
END.
IF LocalDefault.Region2Label <> oldLocalDefault.Region2Label THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "LocalDefault.Region2Label", INPUT STRING(oldLocalDefault.Region2Label), INPUT STRING(LocalDefault.Region2Label)).
END.
IF LocalDefault.PostalLabel <> oldLocalDefault.PostalLabel THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "LocalDefault.PostalLabel", INPUT STRING(oldLocalDefault.PostalLabel), INPUT STRING(LocalDefault.PostalLabel)).
END.
IF LocalDefault.PostalFormat <> oldLocalDefault.PostalFormat THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "LocalDefault.PostalFormat", INPUT STRING(oldLocalDefault.PostalFormat), INPUT STRING(LocalDefault.PostalFormat)).
END.
IF LocalDefault.TelFormat <> oldLocalDefault.TelFormat THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "LocalDefault.TelFormat", INPUT STRING(oldLocalDefault.TelFormat), INPUT STRING(LocalDefault.TelFormat)).
END.
IF LocalDefault.CurrencySymbol <> oldLocalDefault.CurrencySymbol THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "LocalDefault.CurrencySymbol", INPUT STRING(oldLocalDefault.CurrencySymbol), INPUT STRING(LocalDefault.CurrencySymbol)).
END.
IF LocalDefault.DateFormat <> oldLocalDefault.DateFormat THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "LocalDefault.DateFormat", INPUT STRING(oldLocalDefault.DateFormat), INPUT STRING(LocalDefault.DateFormat)).
END.
IF LocalDefault.LocalDefNum <> oldLocalDefault.LocalDefNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "LocalDefault.LocalDefNum", INPUT STRING(oldLocalDefault.LocalDefNum), INPUT STRING(LocalDefault.LocalDefNum)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/local_default.q") APPEND.
  EXPORT "LocalDefault" "W" STRING(NOW) LocalDefault.LocalDefNum.
  OUTPUT CLOSE.
END.

