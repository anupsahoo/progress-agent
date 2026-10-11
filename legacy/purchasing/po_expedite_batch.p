/*------------------------------------------------------------------------
    File        : po_expedite_batch.p
    Purpose     : Daily overdue PO expedite list
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
    Schedule     : batch_runner.p, period end
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-10  tlw  remove dead code
 *  2010-11  rdh  appserver split
 *  2013-04  kpo  new report column
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

FOR EACH PurchaseOrder NO-LOCK
    WHERE PurchaseOrder.DateEntered <= ptPeriodEnd:
    cKey = "PurchaseOrder|" + STRING(PurchaseOrder.POStatus).
    FIND ttSum WHERE ttSum.GroupKey = cKey NO-ERROR.
    IF NOT AVAILABLE ttSum THEN DO:
        CREATE ttSum.
        ttSum.GroupKey = cKey.
    END.
    ASSIGN ttSum.Cnt = ttSum.Cnt + 1.
END.

OUTPUT TO VALUE(gLogDir + "po_expedite_batch_" + STRING(ptPeriodEnd, "99999999") + ".log").
FOR EACH ttSum BY ttSum.GroupKey:
    PUT UNFORMATTED ttSum.GroupKey "~t" ttSum.Cnt "~t" ttSum.Amount SKIP.
END.
OUTPUT CLOSE.

PROCEDURE reset-purchase-order-postatus0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPurchaseOrder FOR PurchaseOrder.
  FIND bPurchaseOrder WHERE ROWID(bPurchaseOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPurchaseOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bPurchaseOrder.POStatus = "" OR bPurchaseOrder.POStatus = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "PurchaseOrder.POStatus is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bPurchaseOrder.POStatus) > 20 THEN plOk = NO.
END PROCEDURE.

