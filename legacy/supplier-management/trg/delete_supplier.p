/*------------------------------------------------------------------------
    File        : delete_supplier.p
    Purpose     : schema DELETE trigger for Supplier, referential integrity
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-06  ssp  new report column
 */

/* trg/delete_supplier.p : schema DELETE trigger for Supplier, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF Supplier.

{shared/sysdefs.i}

IF CAN-FIND(FIRST PurchaseOrder WHERE PurchaseOrder.SupplierIDNum = Supplier.SupplierIDNum) THEN DO:
  MESSAGE "Cannot delete Supplier: PurchaseOrder records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST SupplierItemXref WHERE SupplierItemXref.SupplierIDNum = Supplier.SupplierIDNum) THEN DO:
  MESSAGE "Cannot delete Supplier: SupplierItemXref records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/supplier_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT Supplier.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of Supplier by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/supplier.q") APPEND.
EXPORT "Supplier" "D" STRING(NOW) Supplier.SupplierIDNum.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "Supplier", INPUT STRING(ROWID(Supplier)), INPUT "DELETE").

