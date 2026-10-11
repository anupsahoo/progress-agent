/*------------------------------------------------------------------------
    File        : salesrep_lookup.i
    Purpose     : Salesrep lookup helpers. {&NO-SALESREP-FUNCS} suppresses the functions.
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-09  mab  appserver split
 *  2008-06  jkm  fix rounding
 *  2010-02  tlw  credit hold rule
 *  1999-07  mab  credit hold rule
 *  2001-08  rdh  audit fields
 */

/* salesrep_lookup.i : Salesrep lookup helpers. {&NO-SALESREP-FUNCS} suppresses the functions. */

&IF DEFINED(SALESREP_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE SALESREP_LOOKUP_I YES

DEFINE BUFFER bLkSalesrep FOR Salesrep.

FUNCTION SalesrepExists RETURNS LOGICAL (INPUT pSalesRep AS CHARACTER):
  RETURN CAN-FIND(FIRST bLkSalesrep WHERE bLkSalesrep.SalesRep = pSalesRep).
END FUNCTION.

FUNCTION SalesrepDesc RETURNS CHARACTER (INPUT pSalesRep AS CHARACTER):
  FIND FIRST bLkSalesrep NO-LOCK WHERE bLkSalesrep.SalesRep = pSalesRep NO-ERROR.
  RETURN (IF AVAILABLE bLkSalesrep THEN bLkSalesrep.RepName ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-salesrep :
  DEFINE INPUT  PARAMETER pSalesRep AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkSalesrep NO-LOCK WHERE bLkSalesrep.SalesRep = pSalesRep NO-ERROR.
  pRowid = IF AVAILABLE bLkSalesrep THEN ROWID(bLkSalesrep) ELSE ?.
END PROCEDURE.

&ENDIF

