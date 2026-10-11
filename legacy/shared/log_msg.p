/*------------------------------------------------------------------------
    File        : log_msg.p
    Purpose     : application log with daily rotation
    Module      : Shared services
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-03  ssp  audit fields
 *  2001-09  jkm  new report column
 *  2003-01  mab  remove dead code
 */

/* log_msg.p : application log with daily rotation */

DEFINE INPUT PARAMETER pcLevel AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcText  AS CHARACTER NO-UNDO.
{shared/sysdefs.i}
DEFINE VARIABLE cLog AS CHARACTER NO-UNDO.

IF LOOKUP(pcLevel, "DEBUG,INFO,WARN,ERROR") = 0 THEN pcLevel = "INFO".
cLog = gLogDir + "app_" + STRING(TODAY, "99999999") + ".log".
FILE-INFO:FILE-NAME = cLog.
IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
  OUTPUT TO VALUE(cLog).
  PUT UNFORMATTED "# Sports2000 application log " STRING(TODAY) SKIP.
  OUTPUT CLOSE.
END.
OUTPUT TO VALUE(cLog) APPEND.
PUT UNFORMATTED STRING(NOW) " [" pcLevel "] " pcText SKIP.
OUTPUT CLOSE.

