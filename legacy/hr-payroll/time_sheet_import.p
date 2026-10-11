/*------------------------------------------------------------------------
    File        : time_sheet_import.p
    Purpose     : Import TimeSheet from CSV with upsert
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

{hr-payroll/tt_time_sheet.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttTimeSheet.
    IMPORT DELIMITER "," ttTimeSheet.EmpNum ttTimeSheet.DayRecorded ttTimeSheet.TypeRecorded ttTimeSheet.AMTimeIn ttTimeSheet.AMTimeOut ttTimeSheet.PMTimeIn ttTimeSheet.PMTimeOut ttTimeSheet.RegularHours ttTimeSheet.OvertimeHours NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttTimeSheet.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttTimeSheet:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST TimeSheet EXCLUSIVE-LOCK WHERE TimeSheet.EmpNum = ttTimeSheet.EmpNum AND TimeSheet.DayRecorded = ttTimeSheet.DayRecorded NO-ERROR.
        IF NOT AVAILABLE TimeSheet THEN CREATE TimeSheet.
        BUFFER-COPY ttTimeSheet EXCEPT RowState ErrorMsg TO TimeSheet.
        RUN hr-payroll/time_sheet_val.p (INPUT ROWID(TimeSheet), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

