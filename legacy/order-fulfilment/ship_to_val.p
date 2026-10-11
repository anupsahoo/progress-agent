/*------------------------------------------------------------------------
    File        : ship_to_val.p
    Purpose     : Business validation for ShipTo
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bShipTo FOR ShipTo.

FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bShipTo THEN DO:
  ASSIGN plOk = NO pcMsg = "ShipTo record not found.".
  RETURN.
END.

/* CustNum: CAN-FIND(customer OF shipto) */
IF NOT CAN-FIND(FIRST Customer WHERE Customer.CustNum = bShipTo.CustNum) THEN
  RUN add-error ("Customer must exist").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

