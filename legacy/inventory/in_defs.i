/*------------------------------------------------------------------------
    File        : in_defs.i
    Purpose     : Inventory shared definitions
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2017-04  jkm  remove dead code
 *  2005-05  mab  Y2K date window
 *  2011-08  tlw  new report column
 */

/* in_defs.i : Inventory shared definitions */

&GLOBAL-DEFINE MODULE-ID inventory
&GLOBAL-DEFINE MODULE-NAME "Inventory"

DEFINE NEW GLOBAL SHARED VARIABLE gINPeriod AS DATE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gINSite   AS CHARACTER NO-UNDO INITIAL "HQ".

&GLOBAL-DEFINE ITEM-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE INVENTORYTRANS-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE BIN-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE WAREHOUSE-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE ORDERLINE-LOCK EXCLUSIVE-LOCK

&GLOBAL-DEFINE ITEM-KEY Itemnum
&GLOBAL-DEFINE ITEM-FIELDS Itemnum ItemName Price Onhand Allocated ReOrder OnOrder CatPage CatDescription Category1 Category2 Special Weight Minqty
&GLOBAL-DEFINE INVENTORYTRANS-KEY InvTransNum
&GLOBAL-DEFINE INVENTORYTRANS-FIELDS InvTransNum WarehouseNum BinNum Qty Itemnum TransDate InvType PONum Ordernum Transtime

DEFINE NEW GLOBAL SHARED TEMP-TABLE ttModuleCtx NO-UNDO
    FIELD CtxKey   AS CHARACTER
    FIELD CtxValue AS CHARACTER
    INDEX ixKey IS PRIMARY UNIQUE CtxKey.

FUNCTION fnCtx RETURNS CHARACTER (INPUT pcKey AS CHARACTER):
  FIND ttModuleCtx WHERE ttModuleCtx.CtxKey = pcKey NO-ERROR.
  RETURN (IF AVAILABLE ttModuleCtx THEN ttModuleCtx.CtxValue ELSE "").
END FUNCTION.

