/*------------------------------------------------------------------------
    File        : backorder_release.p
    Purpose     : Release back orders when stock arrives
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
    Schedule     : batch_runner.p, period end
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-02  jkm  appserver split
 *  2010-08  tlw  add lock retry
 *  2005-05  tlw  credit hold rule
 *  2003-06  rdh  appserver split
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

FOR EACH OrderLine NO-LOCK:
    cKey = "OrderLine|" + STRING(OrderLine.OrderLineStatus).
    FIND ttSum WHERE ttSum.GroupKey = cKey NO-ERROR.
    IF NOT AVAILABLE ttSum THEN DO:
        CREATE ttSum.
        ttSum.GroupKey = cKey.
    END.
    ASSIGN ttSum.Cnt = ttSum.Cnt + 1
           ttSum.Amount = ttSum.Amount + OrderLine.Price.
END.

FOR EACH Item NO-LOCK:
    cKey = "Item|" + STRING(Item.ItemName).
    FIND ttSum WHERE ttSum.GroupKey = cKey NO-ERROR.
    IF NOT AVAILABLE ttSum THEN DO:
        CREATE ttSum.
        ttSum.GroupKey = cKey.
    END.
    ASSIGN ttSum.Cnt = ttSum.Cnt + 1
           ttSum.Amount = ttSum.Amount + Item.Price.
END.

OUTPUT TO VALUE(gLogDir + "backorder_release_" + STRING(ptPeriodEnd, "99999999") + ".log").
FOR EACH ttSum BY ttSum.GroupKey:
    PUT UNFORMATTED ttSum.GroupKey "~t" ttSum.Cnt "~t" ttSum.Amount SKIP.
END.
OUTPUT CLOSE.

PROCEDURE apply-item-catpage0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.CatPage < 0 THEN plOk = NO.
    WHEN bItem.CatPage > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.CatPage above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-order-line-discount1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrderLine FOR OrderLine.
  FIND bOrderLine WHERE ROWID(bOrderLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrderLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bOrderLine.Discount < 0 THEN plOk = NO.
    WHEN bOrderLine.Discount > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

