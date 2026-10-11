/*------------------------------------------------------------------------
    File        : employee_lookup.i
    Purpose     : Employee lookup helpers. {&NO-EMPLOYEE-FUNCS} suppresses the functions.
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-04  tlw  Y2K date window
 *  2009-11  tlw  credit hold rule
 *  2000-12  jkm  remove dead code
 *  2016-06  mab  appserver split
 *  2016-10  rdh  credit hold rule
 */

/* employee_lookup.i : Employee lookup helpers. {&NO-EMPLOYEE-FUNCS} suppresses the functions. */

&IF DEFINED(EMPLOYEE_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE EMPLOYEE_LOOKUP_I YES

DEFINE BUFFER bLkEmployee FOR Employee.

FUNCTION EmployeeExists RETURNS LOGICAL (INPUT pEmpNum AS INTEGER):
  RETURN CAN-FIND(FIRST bLkEmployee WHERE bLkEmployee.EmpNum = pEmpNum).
END FUNCTION.

FUNCTION EmployeeDesc RETURNS CHARACTER (INPUT pEmpNum AS INTEGER):
  FIND FIRST bLkEmployee NO-LOCK WHERE bLkEmployee.EmpNum = pEmpNum NO-ERROR.
  RETURN (IF AVAILABLE bLkEmployee THEN bLkEmployee.LastName ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-employee :
  DEFINE INPUT  PARAMETER pEmpNum AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkEmployee NO-LOCK WHERE bLkEmployee.EmpNum = pEmpNum NO-ERROR.
  pRowid = IF AVAILABLE bLkEmployee THEN ROWID(bLkEmployee) ELSE ?.
END PROCEDURE.

&ENDIF

