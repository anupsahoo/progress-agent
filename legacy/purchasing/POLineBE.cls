/*------------------------------------------------------------------------
    File        : POLineBE.cls
    Purpose     : business entity for POLine (OpenEdge 11 OO ABL)
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2017-11  mab  audit fields
 *  2004-04  ssp  appserver split
 *  2000-07  tlw  fix rounding
 *  2014-01  rdh  audit fields
 *  1999-06  ssp  remove dead code
 */

/* POLineBE.cls : business entity for POLine (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS PO.POLineBE:

  DEFINE PUBLIC PROPERTY Linenum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Itemnum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Price AS DECIMAL NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Qty AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Discount AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY ExtendedPrice AS DECIMAL NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY PONum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY POLineStatus AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC POLineBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pPONum AS INTEGER, INPUT pLinenum AS INTEGER):
    FIND FIRST POLine NO-LOCK WHERE POLine.PONum = pPONum AND POLine.Linenum = pLinenum NO-ERROR.
    IF NOT AVAILABLE POLine THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:Linenum = POLine.Linenum
           THIS-OBJECT:Itemnum = POLine.Itemnum
           THIS-OBJECT:Price = POLine.Price
           THIS-OBJECT:Qty = POLine.Qty
           THIS-OBJECT:Discount = POLine.Discount
           THIS-OBJECT:ExtendedPrice = POLine.ExtendedPrice
           THIS-OBJECT:PONum = POLine.PONum
           THIS-OBJECT:POLineStatus = POLine.POLineStatus
           rRow = ROWID(POLine) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:PONum = 0 THEN cErr = cErr + "Order Num is required.~n".
    IF THIS-OBJECT:Linenum = 0 THEN cErr = cErr + "Line Num is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE POLine.
      ELSE FIND POLine WHERE ROWID(POLine) = rRow EXCLUSIVE-LOCK.
      ASSIGN POLine.Linenum = THIS-OBJECT:Linenum
             POLine.Itemnum = THIS-OBJECT:Itemnum
             POLine.Price = THIS-OBJECT:Price
             POLine.Qty = THIS-OBJECT:Qty
             POLine.Discount = THIS-OBJECT:Discount
             POLine.ExtendedPrice = THIS-OBJECT:ExtendedPrice
             POLine.PONum = THIS-OBJECT:PONum
             POLine.POLineStatus = THIS-OBJECT:POLineStatus.
      rRow = ROWID(POLine).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND POLine WHERE ROWID(POLine) = rRow EXCLUSIVE-LOCK.
      DELETE POLine.
    END.
  END METHOD.

END CLASS.

