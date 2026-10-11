/*------------------------------------------------------------------------
    File        : bill_to_val.p
    Purpose     : Business validation for BillTo
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bBillTo FOR BillTo.

FIND bBillTo WHERE ROWID(bBillTo) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bBillTo THEN DO:
  ASSIGN plOk = NO pcMsg = "BillTo record not found.".
  RETURN.
END.

/* CustNum: CAN-FIND(customer OF billto) */
IF NOT CAN-FIND(FIRST Customer WHERE Customer.CustNum = bBillTo.CustNum) THEN
  RUN add-error ("Customer number must be greater than zero").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

