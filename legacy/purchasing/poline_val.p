/*------------------------------------------------------------------------
    File        : poline_val.p
    Purpose     : Business validation for POLine
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bPOLine FOR POLine.

FIND bPOLine WHERE ROWID(bPOLine) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bPOLine THEN DO:
  ASSIGN plOk = NO pcMsg = "POLine record not found.".
  RETURN.
END.

/* Itemnum: CAN-FIND(item OF poline) */
IF NOT CAN-FIND(FIRST Item WHERE Item.Itemnum = bPOLine.Itemnum) THEN
  RUN add-error ("Item must be on file").

/* PONum: can-find(purchaseorder of poline) */
IF NOT CAN-FIND(FIRST PurchaseOrder WHERE PurchaseOrder.PONum = bPOLine.PONum) THEN
  RUN add-error ("Purchase order must exist.").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

