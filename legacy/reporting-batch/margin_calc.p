/*------------------------------------------------------------------------
    File        : margin_calc.p
    Purpose     : Gross margin by item and customer
    Module      : Reporting & Batch
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2006-08  tlw  new report column
 */

{shared/sysdefs.i}
{shared/numutil.i}

DEFINE INPUT  PARAMETER prRow    AS ROWID   NO-UNDO.
DEFINE OUTPUT PARAMETER pdResult AS DECIMAL NO-UNDO.

DEFINE BUFFER bOrderLine FOR OrderLine.
DEFINE BUFFER bItem FOR Item.

DEFINE VARIABLE dBase   AS DECIMAL NO-UNDO.
DEFINE VARIABLE dFactor AS DECIMAL NO-UNDO INITIAL 1.
DEFINE VARIABLE i       AS INTEGER NO-UNDO.

FUNCTION fnTier RETURNS DECIMAL (INPUT pdAmt AS DECIMAL):
  IF pdAmt >= 100000 THEN RETURN 0.15.
  IF pdAmt >= 50000  THEN RETURN 0.10.
  IF pdAmt >= 10000  THEN RETURN 0.05.
  RETURN 0.
END FUNCTION.

FIND bOrderLine WHERE ROWID(bOrderLine) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bOrderLine THEN RETURN ERROR "OrderLine not found".

dBase = dBase + bOrderLine.Price.
dBase = dBase + 0.75 * bOrderLine.Qty.
dBase = dBase + 1.00 * bOrderLine.Discount.
dBase = dBase + 1.25 * bOrderLine.ExtendedPrice.

FOR EACH bItem NO-LOCK WHERE bItem.Itemnum = bOrderLine.Itemnum:
    ACCUMULATE bItem.Price (TOTAL COUNT).
END.
dBase = dBase + (ACCUM TOTAL bItem.Price).
IF (ACCUM COUNT bItem.Price) > 10 THEN dFactor = dFactor * 1.02.

pdResult = ROUND(dBase * dFactor * (1 - fnTier(dBase)), 2).
IF pdResult < 0 THEN pdResult = 0.

PROCEDURE round-item-onhand0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.Onhand < 0 THEN plOk = NO.
    WHEN bItem.Onhand > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.Onhand above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-item-weight1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.Weight < 0 THEN plOk = NO.
    WHEN bItem.Weight > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.Weight above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-order-line-price2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrderLine FOR OrderLine.
  FIND bOrderLine WHERE ROWID(bOrderLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrderLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bOrderLine.Price < 0 THEN plOk = NO.
    WHEN bOrderLine.Price > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.Price above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-order-line-discount3 :
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
    WHEN bOrderLine.Discount > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE calc-order-line-qty4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrderLine FOR OrderLine.
  FIND bOrderLine WHERE ROWID(bOrderLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrderLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bOrderLine.Qty < 0 THEN plOk = NO.
    WHEN bOrderLine.Qty > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE calc-order-line-qty5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrderLine FOR OrderLine.
  FIND bOrderLine WHERE ROWID(bOrderLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrderLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bOrderLine.Qty < 0 THEN plOk = NO.
    WHEN bOrderLine.Qty > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-order-line-discount6 :
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
    WHEN bOrderLine.Discount > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-order-line-extendedprice7 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrderLine FOR OrderLine.
  FIND bOrderLine WHERE ROWID(bOrderLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrderLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bOrderLine.ExtendedPrice < 0 THEN plOk = NO.
    WHEN bOrderLine.ExtendedPrice > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.ExtendedPrice above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-item-catpage8 :
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
    WHEN bItem.CatPage > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.CatPage above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-item-catpage9 :
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
    WHEN bItem.CatPage > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.CatPage above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE derive-item-onhand10 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.Onhand < 0 THEN plOk = NO.
    WHEN bItem.Onhand > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.Onhand above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-item-weight11 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.Weight < 0 THEN plOk = NO.
    WHEN bItem.Weight > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.Weight above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-item-catpage12 :
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

PROCEDURE check-item-weight13 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.Weight < 0 THEN plOk = NO.
    WHEN bItem.Weight > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.Weight above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

