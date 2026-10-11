/*------------------------------------------------------------------------
    File        : st_defs.i
    Purpose     : Sales & Territories shared definitions
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2015-11  ssp  Y2K date window
 *  2003-02  rdh  new report column
 *  2011-07  mab  new report column
 *  2012-01  ssp  audit fields
 *  2000-06  ssp  audit fields
 */

/* st_defs.i : Sales & Territories shared definitions */

&GLOBAL-DEFINE MODULE-ID sales-territories
&GLOBAL-DEFINE MODULE-NAME "Sales & Territories"

DEFINE NEW GLOBAL SHARED VARIABLE gSTPeriod AS DATE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gSTSite   AS CHARACTER NO-UNDO INITIAL "HQ".

&GLOBAL-DEFINE SALESREP-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE STATE-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE LOCALDEFAULT-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE CUSTOMER-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE ORDER-LOCK EXCLUSIVE-LOCK

&GLOBAL-DEFINE SALESREP-KEY SalesRep
&GLOBAL-DEFINE SALESREP-FIELDS SalesRep RepName Region
&GLOBAL-DEFINE STATE-KEY State
&GLOBAL-DEFINE STATE-FIELDS State StateName Region
&GLOBAL-DEFINE LOCALDEFAULT-KEY LocalDefNum
&GLOBAL-DEFINE LOCALDEFAULT-FIELDS Country Region1Label Region2Label PostalLabel PostalFormat TelFormat CurrencySymbol DateFormat LocalDefNum

DEFINE NEW GLOBAL SHARED TEMP-TABLE ttModuleCtx NO-UNDO
    FIELD CtxKey   AS CHARACTER
    FIELD CtxValue AS CHARACTER
    INDEX ixKey IS PRIMARY UNIQUE CtxKey.

FUNCTION fnCtx RETURNS CHARACTER (INPUT pcKey AS CHARACTER):
  FIND ttModuleCtx WHERE ttModuleCtx.CtxKey = pcKey NO-ERROR.
  RETURN (IF AVAILABLE ttModuleCtx THEN ttModuleCtx.CtxValue ELSE "").
END FUNCTION.

