/*------------------------------------------------------------------------
    File        : SalesrepBE.cls
    Purpose     : business entity for Salesrep (OpenEdge 11 OO ABL)
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2012-11  rdh  new report column
 *  2004-05  tlw  new report column
 *  1999-10  rdh  remove dead code
 *  2017-12  jkm  new report column
 *  2000-02  ssp  add lock retry
 */

/* SalesrepBE.cls : business entity for Salesrep (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS ST.SalesrepBE:

  DEFINE PUBLIC PROPERTY SalesRep AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY RepName AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Region AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC SalesrepBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pSalesRep AS CHARACTER):
    FIND FIRST Salesrep NO-LOCK WHERE Salesrep.SalesRep = pSalesRep NO-ERROR.
    IF NOT AVAILABLE Salesrep THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:SalesRep = Salesrep.SalesRep
           THIS-OBJECT:RepName = Salesrep.RepName
           THIS-OBJECT:Region = Salesrep.Region
           rRow = ROWID(Salesrep) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:SalesRep = "" THEN cErr = cErr + "Sales Rep is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE Salesrep.
      ELSE FIND Salesrep WHERE ROWID(Salesrep) = rRow EXCLUSIVE-LOCK.
      ASSIGN Salesrep.SalesRep = THIS-OBJECT:SalesRep
             Salesrep.RepName = THIS-OBJECT:RepName
             Salesrep.Region = THIS-OBJECT:Region.
      rRow = ROWID(Salesrep).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND Salesrep WHERE ROWID(Salesrep) = rRow EXCLUSIVE-LOCK.
      DELETE Salesrep.
    END.
  END METHOD.

END CLASS.

