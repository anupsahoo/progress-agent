/*------------------------------------------------------------------------
    File        : si_bill_to.p
    Purpose     : AppServer service interface for BillTo
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

{billing-invoicing/tt_bill_to.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsBillTo.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcBillTo FOR BillTo.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttBillTo:ATTACH-DATA-SOURCE(DATA-SOURCE srcBillTo:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcBillTo:FILL-WHERE-STRING = pcWhere.
    DATASET dsBillTo:FILL().
    BUFFER ttBillTo:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttBillTo:ATTACH-DATA-SOURCE(DATA-SOURCE srcBillTo:HANDLE).
    FOR EACH btBillTo:
      BUFFER btBillTo:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btBillTo:ERROR THEN pcError = pcError + BUFFER btBillTo:ERROR-STRING + "~n".
    END.
    BUFFER ttBillTo:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttBillTo:
      FIND FIRST BillTo EXCLUSIVE-LOCK WHERE BillTo.CustNum = ttBillTo.CustNum AND BillTo.BillToID = ttBillTo.BillToID NO-WAIT NO-ERROR.
      IF LOCKED BillTo THEN DO:
        pcError = pcError + "BillTo is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE BillTo THEN DELETE BillTo.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER BillTo:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH BillTo NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_bill_to " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

