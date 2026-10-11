/*------------------------------------------------------------------------
    File        : benefits_lookup.i
    Purpose     : Benefits lookup helpers. {&NO-BENEFITS-FUNCS} suppresses the functions.
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-05  rdh  add lock retry
 *  2005-01  tlw  performance: use index
 *  1999-08  mab  remove dead code
 *  2017-05  mab  fix rounding
 *  2014-02  ssp  new report column
 */

/* benefits_lookup.i : Benefits lookup helpers. {&NO-BENEFITS-FUNCS} suppresses the functions. */

&IF DEFINED(BENEFITS_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE BENEFITS_LOOKUP_I YES

DEFINE BUFFER bLkBenefits FOR Benefits.

FUNCTION BenefitsExists RETURNS LOGICAL (INPUT pEmpNum AS INTEGER):
  RETURN CAN-FIND(FIRST bLkBenefits WHERE bLkBenefits.EmpNum = pEmpNum).
END FUNCTION.

FUNCTION BenefitsDesc RETURNS CHARACTER (INPUT pEmpNum AS INTEGER):
  FIND FIRST bLkBenefits NO-LOCK WHERE bLkBenefits.EmpNum = pEmpNum NO-ERROR.
  RETURN (IF AVAILABLE bLkBenefits THEN bLkBenefits.HealthCare ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-benefits :
  DEFINE INPUT  PARAMETER pEmpNum AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkBenefits NO-LOCK WHERE bLkBenefits.EmpNum = pEmpNum NO-ERROR.
  pRowid = IF AVAILABLE bLkBenefits THEN ROWID(bLkBenefits) ELSE ?.
END PROCEDURE.

&ENDIF

