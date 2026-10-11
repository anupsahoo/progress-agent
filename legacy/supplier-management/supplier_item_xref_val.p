/*------------------------------------------------------------------------
    File        : supplier_item_xref_val.p
    Purpose     : Business validation for SupplierItemXref
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bSupplierItemXref FOR SupplierItemXref.

FIND bSupplierItemXref WHERE ROWID(bSupplierItemXref) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bSupplierItemXref THEN DO:
  ASSIGN plOk = NO pcMsg = "SupplierItemXref record not found.".
  RETURN.
END.

/* SupplierIDNum: CAN-FIND(supplier OF supplieritemxref) */
IF NOT CAN-FIND(FIRST Supplier WHERE Supplier.SupplierIDNum = bSupplierItemXref.SupplierIDNum) THEN
  RUN add-error ("Supplier must exist.").

/* Itemnum: CAN-FIND(item OF supplieritemxref) */
IF NOT CAN-FIND(FIRST Item WHERE Item.Itemnum = bSupplierItemXref.Itemnum) THEN
  RUN add-error ("Item must be on file.").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

