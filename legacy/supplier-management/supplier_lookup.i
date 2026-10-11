/*------------------------------------------------------------------------
    File        : supplier_lookup.i
    Purpose     : Supplier lookup helpers. {&NO-SUPPLIER-FUNCS} suppresses the functions.
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-03  tlw  audit fields
 */

/* supplier_lookup.i : Supplier lookup helpers. {&NO-SUPPLIER-FUNCS} suppresses the functions. */

&IF DEFINED(SUPPLIER_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE SUPPLIER_LOOKUP_I YES

DEFINE BUFFER bLkSupplier FOR Supplier.

FUNCTION SupplierExists RETURNS LOGICAL (INPUT pSupplierIDNum AS INTEGER):
  RETURN CAN-FIND(FIRST bLkSupplier WHERE bLkSupplier.SupplierIDNum = pSupplierIDNum).
END FUNCTION.

FUNCTION SupplierDesc RETURNS CHARACTER (INPUT pSupplierIDNum AS INTEGER):
  FIND FIRST bLkSupplier NO-LOCK WHERE bLkSupplier.SupplierIDNum = pSupplierIDNum NO-ERROR.
  RETURN (IF AVAILABLE bLkSupplier THEN bLkSupplier.Name ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-supplier :
  DEFINE INPUT  PARAMETER pSupplierIDNum AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkSupplier NO-LOCK WHERE bLkSupplier.SupplierIDNum = pSupplierIDNum NO-ERROR.
  pRowid = IF AVAILABLE bLkSupplier THEN ROWID(bLkSupplier) ELSE ?.
END PROCEDURE.

&ENDIF

