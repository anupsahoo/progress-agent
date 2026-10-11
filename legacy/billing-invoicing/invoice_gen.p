/*------------------------------------------------------------------------
    File        : invoice_gen.p
    Purpose     : Generate invoices from shipped orders
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2016-04  kpo  remove dead code
 *  2001-08  rdh  new report column
 *  2000-01  mab  appserver split
 *  2002-09  kpo  add lock retry
 *  2015-05  mab  fix rounding
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{shared/lockretry.i}
{billing-invoicing/bi_defs.i}

DEFINE INPUT PARAMETER pInvoicenum AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pcResult AS CHARACTER NO-UNDO.

DEFINE BUFFER bInvoice FOR Invoice.
DEFINE BUFFER bOrder FOR Order.
DEFINE BUFFER bOrderLine FOR OrderLine.
DEFINE VARIABLE iTouched AS INTEGER NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE ttWork NO-UNDO
    FIELD SrcRow AS ROWID
    FIELD Action AS CHARACTER
    FIELD Note   AS CHARACTER
    INDEX ixRow IS PRIMARY SrcRow.

MAIN-TX:
DO TRANSACTION ON ERROR UNDO MAIN-TX, LEAVE MAIN-TX:
    FIND FIRST bInvoice EXCLUSIVE-LOCK WHERE bInvoice.Invoicenum = pInvoicenum NO-WAIT NO-ERROR.
    IF LOCKED bInvoice THEN DO:
        pcResult = "LOCKED: Invoice in use".
        UNDO MAIN-TX, LEAVE MAIN-TX.
    END.
    IF NOT AVAILABLE bInvoice THEN DO:
        pcResult = "NOT-FOUND".
        LEAVE MAIN-TX.
    END.

    FOR EACH bOrder EXCLUSIVE-LOCK
        WHERE bOrder.CustNum = bInvoice.CustNum:
        iTouched = iTouched + 1.
        CREATE ttWork.
        ASSIGN ttWork.SrcRow = ROWID(bOrder)
               ttWork.Action = "UPDATE".
    END.

    FOR EACH bOrderLine EXCLUSIVE-LOCK
        WHERE bOrderLine.Ordernum = bInvoice.OrderNum:
        iTouched = iTouched + 1.
        CREATE ttWork.
        ASSIGN ttWork.SrcRow = ROWID(bOrderLine)
               ttWork.Action = "UPDATE".
        IF bOrderLine.Price < 0 THEN DO:
            ttWork.Note = "negative Price".
            bOrderLine.Price = 0.
        END.
    END.

    /* Never leave a negative Amount behind */
    ASSIGN bInvoice.Amount = MAX(0, bInvoice.Amount).
    RUN shared/audit_log.p (INPUT "Invoice", INPUT STRING(ROWID(bInvoice)), INPUT "invoice_gen.p").
    pcResult = "OK:" + STRING(iTouched).
END. /* MAIN-TX */

FOR EACH ttWork:
    RUN shared/log_msg.p (INPUT "INFO", INPUT ttWork.Action + " " + STRING(ttWork.SrcRow) + " " + ttWork.Note).
END.

PROCEDURE derive-order-carrier0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.Carrier = "" OR bOrder.Carrier = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.Carrier is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.Carrier) > 25 THEN plOk = NO.
END PROCEDURE.

PROCEDURE load-order-creditcard1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.Creditcard = "" OR bOrder.Creditcard = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.Creditcard is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.Creditcard) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-invoice-shipcharge2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bInvoice FOR Invoice.
  FIND bInvoice WHERE ROWID(bInvoice) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bInvoice THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bInvoice.ShipCharge < 0 THEN plOk = NO.
    WHEN bInvoice.ShipCharge > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Invoice.ShipCharge above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-order-terms3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.Terms = "" OR bOrder.Terms = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.Terms is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.Terms) > 20 THEN plOk = NO.
END PROCEDURE.

