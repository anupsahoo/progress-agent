/*------------------------------------------------------------------------
    File        : wh_defs.i
    Purpose     : Warehousing shared definitions
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2017-06  ssp  remove dead code
 */

/* wh_defs.i : Warehousing shared definitions */

&GLOBAL-DEFINE MODULE-ID warehousing
&GLOBAL-DEFINE MODULE-NAME "Warehousing"

DEFINE NEW GLOBAL SHARED VARIABLE gWHPeriod AS DATE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gWHSite   AS CHARACTER NO-UNDO INITIAL "HQ".

&GLOBAL-DEFINE WAREHOUSE-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE BIN-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE ITEM-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE INVENTORYTRANS-LOCK EXCLUSIVE-LOCK

&GLOBAL-DEFINE WAREHOUSE-KEY WarehouseNum
&GLOBAL-DEFINE WAREHOUSE-FIELDS WarehouseNum WarehouseName Country Address Address2 City State PostalCode Phone
&GLOBAL-DEFINE BIN-KEY BinNum
&GLOBAL-DEFINE BIN-FIELDS WarehouseNum Itemnum Qty BinNum BinName

DEFINE NEW GLOBAL SHARED TEMP-TABLE ttModuleCtx NO-UNDO
    FIELD CtxKey   AS CHARACTER
    FIELD CtxValue AS CHARACTER
    INDEX ixKey IS PRIMARY UNIQUE CtxKey.

FUNCTION fnCtx RETURNS CHARACTER (INPUT pcKey AS CHARACTER):
  FIND ttModuleCtx WHERE ttModuleCtx.CtxKey = pcKey NO-ERROR.
  RETURN (IF AVAILABLE ttModuleCtx THEN ttModuleCtx.CtxValue ELSE "").
END FUNCTION.

