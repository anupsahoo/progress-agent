/*------------------------------------------------------------------------
    File        : write_poline.p
    Purpose     : schema WRITE trigger for POLine, field-level audit
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2008-09  kpo  audit fields
 *  2000-04  mab  appserver split
 *  2009-10  mab  fix rounding
 *  2004-08  ssp  fix rounding
 */

/* trg/write_poline.p : schema WRITE trigger for POLine, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF POLine OLD BUFFER oldPOLine.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN purchasing/poline_val.p (INPUT ROWID(POLine), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "POLine write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF POLine.Linenum <> oldPOLine.Linenum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "POLine.Linenum", INPUT STRING(oldPOLine.Linenum), INPUT STRING(POLine.Linenum)).
END.
IF POLine.Itemnum <> oldPOLine.Itemnum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "POLine.Itemnum", INPUT STRING(oldPOLine.Itemnum), INPUT STRING(POLine.Itemnum)).
END.
IF POLine.Price <> oldPOLine.Price THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "POLine.Price", INPUT STRING(oldPOLine.Price), INPUT STRING(POLine.Price)).
END.
IF POLine.Qty <> oldPOLine.Qty THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "POLine.Qty", INPUT STRING(oldPOLine.Qty), INPUT STRING(POLine.Qty)).
END.
IF POLine.Discount <> oldPOLine.Discount THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "POLine.Discount", INPUT STRING(oldPOLine.Discount), INPUT STRING(POLine.Discount)).
END.
IF POLine.ExtendedPrice <> oldPOLine.ExtendedPrice THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "POLine.ExtendedPrice", INPUT STRING(oldPOLine.ExtendedPrice), INPUT STRING(POLine.ExtendedPrice)).
END.
IF POLine.PONum <> oldPOLine.PONum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "POLine.PONum", INPUT STRING(oldPOLine.PONum), INPUT STRING(POLine.PONum)).
END.
IF POLine.POLineStatus <> oldPOLine.POLineStatus THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "POLine.POLineStatus", INPUT STRING(oldPOLine.POLineStatus), INPUT STRING(POLine.POLineStatus)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/poline.q") APPEND.
  EXPORT "POLine" "W" STRING(NOW) POLine.PONum POLine.Linenum.
  OUTPUT CLOSE.
END.

