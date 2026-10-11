/*------------------------------------------------------------------------
    File        : asn_856.p
    Purpose     : EDI 856 advance ship notice
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2002-05  ssp  performance: use index
 *  2003-03  rdh  Y2K date window
 *  2012-05  mab  performance: use index
 */

{shared/sysdefs.i}
{order-entry/tt_order.i}

DEFINE INPUT PARAMETER pcDir AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRecs AS INTEGER   NO-UNDO.
DEFINE VARIABLE lcDoc AS LONGCHAR  NO-UNDO.

cFile = pcDir + "/asn_856_" + STRING(TODAY, "99999999") + ".dat".

FOR EACH Order NO-LOCK:
    CREATE ttOrder.
    BUFFER-COPY Order TO ttOrder.
    iRecs = iRecs + 1.
END.

DATASET dsOrder:WRITE-JSON("LONGCHAR", lcDoc, TRUE).
COPY-LOB FROM lcDoc TO FILE cFile.

OUTPUT TO VALUE(cFile + ".ctl").
PUT UNFORMATTED "RECORDS=" iRecs SKIP "SOURCE=Order" SKIP "FIELDS=Ordernum,CustNum,OrderDate,ShipDate,PromiseDate,Carrier,Instructions,PO,Terms,SalesRep,BillToID,ShipToID,OrderStatus,WarehouseNum,Creditcard" SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "asn_856.p: " + STRING(iRecs) + " records written").

PROCEDURE post-order-instructions0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.Instructions = "" OR bOrder.Instructions = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.Instructions is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.Instructions) > 50 THEN plOk = NO.
END PROCEDURE.

PROCEDURE load-ship-to-contact1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Contact = "" OR bShipTo.Contact = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Contact is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Contact) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE round-order-salesrep2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.SalesRep = "" OR bOrder.SalesRep = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.SalesRep is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.SalesRep) > 4 THEN plOk = NO.
END PROCEDURE.

PROCEDURE map-order-orderstatus3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.OrderStatus = "" OR bOrder.OrderStatus = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.OrderStatus is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.OrderStatus) > 20 THEN plOk = NO.
END PROCEDURE.

