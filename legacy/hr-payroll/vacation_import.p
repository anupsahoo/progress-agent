/*------------------------------------------------------------------------
    File        : vacation_import.p
    Purpose     : Import Vacation from CSV with upsert
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

{hr-payroll/tt_vacation.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttVacation.
    IMPORT DELIMITER "," ttVacation.EmpNum ttVacation.StartDate ttVacation.EndDate NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttVacation.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttVacation:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST Vacation EXCLUSIVE-LOCK WHERE Vacation.EmpNum = ttVacation.EmpNum AND Vacation.StartDate = ttVacation.StartDate NO-ERROR.
        IF NOT AVAILABLE Vacation THEN CREATE Vacation.
        BUFFER-COPY ttVacation EXCEPT RowState ErrorMsg TO Vacation.
        RUN hr-payroll/vacation_val.p (INPUT ROWID(Vacation), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

