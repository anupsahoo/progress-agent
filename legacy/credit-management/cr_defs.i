/*------------------------------------------------------------------------
    File        : cr_defs.i
    Purpose     : Credit Management shared definitions
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-03  tlw  remove dead code
 */

/* cr_defs.i : Credit Management shared definitions */

&GLOBAL-DEFINE MODULE-ID credit-management
&GLOBAL-DEFINE MODULE-NAME "Credit Management"

DEFINE NEW GLOBAL SHARED VARIABLE gCRPeriod AS DATE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCRSite   AS CHARACTER NO-UNDO INITIAL "HQ".

&GLOBAL-DEFINE REFCALL-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE CUSTOMER-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE INVOICE-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE ORDER-LOCK EXCLUSIVE-LOCK

&GLOBAL-DEFINE REFCALL-KEY CallNum
&GLOBAL-DEFINE REFCALL-FIELDS CallNum CustNum CallDate SalesRep Parent Txt

DEFINE NEW GLOBAL SHARED TEMP-TABLE ttModuleCtx NO-UNDO
    FIELD CtxKey   AS CHARACTER
    FIELD CtxValue AS CHARACTER
    INDEX ixKey IS PRIMARY UNIQUE CtxKey.

FUNCTION fnCtx RETURNS CHARACTER (INPUT pcKey AS CHARACTER):
  FIND ttModuleCtx WHERE ttModuleCtx.CtxKey = pcKey NO-ERROR.
  RETURN (IF AVAILABLE ttModuleCtx THEN ttModuleCtx.CtxValue ELSE "").
END FUNCTION.

