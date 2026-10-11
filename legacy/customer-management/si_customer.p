/*------------------------------------------------------------------------
    File        : si_customer.p
    Purpose     : AppServer service interface for Customer
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

{customer-management/tt_customer.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsCustomer.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcCustomer FOR Customer.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttCustomer:ATTACH-DATA-SOURCE(DATA-SOURCE srcCustomer:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcCustomer:FILL-WHERE-STRING = pcWhere.
    DATASET dsCustomer:FILL().
    BUFFER ttCustomer:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttCustomer:ATTACH-DATA-SOURCE(DATA-SOURCE srcCustomer:HANDLE).
    FOR EACH btCustomer:
      BUFFER btCustomer:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btCustomer:ERROR THEN pcError = pcError + BUFFER btCustomer:ERROR-STRING + "~n".
    END.
    BUFFER ttCustomer:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttCustomer:
      FIND FIRST Customer EXCLUSIVE-LOCK WHERE Customer.CustNum = ttCustomer.CustNum NO-WAIT NO-ERROR.
      IF LOCKED Customer THEN DO:
        pcError = pcError + "Customer is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE Customer THEN DELETE Customer.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER Customer:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH Customer NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_customer " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

