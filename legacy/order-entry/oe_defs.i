/*------------------------------------------------------------------------
    File        : oe_defs.i
    Purpose     : Order Entry shared definitions
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2011-06  tlw  add lock retry
 *  2000-02  mab  credit hold rule
 */

/* oe_defs.i : Order Entry shared definitions */

&GLOBAL-DEFINE MODULE-ID order-entry
&GLOBAL-DEFINE MODULE-NAME "Order Entry"

DEFINE NEW GLOBAL SHARED VARIABLE gOEPeriod AS DATE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gOESite   AS CHARACTER NO-UNDO INITIAL "HQ".

&GLOBAL-DEFINE ORDER-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE ORDERLINE-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE CUSTOMER-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE ITEM-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE SALESREP-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE SHIPTO-LOCK EXCLUSIVE-LOCK

&GLOBAL-DEFINE ORDER-KEY Ordernum
&GLOBAL-DEFINE ORDER-FIELDS Ordernum CustNum OrderDate ShipDate PromiseDate Carrier Instructions PO Terms SalesRep BillToID ShipToID OrderStatus WarehouseNum Creditcard
&GLOBAL-DEFINE ORDERLINE-KEY Ordernum Linenum
&GLOBAL-DEFINE ORDERLINE-FIELDS Ordernum Linenum Itemnum Price Qty Discount ExtendedPrice OrderLineStatus

DEFINE NEW GLOBAL SHARED TEMP-TABLE ttModuleCtx NO-UNDO
    FIELD CtxKey   AS CHARACTER
    FIELD CtxValue AS CHARACTER
    INDEX ixKey IS PRIMARY UNIQUE CtxKey.

FUNCTION fnCtx RETURNS CHARACTER (INPUT pcKey AS CHARACTER):
  FIND ttModuleCtx WHERE ttModuleCtx.CtxKey = pcKey NO-ERROR.
  RETURN (IF AVAILABLE ttModuleCtx THEN ttModuleCtx.CtxValue ELSE "").
END FUNCTION.

