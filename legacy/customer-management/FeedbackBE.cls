/*------------------------------------------------------------------------
    File        : FeedbackBE.cls
    Purpose     : business entity for Feedback (OpenEdge 11 OO ABL)
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2008-03  tlw  new report column
 *  2015-09  ssp  Y2K date window
 *  2008-01  kpo  credit hold rule
 *  1999-11  ssp  Y2K date window
 *  2010-03  mab  audit fields
 */

/* FeedbackBE.cls : business entity for Feedback (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS CM.FeedbackBE:

  DEFINE PUBLIC PROPERTY Contact AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Company AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY EmailAddress AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Phone AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Fax AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Comments AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Department AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Rating AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC FeedbackBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pDepartment AS CHARACTER):
    FIND FIRST Feedback NO-LOCK WHERE Feedback.Department = pDepartment NO-ERROR.
    IF NOT AVAILABLE Feedback THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:Contact = Feedback.Contact
           THIS-OBJECT:Company = Feedback.Company
           THIS-OBJECT:EmailAddress = Feedback.EmailAddress
           THIS-OBJECT:Phone = Feedback.Phone
           THIS-OBJECT:Fax = Feedback.Fax
           THIS-OBJECT:Comments = Feedback.Comments
           THIS-OBJECT:Department = Feedback.Department
           THIS-OBJECT:Rating = Feedback.Rating
           rRow = ROWID(Feedback) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:Department = "" THEN cErr = cErr + "Department is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE Feedback.
      ELSE FIND Feedback WHERE ROWID(Feedback) = rRow EXCLUSIVE-LOCK.
      ASSIGN Feedback.Contact = THIS-OBJECT:Contact
             Feedback.Company = THIS-OBJECT:Company
             Feedback.EmailAddress = THIS-OBJECT:EmailAddress
             Feedback.Phone = THIS-OBJECT:Phone
             Feedback.Fax = THIS-OBJECT:Fax
             Feedback.Comments = THIS-OBJECT:Comments
             Feedback.Department = THIS-OBJECT:Department
             Feedback.Rating = THIS-OBJECT:Rating.
      rRow = ROWID(Feedback).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND Feedback WHERE ROWID(Feedback) = rRow EXCLUSIVE-LOCK.
      DELETE Feedback.
    END.
  END METHOD.

END CLASS.

