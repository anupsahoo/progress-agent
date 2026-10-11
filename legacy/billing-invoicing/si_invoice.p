/*------------------------------------------------------------------------
    File        : si_invoice.p
    Purpose     : AppServer service interface for Invoice
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

{billing-invoicing/tt_invoice.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsInvoice.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcInvoice FOR Invoice.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttInvoice:ATTACH-DATA-SOURCE(DATA-SOURCE srcInvoice:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcInvoice:FILL-WHERE-STRING = pcWhere.
    DATASET dsInvoice:FILL().
    BUFFER ttInvoice:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttInvoice:ATTACH-DATA-SOURCE(DATA-SOURCE srcInvoice:HANDLE).
    FOR EACH btInvoice:
      BUFFER btInvoice:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btInvoice:ERROR THEN pcError = pcError + BUFFER btInvoice:ERROR-STRING + "~n".
    END.
    BUFFER ttInvoice:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttInvoice:
      FIND FIRST Invoice EXCLUSIVE-LOCK WHERE Invoice.Invoicenum = ttInvoice.Invoicenum NO-WAIT NO-ERROR.
      IF LOCKED Invoice THEN DO:
        pcError = pcError + "Invoice is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE Invoice THEN DELETE Invoice.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER Invoice:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH Invoice NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_invoice " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

