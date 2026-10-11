/*------------------------------------------------------------------------
    File        : write_bill_to.p
    Purpose     : schema WRITE trigger for BillTo, field-level audit
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2001-03  ssp  add lock retry
 */

/* trg/write_bill_to.p : schema WRITE trigger for BillTo, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF BillTo OLD BUFFER oldBillTo.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN billing-invoicing/bill_to_val.p (INPUT ROWID(BillTo), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "BillTo write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF BillTo.CustNum <> oldBillTo.CustNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "BillTo.CustNum", INPUT STRING(oldBillTo.CustNum), INPUT STRING(BillTo.CustNum)).
END.
IF BillTo.BillToID <> oldBillTo.BillToID THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "BillTo.BillToID", INPUT STRING(oldBillTo.BillToID), INPUT STRING(BillTo.BillToID)).
END.
IF BillTo.Name <> oldBillTo.Name THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "BillTo.Name", INPUT STRING(oldBillTo.Name), INPUT STRING(BillTo.Name)).
END.
IF BillTo.Address <> oldBillTo.Address THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "BillTo.Address", INPUT STRING(oldBillTo.Address), INPUT STRING(BillTo.Address)).
END.
IF BillTo.Address2 <> oldBillTo.Address2 THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "BillTo.Address2", INPUT STRING(oldBillTo.Address2), INPUT STRING(BillTo.Address2)).
END.
IF BillTo.City <> oldBillTo.City THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "BillTo.City", INPUT STRING(oldBillTo.City), INPUT STRING(BillTo.City)).
END.
IF BillTo.State <> oldBillTo.State THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "BillTo.State", INPUT STRING(oldBillTo.State), INPUT STRING(BillTo.State)).
END.
IF BillTo.PostalCode <> oldBillTo.PostalCode THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "BillTo.PostalCode", INPUT STRING(oldBillTo.PostalCode), INPUT STRING(BillTo.PostalCode)).
END.
IF BillTo.Contact <> oldBillTo.Contact THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "BillTo.Contact", INPUT STRING(oldBillTo.Contact), INPUT STRING(BillTo.Contact)).
END.
IF BillTo.Phone <> oldBillTo.Phone THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "BillTo.Phone", INPUT STRING(oldBillTo.Phone), INPUT STRING(BillTo.Phone)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/bill_to.q") APPEND.
  EXPORT "BillTo" "W" STRING(NOW) BillTo.CustNum BillTo.BillToID.
  OUTPUT CLOSE.
END.

