/*------------------------------------------------------------------------
    File        : cm_defs.i
    Purpose     : Customer Management shared definitions
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2016-09  ssp  audit fields
 */

/* cm_defs.i : Customer Management shared definitions */

&GLOBAL-DEFINE MODULE-ID customer-management
&GLOBAL-DEFINE MODULE-NAME "Customer Management"

DEFINE NEW GLOBAL SHARED VARIABLE gCMPeriod AS DATE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCMSite   AS CHARACTER NO-UNDO INITIAL "HQ".

&GLOBAL-DEFINE CUSTOMER-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE FEEDBACK-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE SALESREP-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE STATE-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE SHIPTO-LOCK EXCLUSIVE-LOCK

&GLOBAL-DEFINE CUSTOMER-KEY CustNum
&GLOBAL-DEFINE CUSTOMER-FIELDS CustNum Country Name Address Address2 City State PostalCode Contact Phone SalesRep CreditLimit Balance Terms Discount Comments Fax EmailAddress
&GLOBAL-DEFINE FEEDBACK-KEY Department
&GLOBAL-DEFINE FEEDBACK-FIELDS Contact Company EmailAddress Phone Fax Comments Department Rating

DEFINE NEW GLOBAL SHARED TEMP-TABLE ttModuleCtx NO-UNDO
    FIELD CtxKey   AS CHARACTER
    FIELD CtxValue AS CHARACTER
    INDEX ixKey IS PRIMARY UNIQUE CtxKey.

FUNCTION fnCtx RETURNS CHARACTER (INPUT pcKey AS CHARACTER):
  FIND ttModuleCtx WHERE ttModuleCtx.CtxKey = pcKey NO-ERROR.
  RETURN (IF AVAILABLE ttModuleCtx THEN ttModuleCtx.CtxValue ELSE "").
END FUNCTION.

