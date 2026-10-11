/*------------------------------------------------------------------------
    File        : inventory_trans_val.p
    Purpose     : Business validation for InventoryTrans
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bInventoryTrans FOR InventoryTrans.

FIND bInventoryTrans WHERE ROWID(bInventoryTrans) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bInventoryTrans THEN DO:
  ASSIGN plOk = NO pcMsg = "InventoryTrans record not found.".
  RETURN.
END.

/* Itemnum: CAN-FIND(item OF inventorytrans) */
IF NOT CAN-FIND(FIRST Item WHERE Item.Itemnum = bInventoryTrans.Itemnum) THEN
  RUN add-error ("Item must be on file.").

IF bInventoryTrans.TransDate <> ? AND YEAR(bInventoryTrans.TransDate) < 1950 THEN
  RUN add-error ("Trans Date is before the 1950 date window.").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

