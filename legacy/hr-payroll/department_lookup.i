/*------------------------------------------------------------------------
    File        : department_lookup.i
    Purpose     : Department lookup helpers. {&NO-DEPARTMENT-FUNCS} suppresses the functions.
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2015-11  kpo  fix rounding
 *  2009-05  rdh  credit hold rule
 *  2006-05  tlw  fix rounding
 *  2014-07  kpo  performance: use index
 */

/* department_lookup.i : Department lookup helpers. {&NO-DEPARTMENT-FUNCS} suppresses the functions. */

&IF DEFINED(DEPARTMENT_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE DEPARTMENT_LOOKUP_I YES

DEFINE BUFFER bLkDepartment FOR Department.

FUNCTION DepartmentExists RETURNS LOGICAL (INPUT pDeptCode AS CHARACTER):
  RETURN CAN-FIND(FIRST bLkDepartment WHERE bLkDepartment.DeptCode = pDeptCode).
END FUNCTION.

FUNCTION DepartmentDesc RETURNS CHARACTER (INPUT pDeptCode AS CHARACTER):
  FIND FIRST bLkDepartment NO-LOCK WHERE bLkDepartment.DeptCode = pDeptCode NO-ERROR.
  RETURN (IF AVAILABLE bLkDepartment THEN bLkDepartment.DeptName ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-department :
  DEFINE INPUT  PARAMETER pDeptCode AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkDepartment NO-LOCK WHERE bLkDepartment.DeptCode = pDeptCode NO-ERROR.
  pRowid = IF AVAILABLE bLkDepartment THEN ROWID(bLkDepartment) ELSE ?.
END PROCEDURE.

&ENDIF

