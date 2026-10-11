/*------------------------------------------------------------------------
    File        : si_time_sheet.p
    Purpose     : AppServer service interface for TimeSheet
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

{hr-payroll/tt_time_sheet.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsTimeSheet.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcTimeSheet FOR TimeSheet.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttTimeSheet:ATTACH-DATA-SOURCE(DATA-SOURCE srcTimeSheet:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcTimeSheet:FILL-WHERE-STRING = pcWhere.
    DATASET dsTimeSheet:FILL().
    BUFFER ttTimeSheet:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttTimeSheet:ATTACH-DATA-SOURCE(DATA-SOURCE srcTimeSheet:HANDLE).
    FOR EACH btTimeSheet:
      BUFFER btTimeSheet:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btTimeSheet:ERROR THEN pcError = pcError + BUFFER btTimeSheet:ERROR-STRING + "~n".
    END.
    BUFFER ttTimeSheet:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttTimeSheet:
      FIND FIRST TimeSheet EXCLUSIVE-LOCK WHERE TimeSheet.EmpNum = ttTimeSheet.EmpNum AND TimeSheet.DayRecorded = ttTimeSheet.DayRecorded NO-WAIT NO-ERROR.
      IF LOCKED TimeSheet THEN DO:
        pcError = pcError + "TimeSheet is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE TimeSheet THEN DELETE TimeSheet.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER TimeSheet:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH TimeSheet NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_time_sheet " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

