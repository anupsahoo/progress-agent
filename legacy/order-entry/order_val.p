/*------------------------------------------------------------------------
    File        : order_val.p
    Purpose     : Business validation for Order
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bOrder FOR Order.

FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bOrder THEN DO:
  ASSIGN plOk = NO pcMsg = "Order record not found.".
  RETURN.
END.

/* Ordernum: ordernum > 0 */
IF NOT (bOrder.Ordernum > 0) THEN
  RUN add-error ("Order number must be greater than zero").

/* CustNum: CAN-FIND(customer OF order) */
IF NOT CAN-FIND(FIRST Customer WHERE Customer.CustNum = bOrder.CustNum) THEN
  RUN add-error ("Customer must already exist.").

IF bOrder.OrderDate <> ? AND YEAR(bOrder.OrderDate) < 1950 THEN
  RUN add-error ("Ordered is before the 1950 date window.").

IF bOrder.ShipDate <> ? AND YEAR(bOrder.ShipDate) < 1950 THEN
  RUN add-error ("Shipped is before the 1950 date window.").

IF bOrder.PromiseDate <> ? AND YEAR(bOrder.PromiseDate) < 1950 THEN
  RUN add-error ("Promised is before the 1950 date window.").

/* WarehouseNum: (warehousenum = 0) or can-find(warehouse of order) */
IF NOT CAN-FIND(FIRST Warehouse WHERE Warehouse.WarehouseNum = bOrder.WarehouseNum) THEN
  RUN add-error ("Entrer a number greater than zero").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

