/*------------------------------------------------------------------------
    File        : department_import.p
    Purpose     : Import Department from CSV with upsert
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

{hr-payroll/tt_department.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttDepartment.
    IMPORT DELIMITER "," ttDepartment.DeptCode ttDepartment.DeptName NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttDepartment.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttDepartment:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST Department EXCLUSIVE-LOCK WHERE Department.DeptCode = ttDepartment.DeptCode NO-ERROR.
        IF NOT AVAILABLE Department THEN CREATE Department.
        BUFFER-COPY ttDepartment EXCEPT RowState ErrorMsg TO Department.
        RUN hr-payroll/department_val.p (INPUT ROWID(Department), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

