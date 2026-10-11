/*------------------------------------------------------------------------
    File        : delete_supplier_item_xref.p
    Purpose     : schema DELETE trigger for SupplierItemXref, referential integrity
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2015-10  jkm  new report column
 *  2004-02  kpo  audit fields
 *  2009-08  ssp  new report column
 *  2014-03  kpo  fix rounding
 *  2003-01  kpo  performance: use index
 */

/* trg/delete_supplier_item_xref.p : schema DELETE trigger for SupplierItemXref, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF SupplierItemXref.

{shared/sysdefs.i}

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/supplier_item_xref_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT SupplierItemXref.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of SupplierItemXref by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/supplier_item_xref.q") APPEND.
EXPORT "SupplierItemXref" "D" STRING(NOW) SupplierItemXref.SupplierIDNum SupplierItemXref.Itemnum.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "SupplierItemXref", INPUT STRING(ROWID(SupplierItemXref)), INPUT "DELETE").

