/*------------------------------------------------------------------------
    File        : supplier_val.p
    Purpose     : Business validation for Supplier
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bSupplier FOR Supplier.

FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bSupplier THEN DO:
  ASSIGN plOk = NO pcMsg = "Supplier record not found.".
  RETURN.
END.

/* SupplierIDNum: supplier.SupplierIDnum > 0 */
IF NOT (bSupplier.SupplierIDNum > 0) THEN
  RUN add-error ("Supplier number must be greater than zero").

IF bSupplier.LoginDate <> ? AND YEAR(bSupplier.LoginDate) < 1950 THEN
  RUN add-error ("Login Date is before the 1950 date window.").

/* Discount: Discount >= 0 */
IF NOT (bSupplier.Discount >= 0) THEN
  RUN add-error ("Discount must be greater or equal to 0").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

