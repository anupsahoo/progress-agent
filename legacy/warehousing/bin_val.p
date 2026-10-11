/*------------------------------------------------------------------------
    File        : bin_val.p
    Purpose     : Business validation for Bin
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bBin FOR Bin.

FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bBin THEN DO:
  ASSIGN plOk = NO pcMsg = "Bin record not found.".
  RETURN.
END.

/* WarehouseNum: CAN-FIND(warehouse OF bin) */
IF NOT CAN-FIND(FIRST Warehouse WHERE Warehouse.WarehouseNum = bBin.WarehouseNum) THEN
  RUN add-error ("Warehouse must exist.").

/* Itemnum: CAN-FIND(item OF bin) */
IF NOT CAN-FIND(FIRST Item WHERE Item.Itemnum = bBin.Itemnum) THEN
  RUN add-error ("Item must be on file").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

