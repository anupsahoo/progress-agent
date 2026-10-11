/*------------------------------------------------------------------------
    File        : sm_defs.i
    Purpose     : Supplier Management shared definitions
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2001-07  rdh  credit hold rule
 *  2015-04  jkm  appserver split
 *  2006-09  ssp  audit fields
 *  2010-01  rdh  remove dead code
 */

/* sm_defs.i : Supplier Management shared definitions */

&GLOBAL-DEFINE MODULE-ID supplier-management
&GLOBAL-DEFINE MODULE-NAME "Supplier Management"

DEFINE NEW GLOBAL SHARED VARIABLE gSMPeriod AS DATE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gSMSite   AS CHARACTER NO-UNDO INITIAL "HQ".

&GLOBAL-DEFINE SUPPLIER-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE SUPPLIERITEMXREF-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE ITEM-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE PURCHASEORDER-LOCK EXCLUSIVE-LOCK

&GLOBAL-DEFINE SUPPLIER-KEY SupplierIDNum
&GLOBAL-DEFINE SUPPLIER-FIELDS SupplierIDNum Name Address Address2 City State PostalCode Country Phone Comments Password LoginDate ShipAmount Discount
&GLOBAL-DEFINE SUPPLIERITEMXREF-KEY SupplierIDNum Itemnum
&GLOBAL-DEFINE SUPPLIERITEMXREF-FIELDS SupplierIDNum Itemnum

DEFINE NEW GLOBAL SHARED TEMP-TABLE ttModuleCtx NO-UNDO
    FIELD CtxKey   AS CHARACTER
    FIELD CtxValue AS CHARACTER
    INDEX ixKey IS PRIMARY UNIQUE CtxKey.

FUNCTION fnCtx RETURNS CHARACTER (INPUT pcKey AS CHARACTER):
  FIND ttModuleCtx WHERE ttModuleCtx.CtxKey = pcKey NO-ERROR.
  RETURN (IF AVAILABLE ttModuleCtx THEN ttModuleCtx.CtxValue ELSE "").
END FUNCTION.

