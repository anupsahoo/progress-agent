/*------------------------------------------------------------------------
    File        : StateBE.cls
    Purpose     : business entity for State (OpenEdge 11 OO ABL)
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2008-10  tlw  new report column
 *  2013-07  jkm  remove dead code
 *  2000-12  mab  add lock retry
 *  2003-09  ssp  add lock retry
 *  2009-02  jkm  Y2K date window
 */

/* StateBE.cls : business entity for State (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS ST.StateBE:

  DEFINE PUBLIC PROPERTY State AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY StateName AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Region AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC StateBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pState AS CHARACTER):
    FIND FIRST State NO-LOCK WHERE State.State = pState NO-ERROR.
    IF NOT AVAILABLE State THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:State = State.State
           THIS-OBJECT:StateName = State.StateName
           THIS-OBJECT:Region = State.Region
           rRow = ROWID(State) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:State = "" THEN cErr = cErr + "State is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE State.
      ELSE FIND State WHERE ROWID(State) = rRow EXCLUSIVE-LOCK.
      ASSIGN State.State = THIS-OBJECT:State
             State.StateName = THIS-OBJECT:StateName
             State.Region = THIS-OBJECT:Region.
      rRow = ROWID(State).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND State WHERE ROWID(State) = rRow EXCLUSIVE-LOCK.
      DELETE State.
    END.
  END METHOD.

END CLASS.

