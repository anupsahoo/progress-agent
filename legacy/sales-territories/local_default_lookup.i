/*------------------------------------------------------------------------
    File        : local_default_lookup.i
    Purpose     : LocalDefault lookup helpers. {&NO-LOCALDEFAULT-FUNCS} suppresses the functions.
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-07  rdh  credit hold rule
 *  2013-03  mab  Y2K date window
 */

/* local_default_lookup.i : LocalDefault lookup helpers. {&NO-LOCALDEFAULT-FUNCS} suppresses the functions. */

&IF DEFINED(LOCAL_DEFAULT_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE LOCAL_DEFAULT_LOOKUP_I YES

DEFINE BUFFER bLkLocalDefault FOR LocalDefault.

FUNCTION LocalDefaultExists RETURNS LOGICAL (INPUT pLocalDefNum AS INTEGER):
  RETURN CAN-FIND(FIRST bLkLocalDefault WHERE bLkLocalDefault.LocalDefNum = pLocalDefNum).
END FUNCTION.

FUNCTION LocalDefaultDesc RETURNS CHARACTER (INPUT pLocalDefNum AS INTEGER):
  FIND FIRST bLkLocalDefault NO-LOCK WHERE bLkLocalDefault.LocalDefNum = pLocalDefNum NO-ERROR.
  RETURN (IF AVAILABLE bLkLocalDefault THEN bLkLocalDefault.Country ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-local_default :
  DEFINE INPUT  PARAMETER pLocalDefNum AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkLocalDefault NO-LOCK WHERE bLkLocalDefault.LocalDefNum = pLocalDefNum NO-ERROR.
  pRowid = IF AVAILABLE bLkLocalDefault THEN ROWID(bLkLocalDefault) ELSE ?.
END PROCEDURE.

&ENDIF

