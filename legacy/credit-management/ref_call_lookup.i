/*------------------------------------------------------------------------
    File        : ref_call_lookup.i
    Purpose     : RefCall lookup helpers. {&NO-REFCALL-FUNCS} suppresses the functions.
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2016-03  tlw  credit hold rule
 *  2015-07  tlw  remove dead code
 *  2007-09  jkm  fix rounding
 *  2015-07  rdh  audit fields
 */

/* ref_call_lookup.i : RefCall lookup helpers. {&NO-REFCALL-FUNCS} suppresses the functions. */

&IF DEFINED(REF_CALL_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE REF_CALL_LOOKUP_I YES

DEFINE BUFFER bLkRefCall FOR RefCall.

FUNCTION RefCallExists RETURNS LOGICAL (INPUT pCallNum AS CHARACTER):
  RETURN CAN-FIND(FIRST bLkRefCall WHERE bLkRefCall.CallNum = pCallNum).
END FUNCTION.

FUNCTION RefCallDesc RETURNS CHARACTER (INPUT pCallNum AS CHARACTER):
  FIND FIRST bLkRefCall NO-LOCK WHERE bLkRefCall.CallNum = pCallNum NO-ERROR.
  RETURN (IF AVAILABLE bLkRefCall THEN bLkRefCall.CallNum ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-ref_call :
  DEFINE INPUT  PARAMETER pCallNum AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkRefCall NO-LOCK WHERE bLkRefCall.CallNum = pCallNum NO-ERROR.
  pRowid = IF AVAILABLE bLkRefCall THEN ROWID(bLkRefCall) ELSE ?.
END PROCEDURE.

&ENDIF

