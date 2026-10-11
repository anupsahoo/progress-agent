/*------------------------------------------------------------------------
    File        : RefCallBE.cls
    Purpose     : business entity for RefCall (OpenEdge 11 OO ABL)
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2008-02  rdh  add lock retry
 *  2006-02  tlw  credit hold rule
 */

/* RefCallBE.cls : business entity for RefCall (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS CR.RefCallBE:

  DEFINE PUBLIC PROPERTY CallNum AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY CustNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY CallDate AS DATE NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY SalesRep AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Parent AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Txt AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC RefCallBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pCallNum AS CHARACTER):
    FIND FIRST RefCall NO-LOCK WHERE RefCall.CallNum = pCallNum NO-ERROR.
    IF NOT AVAILABLE RefCall THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:CallNum = RefCall.CallNum
           THIS-OBJECT:CustNum = RefCall.CustNum
           THIS-OBJECT:CallDate = RefCall.CallDate
           THIS-OBJECT:SalesRep = RefCall.SalesRep
           THIS-OBJECT:Parent = RefCall.Parent
           THIS-OBJECT:Txt = RefCall.Txt
           rRow = ROWID(RefCall) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:CallNum = "" THEN cErr = cErr + "Call Num is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE RefCall.
      ELSE FIND RefCall WHERE ROWID(RefCall) = rRow EXCLUSIVE-LOCK.
      ASSIGN RefCall.CallNum = THIS-OBJECT:CallNum
             RefCall.CustNum = THIS-OBJECT:CustNum
             RefCall.CallDate = THIS-OBJECT:CallDate
             RefCall.SalesRep = THIS-OBJECT:SalesRep
             RefCall.Parent = THIS-OBJECT:Parent
             RefCall.Txt = THIS-OBJECT:Txt.
      rRow = ROWID(RefCall).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND RefCall WHERE ROWID(RefCall) = rRow EXCLUSIVE-LOCK.
      DELETE RefCall.
    END.
  END METHOD.

END CLASS.

