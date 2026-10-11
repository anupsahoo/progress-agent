/*------------------------------------------------------------------------
    File        : item_val.p
    Purpose     : Business validation for Item
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bItem FOR Item.

FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bItem THEN DO:
  ASSIGN plOk = NO pcMsg = "Item record not found.".
  RETURN.
END.

/* Itemnum: itemnum >= 0 */
IF NOT (bItem.Itemnum >= 0) THEN
  RUN add-error ("Item number must be greater or equal to 0").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

