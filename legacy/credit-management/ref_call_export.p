/*------------------------------------------------------------------------
    File        : ref_call_export.p
    Purpose     : Export RefCall to CSV
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2004-03  mab  fix rounding
 *  2002-02  ssp  appserver split
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "ref_call_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Call Num,Cust Num,Call Date,Sales Rep,Parent,Txt" SKIP.
FOR EACH RefCall NO-LOCK
    WHERE RefCall.CallDate = ? OR RefCall.CallDate >= TODAY - 3650
    BY RefCall.CallNum:
    EXPORT DELIMITER "," RefCall.CallNum RefCall.CustNum RefCall.CallDate RefCall.SalesRep RefCall.Parent RefCall.Txt.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=RefCall" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "RefCall export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

