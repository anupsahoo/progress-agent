/*------------------------------------------------------------------------
    File        : write_supplier_item_xref.p
    Purpose     : schema WRITE trigger for SupplierItemXref, field-level audit
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2002-11  tlw  new report column
 *  2016-05  kpo  audit fields
 *  2011-08  ssp  audit fields
 *  2002-06  mab  audit fields
 */

/* trg/write_supplier_item_xref.p : schema WRITE trigger for SupplierItemXref, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF SupplierItemXref OLD BUFFER oldSupplierItemXref.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN supplier-management/supplier_item_xref_val.p (INPUT ROWID(SupplierItemXref), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "SupplierItemXref write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF SupplierItemXref.SupplierIDNum <> oldSupplierItemXref.SupplierIDNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "SupplierItemXref.SupplierIDNum", INPUT STRING(oldSupplierItemXref.SupplierIDNum), INPUT STRING(SupplierItemXref.SupplierIDNum)).
END.
IF SupplierItemXref.Itemnum <> oldSupplierItemXref.Itemnum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "SupplierItemXref.Itemnum", INPUT STRING(oldSupplierItemXref.Itemnum), INPUT STRING(SupplierItemXref.Itemnum)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/supplier_item_xref.q") APPEND.
  EXPORT "SupplierItemXref" "W" STRING(NOW) SupplierItemXref.SupplierIDNum SupplierItemXref.Itemnum.
  OUTPUT CLOSE.
END.

