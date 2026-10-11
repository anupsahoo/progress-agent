/*------------------------------------------------------------------------
    File        : po_price_calc.p
    Purpose     : Line pricing with supplier discount
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2014-03  jkm  Y2K date window
 *  2010-07  jkm  add lock retry
 *  2012-07  jkm  performance: use index
 *  2016-07  jkm  credit hold rule
 *  2004-12  ssp  add lock retry
 */

{shared/sysdefs.i}
{shared/numutil.i}

DEFINE INPUT  PARAMETER prRow    AS ROWID   NO-UNDO.
DEFINE OUTPUT PARAMETER pdResult AS DECIMAL NO-UNDO.

DEFINE BUFFER bPOLine FOR POLine.
DEFINE BUFFER bSupplier FOR Supplier.

DEFINE VARIABLE dBase   AS DECIMAL NO-UNDO.
DEFINE VARIABLE dFactor AS DECIMAL NO-UNDO INITIAL 1.
DEFINE VARIABLE i       AS INTEGER NO-UNDO.

FUNCTION fnTier RETURNS DECIMAL (INPUT pdAmt AS DECIMAL):
  IF pdAmt >= 100000 THEN RETURN 0.15.
  IF pdAmt >= 50000  THEN RETURN 0.10.
  IF pdAmt >= 10000  THEN RETURN 0.05.
  RETURN 0.
END FUNCTION.

FIND bPOLine WHERE ROWID(bPOLine) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bPOLine THEN RETURN ERROR "POLine not found".

dBase = dBase + bPOLine.Price.
dBase = dBase + 0.75 * bPOLine.Qty.
dBase = dBase + 1.00 * bPOLine.Discount.
dBase = dBase + 1.25 * bPOLine.ExtendedPrice.

pdResult = ROUND(dBase * dFactor * (1 - fnTier(dBase)), 2).
IF pdResult < 0 THEN pdResult = 0.

PROCEDURE calc-poline-price0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPOLine FOR POLine.
  FIND bPOLine WHERE ROWID(bPOLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPOLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bPOLine.Price < 0 THEN plOk = NO.
    WHEN bPOLine.Price > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "POLine.Price above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-poline-price1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPOLine FOR POLine.
  FIND bPOLine WHERE ROWID(bPOLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPOLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bPOLine.Price < 0 THEN plOk = NO.
    WHEN bPOLine.Price > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "POLine.Price above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-supplier-shipamount2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.ShipAmount < 0 THEN plOk = NO.
    WHEN bSupplier.ShipAmount > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.ShipAmount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-poline-extendedprice3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPOLine FOR POLine.
  FIND bPOLine WHERE ROWID(bPOLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPOLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bPOLine.ExtendedPrice < 0 THEN plOk = NO.
    WHEN bPOLine.ExtendedPrice > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "POLine.ExtendedPrice above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-poline-qty4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPOLine FOR POLine.
  FIND bPOLine WHERE ROWID(bPOLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPOLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bPOLine.Qty < 0 THEN plOk = NO.
    WHEN bPOLine.Qty > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "POLine.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-supplier-shipamount5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.ShipAmount < 0 THEN plOk = NO.
    WHEN bSupplier.ShipAmount > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.ShipAmount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-poline-extendedprice6 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPOLine FOR POLine.
  FIND bPOLine WHERE ROWID(bPOLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPOLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bPOLine.ExtendedPrice < 0 THEN plOk = NO.
    WHEN bPOLine.ExtendedPrice > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "POLine.ExtendedPrice above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

