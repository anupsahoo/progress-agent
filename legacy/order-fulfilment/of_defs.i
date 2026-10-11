/*------------------------------------------------------------------------
    File        : of_defs.i
    Purpose     : Order Fulfilment shared definitions
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-06  jkm  credit hold rule
 *  2010-12  tlw  performance: use index
 *  2007-10  kpo  appserver split
 *  2006-04  jkm  performance: use index
 *  2012-06  kpo  remove dead code
 */

/* of_defs.i : Order Fulfilment shared definitions */

&GLOBAL-DEFINE MODULE-ID order-fulfilment
&GLOBAL-DEFINE MODULE-NAME "Order Fulfilment"

DEFINE NEW GLOBAL SHARED VARIABLE gOFPeriod AS DATE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gOFSite   AS CHARACTER NO-UNDO INITIAL "HQ".

&GLOBAL-DEFINE SHIPTO-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE ORDER-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE ORDERLINE-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE ITEM-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE BIN-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE WAREHOUSE-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE INVENTORYTRANS-LOCK EXCLUSIVE-LOCK

&GLOBAL-DEFINE SHIPTO-KEY CustNum ShipToID
&GLOBAL-DEFINE SHIPTO-FIELDS CustNum ShipToID Contact Address Address2 City State PostalCode Phone Comments Name

DEFINE NEW GLOBAL SHARED TEMP-TABLE ttModuleCtx NO-UNDO
    FIELD CtxKey   AS CHARACTER
    FIELD CtxValue AS CHARACTER
    INDEX ixKey IS PRIMARY UNIQUE CtxKey.

FUNCTION fnCtx RETURNS CHARACTER (INPUT pcKey AS CHARACTER):
  FIND ttModuleCtx WHERE ttModuleCtx.CtxKey = pcKey NO-ERROR.
  RETURN (IF AVAILABLE ttModuleCtx THEN ttModuleCtx.CtxValue ELSE "").
END FUNCTION.

