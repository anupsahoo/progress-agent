/*------------------------------------------------------------------------
    File        : batch_runner.p
    Purpose     : runs scheduled batch programs in order
    Module      : Shared services
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-01  ssp  appserver split
 *  1999-05  kpo  remove dead code
 */

/* batch_runner.p : runs scheduled batch programs in order */

DEFINE INPUT PARAMETER pcJobList AS CHARACTER NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO.
DEFINE VARIABLE cRet AS CHARACTER NO-UNDO.

DO i = 1 TO NUM-ENTRIES(pcJobList):
  RUN VALUE(ENTRY(i, pcJobList)) NO-ERROR.
  cRet = RETURN-VALUE.
  RUN shared/log_msg.p (INPUT "INFO", INPUT ENTRY(i, pcJobList) + " returned " + cRet).
END.

