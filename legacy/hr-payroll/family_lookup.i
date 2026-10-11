/*------------------------------------------------------------------------
    File        : family_lookup.i
    Purpose     : Family lookup helpers. {&NO-FAMILY-FUNCS} suppresses the functions.
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-07  ssp  new report column
 *  2017-09  ssp  Y2K date window
 *  2008-01  kpo  appserver split
 */

/* family_lookup.i : Family lookup helpers. {&NO-FAMILY-FUNCS} suppresses the functions. */

&IF DEFINED(FAMILY_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE FAMILY_LOOKUP_I YES

DEFINE BUFFER bLkFamily FOR Family.

FUNCTION FamilyExists RETURNS LOGICAL (INPUT pEmpNum AS INTEGER, INPUT pRelativeName AS CHARACTER):
  RETURN CAN-FIND(FIRST bLkFamily WHERE bLkFamily.EmpNum = pEmpNum AND bLkFamily.RelativeName = pRelativeName).
END FUNCTION.

FUNCTION FamilyDesc RETURNS CHARACTER (INPUT pEmpNum AS INTEGER, INPUT pRelativeName AS CHARACTER):
  FIND FIRST bLkFamily NO-LOCK WHERE bLkFamily.EmpNum = pEmpNum AND bLkFamily.RelativeName = pRelativeName NO-ERROR.
  RETURN (IF AVAILABLE bLkFamily THEN bLkFamily.RelativeName ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-family :
  DEFINE INPUT  PARAMETER pEmpNum AS INTEGER NO-UNDO.
  DEFINE INPUT  PARAMETER pRelativeName AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkFamily NO-LOCK WHERE bLkFamily.EmpNum = pEmpNum AND bLkFamily.RelativeName = pRelativeName NO-ERROR.
  pRowid = IF AVAILABLE bLkFamily THEN ROWID(bLkFamily) ELSE ?.
END PROCEDURE.

&ENDIF

