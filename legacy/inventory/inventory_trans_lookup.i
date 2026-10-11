/*------------------------------------------------------------------------
    File        : inventory_trans_lookup.i
    Purpose     : InventoryTrans lookup helpers. {&NO-INVENTORYTRANS-FUNCS} suppresses the functions.
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-01  ssp  performance: use index
 */

/* inventory_trans_lookup.i : InventoryTrans lookup helpers. {&NO-INVENTORYTRANS-FUNCS} suppresses the functions. */

&IF DEFINED(INVENTORY_TRANS_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE INVENTORY_TRANS_LOOKUP_I YES

DEFINE BUFFER bLkInventoryTrans FOR InventoryTrans.

FUNCTION InventoryTransExists RETURNS LOGICAL (INPUT pInvTransNum AS INTEGER):
  RETURN CAN-FIND(FIRST bLkInventoryTrans WHERE bLkInventoryTrans.InvTransNum = pInvTransNum).
END FUNCTION.

FUNCTION InventoryTransDesc RETURNS CHARACTER (INPUT pInvTransNum AS INTEGER):
  FIND FIRST bLkInventoryTrans NO-LOCK WHERE bLkInventoryTrans.InvTransNum = pInvTransNum NO-ERROR.
  RETURN (IF AVAILABLE bLkInventoryTrans THEN bLkInventoryTrans.InvType ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-inventory_trans :
  DEFINE INPUT  PARAMETER pInvTransNum AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkInventoryTrans NO-LOCK WHERE bLkInventoryTrans.InvTransNum = pInvTransNum NO-ERROR.
  pRowid = IF AVAILABLE bLkInventoryTrans THEN ROWID(bLkInventoryTrans) ELSE ?.
END PROCEDURE.

&ENDIF

