/*------------------------------------------------------------------------
    File        : state_lookup.i
    Purpose     : State lookup helpers. {&NO-STATE-FUNCS} suppresses the functions.
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2015-08  tlw  add lock retry
 *  2016-07  rdh  audit fields
 *  2014-09  ssp  fix rounding
 *  2010-09  rdh  remove dead code
 *  2016-10  tlw  audit fields
 */

/* state_lookup.i : State lookup helpers. {&NO-STATE-FUNCS} suppresses the functions. */

&IF DEFINED(STATE_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE STATE_LOOKUP_I YES

DEFINE BUFFER bLkState FOR State.

FUNCTION StateExists RETURNS LOGICAL (INPUT pState AS CHARACTER):
  RETURN CAN-FIND(FIRST bLkState WHERE bLkState.State = pState).
END FUNCTION.

FUNCTION StateDesc RETURNS CHARACTER (INPUT pState AS CHARACTER):
  FIND FIRST bLkState NO-LOCK WHERE bLkState.State = pState NO-ERROR.
  RETURN (IF AVAILABLE bLkState THEN bLkState.StateName ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-state :
  DEFINE INPUT  PARAMETER pState AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkState NO-LOCK WHERE bLkState.State = pState NO-ERROR.
  pRowid = IF AVAILABLE bLkState THEN ROWID(bLkState) ELSE ?.
END PROCEDURE.

&ENDIF

