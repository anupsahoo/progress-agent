/*------------------------------------------------------------------------
    File        : poline_lookup.i
    Purpose     : POLine lookup helpers. {&NO-POLINE-FUNCS} suppresses the functions.
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2006-05  mab  fix rounding
 *  2005-06  kpo  Y2K date window
 *  2006-10  kpo  audit fields
 *  2003-08  rdh  Y2K date window
 *  1999-03  tlw  new report column
 */

/* poline_lookup.i : POLine lookup helpers. {&NO-POLINE-FUNCS} suppresses the functions. */

&IF DEFINED(POLINE_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE POLINE_LOOKUP_I YES

DEFINE BUFFER bLkPOLine FOR POLine.

FUNCTION POLineExists RETURNS LOGICAL (INPUT pPONum AS INTEGER, INPUT pLinenum AS INTEGER):
  RETURN CAN-FIND(FIRST bLkPOLine WHERE bLkPOLine.PONum = pPONum AND bLkPOLine.Linenum = pLinenum).
END FUNCTION.

FUNCTION POLineDesc RETURNS CHARACTER (INPUT pPONum AS INTEGER, INPUT pLinenum AS INTEGER):
  FIND FIRST bLkPOLine NO-LOCK WHERE bLkPOLine.PONum = pPONum AND bLkPOLine.Linenum = pLinenum NO-ERROR.
  RETURN (IF AVAILABLE bLkPOLine THEN bLkPOLine.POLineStatus ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-poline :
  DEFINE INPUT  PARAMETER pPONum AS INTEGER NO-UNDO.
  DEFINE INPUT  PARAMETER pLinenum AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkPOLine NO-LOCK WHERE bLkPOLine.PONum = pPONum AND bLkPOLine.Linenum = pLinenum NO-ERROR.
  pRowid = IF AVAILABLE bLkPOLine THEN ROWID(bLkPOLine) ELSE ?.
END PROCEDURE.

&ENDIF

