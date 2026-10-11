/*------------------------------------------------------------------------
    File        : PurchaseOrderBE.cls
    Purpose     : business entity for PurchaseOrder (OpenEdge 11 OO ABL)
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-10  tlw  audit fields
 *  2003-12  tlw  Y2K date window
 *  2003-01  tlw  appserver split
 */

/* PurchaseOrderBE.cls : business entity for PurchaseOrder (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS PO.PurchaseOrderBE:

  DEFINE PUBLIC PROPERTY PONum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY DateEntered AS DATE NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY SupplierIDNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY ReceiveDate AS DATE NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY POStatus AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC PurchaseOrderBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pPONum AS INTEGER):
    FIND FIRST PurchaseOrder NO-LOCK WHERE PurchaseOrder.PONum = pPONum NO-ERROR.
    IF NOT AVAILABLE PurchaseOrder THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:PONum = PurchaseOrder.PONum
           THIS-OBJECT:DateEntered = PurchaseOrder.DateEntered
           THIS-OBJECT:SupplierIDNum = PurchaseOrder.SupplierIDNum
           THIS-OBJECT:ReceiveDate = PurchaseOrder.ReceiveDate
           THIS-OBJECT:POStatus = PurchaseOrder.POStatus
           rRow = ROWID(PurchaseOrder) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:PONum = 0 THEN cErr = cErr + "PO Num is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE PurchaseOrder.
      ELSE FIND PurchaseOrder WHERE ROWID(PurchaseOrder) = rRow EXCLUSIVE-LOCK.
      ASSIGN PurchaseOrder.PONum = THIS-OBJECT:PONum
             PurchaseOrder.DateEntered = THIS-OBJECT:DateEntered
             PurchaseOrder.SupplierIDNum = THIS-OBJECT:SupplierIDNum
             PurchaseOrder.ReceiveDate = THIS-OBJECT:ReceiveDate
             PurchaseOrder.POStatus = THIS-OBJECT:POStatus.
      rRow = ROWID(PurchaseOrder).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND PurchaseOrder WHERE ROWID(PurchaseOrder) = rRow EXCLUSIVE-LOCK.
      DELETE PurchaseOrder.
    END.
  END METHOD.

END CLASS.

