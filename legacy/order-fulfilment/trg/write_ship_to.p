/*------------------------------------------------------------------------
    File        : write_ship_to.p
    Purpose     : schema WRITE trigger for ShipTo, field-level audit
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-01  kpo  add lock retry
 *  2014-03  rdh  audit fields
 *  2008-10  kpo  add lock retry
 */

/* trg/write_ship_to.p : schema WRITE trigger for ShipTo, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF ShipTo OLD BUFFER oldShipTo.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN order-fulfilment/ship_to_val.p (INPUT ROWID(ShipTo), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "ShipTo write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF ShipTo.CustNum <> oldShipTo.CustNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "ShipTo.CustNum", INPUT STRING(oldShipTo.CustNum), INPUT STRING(ShipTo.CustNum)).
END.
IF ShipTo.ShipToID <> oldShipTo.ShipToID THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "ShipTo.ShipToID", INPUT STRING(oldShipTo.ShipToID), INPUT STRING(ShipTo.ShipToID)).
END.
IF ShipTo.Contact <> oldShipTo.Contact THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "ShipTo.Contact", INPUT STRING(oldShipTo.Contact), INPUT STRING(ShipTo.Contact)).
END.
IF ShipTo.Address <> oldShipTo.Address THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "ShipTo.Address", INPUT STRING(oldShipTo.Address), INPUT STRING(ShipTo.Address)).
END.
IF ShipTo.Address2 <> oldShipTo.Address2 THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "ShipTo.Address2", INPUT STRING(oldShipTo.Address2), INPUT STRING(ShipTo.Address2)).
END.
IF ShipTo.City <> oldShipTo.City THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "ShipTo.City", INPUT STRING(oldShipTo.City), INPUT STRING(ShipTo.City)).
END.
IF ShipTo.State <> oldShipTo.State THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "ShipTo.State", INPUT STRING(oldShipTo.State), INPUT STRING(ShipTo.State)).
END.
IF ShipTo.PostalCode <> oldShipTo.PostalCode THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "ShipTo.PostalCode", INPUT STRING(oldShipTo.PostalCode), INPUT STRING(ShipTo.PostalCode)).
END.
IF ShipTo.Phone <> oldShipTo.Phone THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "ShipTo.Phone", INPUT STRING(oldShipTo.Phone), INPUT STRING(ShipTo.Phone)).
END.
IF ShipTo.Comments <> oldShipTo.Comments THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "ShipTo.Comments", INPUT STRING(oldShipTo.Comments), INPUT STRING(ShipTo.Comments)).
END.
IF ShipTo.Name <> oldShipTo.Name THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "ShipTo.Name", INPUT STRING(oldShipTo.Name), INPUT STRING(ShipTo.Name)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/ship_to.q") APPEND.
  EXPORT "ShipTo" "W" STRING(NOW) ShipTo.CustNum ShipTo.ShipToID.
  OUTPUT CLOSE.
END.

