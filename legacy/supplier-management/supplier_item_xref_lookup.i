/*------------------------------------------------------------------------
    File        : supplier_item_xref_lookup.i
    Purpose     : SupplierItemXref lookup helpers. {&NO-SUPPLIERITEMXREF-FUNCS} suppresses the functions.
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2012-08  rdh  credit hold rule
 */

/* supplier_item_xref_lookup.i : SupplierItemXref lookup helpers. {&NO-SUPPLIERITEMXREF-FUNCS} suppresses the functions. */

&IF DEFINED(SUPPLIER_ITEM_XREF_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE SUPPLIER_ITEM_XREF_LOOKUP_I YES

DEFINE BUFFER bLkSupplierItemXref FOR SupplierItemXref.

FUNCTION SupplierItemXrefExists RETURNS LOGICAL (INPUT pSupplierIDNum AS INTEGER, INPUT pItemnum AS INTEGER):
  RETURN CAN-FIND(FIRST bLkSupplierItemXref WHERE bLkSupplierItemXref.SupplierIDNum = pSupplierIDNum AND bLkSupplierItemXref.Itemnum = pItemnum).
END FUNCTION.

PROCEDURE find-supplier_item_xref :
  DEFINE INPUT  PARAMETER pSupplierIDNum AS INTEGER NO-UNDO.
  DEFINE INPUT  PARAMETER pItemnum AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkSupplierItemXref NO-LOCK WHERE bLkSupplierItemXref.SupplierIDNum = pSupplierIDNum AND bLkSupplierItemXref.Itemnum = pItemnum NO-ERROR.
  pRowid = IF AVAILABLE bLkSupplierItemXref THEN ROWID(bLkSupplierItemXref) ELSE ?.
END PROCEDURE.

&ENDIF

