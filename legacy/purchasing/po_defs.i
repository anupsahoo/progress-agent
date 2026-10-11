/*------------------------------------------------------------------------
    File        : po_defs.i
    Purpose     : Purchasing shared definitions
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2014-08  mab  new report column
 *  2014-01  kpo  credit hold rule
 *  2008-03  jkm  performance: use index
 *  2003-11  ssp  remove dead code
 *  1999-09  tlw  performance: use index
 */

/* po_defs.i : Purchasing shared definitions */

&GLOBAL-DEFINE MODULE-ID purchasing
&GLOBAL-DEFINE MODULE-NAME "Purchasing"

DEFINE NEW GLOBAL SHARED VARIABLE gPOPeriod AS DATE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gPOSite   AS CHARACTER NO-UNDO INITIAL "HQ".

&GLOBAL-DEFINE PURCHASEORDER-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE POLINE-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE SUPPLIER-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE ITEM-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE INVENTORYTRANS-LOCK EXCLUSIVE-LOCK

&GLOBAL-DEFINE PURCHASEORDER-KEY PONum
&GLOBAL-DEFINE PURCHASEORDER-FIELDS PONum DateEntered SupplierIDNum ReceiveDate POStatus
&GLOBAL-DEFINE POLINE-KEY PONum Linenum
&GLOBAL-DEFINE POLINE-FIELDS Linenum Itemnum Price Qty Discount ExtendedPrice PONum POLineStatus

DEFINE NEW GLOBAL SHARED TEMP-TABLE ttModuleCtx NO-UNDO
    FIELD CtxKey   AS CHARACTER
    FIELD CtxValue AS CHARACTER
    INDEX ixKey IS PRIMARY UNIQUE CtxKey.

FUNCTION fnCtx RETURNS CHARACTER (INPUT pcKey AS CHARACTER):
  FIND ttModuleCtx WHERE ttModuleCtx.CtxKey = pcKey NO-ERROR.
  RETURN (IF AVAILABLE ttModuleCtx THEN ttModuleCtx.CtxValue ELSE "").
END FUNCTION.

