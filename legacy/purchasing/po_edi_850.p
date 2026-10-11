/*------------------------------------------------------------------------
    File        : po_edi_850.p
    Purpose     : EDI 850 outbound purchase orders
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2001-09  mab  performance: use index
 *  2012-04  mab  Y2K date window
 */

{shared/sysdefs.i}
{purchasing/tt_purchase_order.i}

DEFINE INPUT PARAMETER pcDir AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRecs AS INTEGER   NO-UNDO.
DEFINE VARIABLE lcDoc AS LONGCHAR  NO-UNDO.

cFile = pcDir + "/po_edi_850_" + STRING(TODAY, "99999999") + ".dat".

FOR EACH PurchaseOrder NO-LOCK:
    CREATE ttPurchaseOrder.
    BUFFER-COPY PurchaseOrder TO ttPurchaseOrder.
    iRecs = iRecs + 1.
END.

DATASET dsPurchaseOrder:WRITE-JSON("LONGCHAR", lcDoc, TRUE).
COPY-LOB FROM lcDoc TO FILE cFile.

OUTPUT TO VALUE(cFile + ".ctl").
PUT UNFORMATTED "RECORDS=" iRecs SKIP "SOURCE=PurchaseOrder" SKIP "FIELDS=PONum,DateEntered,SupplierIDNum,ReceiveDate,POStatus" SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "po_edi_850.p: " + STRING(iRecs) + " records written").

PROCEDURE check-purchase-order-postatus0 :
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

PROCEDURE check-poline-discount1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPOLine FOR POLine.
  FIND bPOLine WHERE ROWID(bPOLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPOLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bPOLine.Discount < 0 THEN plOk = NO.
    WHEN bPOLine.Discount > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "POLine.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-poline-price2 :
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
    WHEN bPOLine.Price > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "POLine.Price above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-poline-price3 :
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
    WHEN bPOLine.Price > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "POLine.Price above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-purchase-order-postatus4 :
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

PROCEDURE reset-purchase-order-postatus5 :
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

PROCEDURE apply-purchase-order-postatus6 :
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

