/*------------------------------------------------------------------------
    File        : lockretry.i
    Purpose     : retry wrapper for record locks
    Module      : Shared services
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-07  ssp  credit hold rule
 *  2015-01  mab  credit hold rule
 *  2012-08  jkm  Y2K date window
 */

/* lockretry.i : retry wrapper for record locks */

&GLOBAL-DEFINE LOCK-RETRY 3
&GLOBAL-DEFINE LOCK-WAIT 1

DEFINE VARIABLE iLockTry AS INTEGER NO-UNDO.

PROCEDURE wait-for-lock :
  DEFINE INPUT  PARAMETER phBuf  AS HANDLE    NO-UNDO.
  DEFINE INPUT  PARAMETER pcWhere AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER plGot  AS LOGICAL   NO-UNDO.
  iLockTry = 0.
  DO WHILE iLockTry < {&LOCK-RETRY}:
    phBuf:FIND-FIRST(pcWhere, EXCLUSIVE-LOCK, NO-WAIT) NO-ERROR.
    IF phBuf:AVAILABLE THEN DO:
      plGot = YES.
      RETURN.
    END.
    IF NOT phBuf:LOCKED THEN RETURN.
    iLockTry = iLockTry + 1.
    PAUSE {&LOCK-WAIT} NO-MESSAGE.
  END.
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Lock timeout on " + phBuf:NAME + " " + pcWhere).
END PROCEDURE.

