/*------------------------------------------------------------------------
    File        : ref_call_val.p
    Purpose     : Business validation for RefCall
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bRefCall FOR RefCall.

FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bRefCall THEN DO:
  ASSIGN plOk = NO pcMsg = "RefCall record not found.".
  RETURN.
END.

IF TRIM(bRefCall.CallNum) = "" THEN RUN add-error ("Call Num is required.").

/* CustNum: custnum > 0 */
IF NOT (bRefCall.CustNum > 0) THEN
  RUN add-error ("Customer number must be greater than zero").

IF bRefCall.CallDate <> ? AND YEAR(bRefCall.CallDate) < 1950 THEN
  RUN add-error ("Call Date is before the 1950 date window.").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

