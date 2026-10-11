/*------------------------------------------------------------------------
    File        : write_supplier.p
    Purpose     : schema WRITE trigger for Supplier, field-level audit
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2009-07  mab  remove dead code
 *  2016-12  tlw  remove dead code
 *  1999-10  rdh  appserver split
 *  2013-12  jkm  audit fields
 *  2017-06  rdh  audit fields
 */

/* trg/write_supplier.p : schema WRITE trigger for Supplier, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF Supplier OLD BUFFER oldSupplier.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN supplier-management/supplier_val.p (INPUT ROWID(Supplier), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "Supplier write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF Supplier.SupplierIDNum <> oldSupplier.SupplierIDNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Supplier.SupplierIDNum", INPUT STRING(oldSupplier.SupplierIDNum), INPUT STRING(Supplier.SupplierIDNum)).
END.
IF Supplier.Name <> oldSupplier.Name THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Supplier.Name", INPUT STRING(oldSupplier.Name), INPUT STRING(Supplier.Name)).
END.
IF Supplier.Address <> oldSupplier.Address THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Supplier.Address", INPUT STRING(oldSupplier.Address), INPUT STRING(Supplier.Address)).
END.
IF Supplier.Address2 <> oldSupplier.Address2 THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Supplier.Address2", INPUT STRING(oldSupplier.Address2), INPUT STRING(Supplier.Address2)).
END.
IF Supplier.City <> oldSupplier.City THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Supplier.City", INPUT STRING(oldSupplier.City), INPUT STRING(Supplier.City)).
END.
IF Supplier.State <> oldSupplier.State THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Supplier.State", INPUT STRING(oldSupplier.State), INPUT STRING(Supplier.State)).
END.
IF Supplier.PostalCode <> oldSupplier.PostalCode THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Supplier.PostalCode", INPUT STRING(oldSupplier.PostalCode), INPUT STRING(Supplier.PostalCode)).
END.
IF Supplier.Country <> oldSupplier.Country THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Supplier.Country", INPUT STRING(oldSupplier.Country), INPUT STRING(Supplier.Country)).
END.
IF Supplier.Phone <> oldSupplier.Phone THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Supplier.Phone", INPUT STRING(oldSupplier.Phone), INPUT STRING(Supplier.Phone)).
END.
IF Supplier.Comments <> oldSupplier.Comments THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Supplier.Comments", INPUT STRING(oldSupplier.Comments), INPUT STRING(Supplier.Comments)).
END.
IF Supplier.Password <> oldSupplier.Password THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Supplier.Password", INPUT STRING(oldSupplier.Password), INPUT STRING(Supplier.Password)).
END.
IF Supplier.LoginDate <> oldSupplier.LoginDate THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Supplier.LoginDate", INPUT STRING(oldSupplier.LoginDate), INPUT STRING(Supplier.LoginDate)).
END.
IF Supplier.ShipAmount <> oldSupplier.ShipAmount THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Supplier.ShipAmount", INPUT STRING(oldSupplier.ShipAmount), INPUT STRING(Supplier.ShipAmount)).
END.
IF Supplier.Discount <> oldSupplier.Discount THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Supplier.Discount", INPUT STRING(oldSupplier.Discount), INPUT STRING(Supplier.Discount)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/supplier.q") APPEND.
  EXPORT "Supplier" "W" STRING(NOW) Supplier.SupplierIDNum.
  OUTPUT CLOSE.
END.

