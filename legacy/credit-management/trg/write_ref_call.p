/*------------------------------------------------------------------------
    File        : write_ref_call.p
    Purpose     : schema WRITE trigger for RefCall, field-level audit
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2003-11  rdh  audit fields
 *  2011-09  ssp  new report column
 */

/* trg/write_ref_call.p : schema WRITE trigger for RefCall, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF RefCall OLD BUFFER oldRefCall.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN credit-management/ref_call_val.p (INPUT ROWID(RefCall), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "RefCall write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF RefCall.CallNum <> oldRefCall.CallNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "RefCall.CallNum", INPUT STRING(oldRefCall.CallNum), INPUT STRING(RefCall.CallNum)).
END.
IF RefCall.CustNum <> oldRefCall.CustNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "RefCall.CustNum", INPUT STRING(oldRefCall.CustNum), INPUT STRING(RefCall.CustNum)).
END.
IF RefCall.CallDate <> oldRefCall.CallDate THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "RefCall.CallDate", INPUT STRING(oldRefCall.CallDate), INPUT STRING(RefCall.CallDate)).
END.
IF RefCall.SalesRep <> oldRefCall.SalesRep THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "RefCall.SalesRep", INPUT STRING(oldRefCall.SalesRep), INPUT STRING(RefCall.SalesRep)).
END.
IF RefCall.Parent <> oldRefCall.Parent THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "RefCall.Parent", INPUT STRING(oldRefCall.Parent), INPUT STRING(RefCall.Parent)).
END.
IF RefCall.Txt <> oldRefCall.Txt THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "RefCall.Txt", INPUT STRING(oldRefCall.Txt), INPUT STRING(RefCall.Txt)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/ref_call.q") APPEND.
  EXPORT "RefCall" "W" STRING(NOW) RefCall.CallNum.
  OUTPUT CLOSE.
END.

