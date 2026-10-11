/*------------------------------------------------------------------------
    File        : employee_import.p
    Purpose     : Import Employee from CSV with upsert
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

{hr-payroll/tt_employee.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttEmployee.
    IMPORT DELIMITER "," ttEmployee.EmpNum ttEmployee.LastName ttEmployee.FirstName ttEmployee.Address ttEmployee.Address2 ttEmployee.City ttEmployee.State ttEmployee.PostalCode ttEmployee.HomePhone ttEmployee.WorkPhone ttEmployee.DeptCode ttEmployee.Position ttEmployee.Birthdate ttEmployee.StartDate ttEmployee.VacationDaysLeft ttEmployee.SickDaysLeft NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttEmployee.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttEmployee:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST Employee EXCLUSIVE-LOCK WHERE Employee.EmpNum = ttEmployee.EmpNum NO-ERROR.
        IF NOT AVAILABLE Employee THEN CREATE Employee.
        BUFFER-COPY ttEmployee EXCEPT RowState ErrorMsg TO Employee.
        RUN hr-payroll/employee_val.p (INPUT ROWID(Employee), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

