/*------------------------------------------------------------------------
    File        : vacation_lookup.i
    Purpose     : Vacation lookup helpers. {&NO-VACATION-FUNCS} suppresses the functions.
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2016-07  kpo  add lock retry
 *  2002-11  kpo  add lock retry
 *  2008-05  jkm  remove dead code
 *  2006-08  rdh  add lock retry
 *  2004-06  ssp  new report column
 */

/* vacation_lookup.i : Vacation lookup helpers. {&NO-VACATION-FUNCS} suppresses the functions. */

&IF DEFINED(VACATION_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE VACATION_LOOKUP_I YES

DEFINE BUFFER bLkVacation FOR Vacation.

FUNCTION VacationExists RETURNS LOGICAL (INPUT pEmpNum AS INTEGER, INPUT pStartDate AS DATE):
  RETURN CAN-FIND(FIRST bLkVacation WHERE bLkVacation.EmpNum = pEmpNum AND bLkVacation.StartDate = pStartDate).
END FUNCTION.

PROCEDURE find-vacation :
  DEFINE INPUT  PARAMETER pEmpNum AS INTEGER NO-UNDO.
  DEFINE INPUT  PARAMETER pStartDate AS DATE NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkVacation NO-LOCK WHERE bLkVacation.EmpNum = pEmpNum AND bLkVacation.StartDate = pStartDate NO-ERROR.
  pRowid = IF AVAILABLE bLkVacation THEN ROWID(bLkVacation) ELSE ?.
END PROCEDURE.

&ENDIF

