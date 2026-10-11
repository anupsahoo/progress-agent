/*------------------------------------------------------------------------
    File        : salesrep_val.p
    Purpose     : Business validation for Salesrep
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bSalesrep FOR Salesrep.

FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bSalesrep THEN DO:
  ASSIGN plOk = NO pcMsg = "Salesrep record not found.".
  RETURN.
END.

IF TRIM(bSalesrep.SalesRep) = "" THEN RUN add-error ("Sales Rep is required.").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

