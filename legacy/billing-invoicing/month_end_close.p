/*------------------------------------------------------------------------
    File        : month_end_close.p
    Purpose     : Billing month-end close
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
    Schedule     : batch_runner.p, period end
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-03  tlw  performance: use index
 *  2009-11  tlw  remove dead code
 *  2014-09  mab  audit fields
 */

{shared/sysdefs.i}
{shared/dateutil.i}

DEFINE INPUT PARAMETER ptPeriodEnd AS DATE NO-UNDO.

DEFINE TEMP-TABLE ttSum NO-UNDO
    FIELD GroupKey AS CHARACTER
    FIELD Cnt      AS INTEGER
    FIELD Amount   AS DECIMAL
    INDEX ixKey IS PRIMARY UNIQUE GroupKey.

DEFINE VARIABLE cKey AS CHARACTER NO-UNDO.

FOR EACH Invoice NO-LOCK
    WHERE Invoice.InvoiceDate <= ptPeriodEnd:
    cKey = "Invoice|" + "ALL".
    FIND ttSum WHERE ttSum.GroupKey = cKey NO-ERROR.
    IF NOT AVAILABLE ttSum THEN DO:
        CREATE ttSum.
        ttSum.GroupKey = cKey.
    END.
    ASSIGN ttSum.Cnt = ttSum.Cnt + 1
           ttSum.Amount = ttSum.Amount + Invoice.Amount.
END.

OUTPUT TO VALUE(gLogDir + "month_end_close_" + STRING(ptPeriodEnd, "99999999") + ".log").
FOR EACH ttSum BY ttSum.GroupKey:
    PUT UNFORMATTED ttSum.GroupKey "~t" ttSum.Cnt "~t" ttSum.Amount SKIP.
END.
OUTPUT CLOSE.

PROCEDURE round-invoice-totalpaid0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bInvoice FOR Invoice.
  FIND bInvoice WHERE ROWID(bInvoice) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bInvoice THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bInvoice.TotalPaid < 0 THEN plOk = NO.
    WHEN bInvoice.TotalPaid > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Invoice.TotalPaid above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

