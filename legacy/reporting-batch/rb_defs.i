/*------------------------------------------------------------------------
    File        : rb_defs.i
    Purpose     : Reporting & Batch shared definitions
    Module      : Reporting & Batch
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-05  kpo  appserver split
 *  2012-09  mab  performance: use index
 *  2010-05  mab  appserver split
 *  2016-11  rdh  audit fields
 */

/* rb_defs.i : Reporting & Batch shared definitions */

&GLOBAL-DEFINE MODULE-ID reporting-batch
&GLOBAL-DEFINE MODULE-NAME "Reporting & Batch"

DEFINE NEW GLOBAL SHARED VARIABLE gRBPeriod AS DATE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gRBSite   AS CHARACTER NO-UNDO INITIAL "HQ".

&GLOBAL-DEFINE CUSTOMER-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE ORDER-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE ORDERLINE-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE INVOICE-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE ITEM-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE SALESREP-LOCK EXCLUSIVE-LOCK

DEFINE NEW GLOBAL SHARED TEMP-TABLE ttModuleCtx NO-UNDO
    FIELD CtxKey   AS CHARACTER
    FIELD CtxValue AS CHARACTER
    INDEX ixKey IS PRIMARY UNIQUE CtxKey.

FUNCTION fnCtx RETURNS CHARACTER (INPUT pcKey AS CHARACTER):
  FIND ttModuleCtx WHERE ttModuleCtx.CtxKey = pcKey NO-ERROR.
  RETURN (IF AVAILABLE ttModuleCtx THEN ttModuleCtx.CtxValue ELSE "").
END FUNCTION.

