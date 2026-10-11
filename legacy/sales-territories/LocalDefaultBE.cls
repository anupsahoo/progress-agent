/*------------------------------------------------------------------------
    File        : LocalDefaultBE.cls
    Purpose     : business entity for LocalDefault (OpenEdge 11 OO ABL)
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2002-10  jkm  Y2K date window
 *  2012-10  tlw  fix rounding
 *  2013-11  ssp  performance: use index
 *  2007-01  ssp  audit fields
 *  2013-04  mab  remove dead code
 */

/* LocalDefaultBE.cls : business entity for LocalDefault (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS ST.LocalDefaultBE:

  DEFINE PUBLIC PROPERTY Country AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Region1Label AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Region2Label AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY PostalLabel AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY PostalFormat AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY TelFormat AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY CurrencySymbol AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY DateFormat AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY LocalDefNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC LocalDefaultBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pLocalDefNum AS INTEGER):
    FIND FIRST LocalDefault NO-LOCK WHERE LocalDefault.LocalDefNum = pLocalDefNum NO-ERROR.
    IF NOT AVAILABLE LocalDefault THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:Country = LocalDefault.Country
           THIS-OBJECT:Region1Label = LocalDefault.Region1Label
           THIS-OBJECT:Region2Label = LocalDefault.Region2Label
           THIS-OBJECT:PostalLabel = LocalDefault.PostalLabel
           THIS-OBJECT:PostalFormat = LocalDefault.PostalFormat
           THIS-OBJECT:TelFormat = LocalDefault.TelFormat
           THIS-OBJECT:CurrencySymbol = LocalDefault.CurrencySymbol
           THIS-OBJECT:DateFormat = LocalDefault.DateFormat
           THIS-OBJECT:LocalDefNum = LocalDefault.LocalDefNum
           rRow = ROWID(LocalDefault) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:LocalDefNum = 0 THEN cErr = cErr + "Local Default Num is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE LocalDefault.
      ELSE FIND LocalDefault WHERE ROWID(LocalDefault) = rRow EXCLUSIVE-LOCK.
      ASSIGN LocalDefault.Country = THIS-OBJECT:Country
             LocalDefault.Region1Label = THIS-OBJECT:Region1Label
             LocalDefault.Region2Label = THIS-OBJECT:Region2Label
             LocalDefault.PostalLabel = THIS-OBJECT:PostalLabel
             LocalDefault.PostalFormat = THIS-OBJECT:PostalFormat
             LocalDefault.TelFormat = THIS-OBJECT:TelFormat
             LocalDefault.CurrencySymbol = THIS-OBJECT:CurrencySymbol
             LocalDefault.DateFormat = THIS-OBJECT:DateFormat
             LocalDefault.LocalDefNum = THIS-OBJECT:LocalDefNum.
      rRow = ROWID(LocalDefault).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND LocalDefault WHERE ROWID(LocalDefault) = rRow EXCLUSIVE-LOCK.
      DELETE LocalDefault.
    END.
  END METHOD.

END CLASS.

