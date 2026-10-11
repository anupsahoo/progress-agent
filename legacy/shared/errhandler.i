/*------------------------------------------------------------------------
    File        : errhandler.i
    Purpose     : standard error trapping
    Module      : Shared services
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2009-10  kpo  Y2K date window
 *  2017-06  jkm  remove dead code
 *  2012-05  tlw  audit fields
 *  2010-02  mab  performance: use index
 *  2002-03  kpo  remove dead code
 */

/* errhandler.i : standard error trapping */

ON ERROR UNDO, THROW.

PROCEDURE show-error :
  DEFINE INPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.
  MESSAGE pcMsg VIEW-AS ALERT-BOX ERROR TITLE "Sports2000".
  RUN shared/log_msg.p (INPUT "ERROR", INPUT pcMsg).
END PROCEDURE.

