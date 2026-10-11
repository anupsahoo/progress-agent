/*------------------------------------------------------------------------
    File        : eom_batch_driver.p
    Purpose     : End-of-month batch driver
    Module      : Reporting & Batch
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
    Schedule     : batch_runner.p, period end
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-07  tlw  audit fields
 *  2006-05  rdh  Y2K date window
 *  2013-07  mab  performance: use index
 *  2004-08  rdh  remove dead code
 *  2000-03  mab  performance: use index
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

FOR EACH Customer NO-LOCK:
    cKey = "Customer|" + STRING(Customer.Country).
    FIND ttSum WHERE ttSum.GroupKey = cKey NO-ERROR.
    IF NOT AVAILABLE ttSum THEN DO:
        CREATE ttSum.
        ttSum.GroupKey = cKey.
    END.
    ASSIGN ttSum.Cnt = ttSum.Cnt + 1
           ttSum.Amount = ttSum.Amount + Customer.CreditLimit.
END.

OUTPUT TO VALUE(gLogDir + "eom_batch_driver_" + STRING(ptPeriodEnd, "99999999") + ".log").
FOR EACH ttSum BY ttSum.GroupKey:
    PUT UNFORMATTED ttSum.GroupKey "~t" ttSum.Cnt "~t" ttSum.Amount SKIP.
END.
OUTPUT CLOSE.

PROCEDURE round-customer-balance0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bCustomer FOR Customer.
  FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bCustomer THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bCustomer.Balance < 0 THEN plOk = NO.
    WHEN bCustomer.Balance > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.Balance above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

