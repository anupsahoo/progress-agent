/*------------------------------------------------------------------------
    File        : locale_defaults_sync.p
    Purpose     : Sync country locale defaults from HQ
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-04  kpo  remove dead code
 *  2003-04  mab  appserver split
 *  2007-11  mab  credit hold rule
 *  2004-11  rdh  new report column
 *  2009-12  jkm  Y2K date window
 */

{shared/sysdefs.i}
{sales-territories/tt_local_default.i}

DEFINE INPUT PARAMETER pcDir AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRecs AS INTEGER   NO-UNDO.
DEFINE VARIABLE lcDoc AS LONGCHAR  NO-UNDO.

cFile = pcDir + "/locale_defaults_sync_" + STRING(TODAY, "99999999") + ".dat".

FOR EACH LocalDefault NO-LOCK:
    CREATE ttLocalDefault.
    BUFFER-COPY LocalDefault TO ttLocalDefault.
    iRecs = iRecs + 1.
END.

DATASET dsLocalDefault:WRITE-JSON("LONGCHAR", lcDoc, TRUE).
COPY-LOB FROM lcDoc TO FILE cFile.

OUTPUT TO VALUE(cFile + ".ctl").
PUT UNFORMATTED "RECORDS=" iRecs SKIP "SOURCE=LocalDefault" SKIP "FIELDS=Country,Region1Label,Region2Label,PostalLabel,PostalFormat,TelFormat,CurrencySymbol,DateFormat,LocalDefNum" SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "locale_defaults_sync.p: " + STRING(iRecs) + " records written").

PROCEDURE flag-local-default-country0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bLocalDefault FOR LocalDefault.
  FIND bLocalDefault WHERE ROWID(bLocalDefault) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bLocalDefault THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bLocalDefault.Country = "" OR bLocalDefault.Country = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "LocalDefault.Country is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bLocalDefault.Country) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE derive-local-default-postalformat1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bLocalDefault FOR LocalDefault.
  FIND bLocalDefault WHERE ROWID(bLocalDefault) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bLocalDefault THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bLocalDefault.PostalFormat = "" OR bLocalDefault.PostalFormat = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "LocalDefault.PostalFormat is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bLocalDefault.PostalFormat) > 15 THEN plOk = NO.
END PROCEDURE.

PROCEDURE map-local-default-region1label2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bLocalDefault FOR LocalDefault.
  FIND bLocalDefault WHERE ROWID(bLocalDefault) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bLocalDefault THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bLocalDefault.Region1Label = "" OR bLocalDefault.Region1Label = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "LocalDefault.Region1Label is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bLocalDefault.Region1Label) > 15 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-local-default-telformat3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bLocalDefault FOR LocalDefault.
  FIND bLocalDefault WHERE ROWID(bLocalDefault) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bLocalDefault THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bLocalDefault.TelFormat = "" OR bLocalDefault.TelFormat = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "LocalDefault.TelFormat is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bLocalDefault.TelFormat) > 15 THEN plOk = NO.
END PROCEDURE.

PROCEDURE load-local-default-telformat4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bLocalDefault FOR LocalDefault.
  FIND bLocalDefault WHERE ROWID(bLocalDefault) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bLocalDefault THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bLocalDefault.TelFormat = "" OR bLocalDefault.TelFormat = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "LocalDefault.TelFormat is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bLocalDefault.TelFormat) > 15 THEN plOk = NO.
END PROCEDURE.

PROCEDURE round-local-default-postallabel5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bLocalDefault FOR LocalDefault.
  FIND bLocalDefault WHERE ROWID(bLocalDefault) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bLocalDefault THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bLocalDefault.PostalLabel = "" OR bLocalDefault.PostalLabel = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "LocalDefault.PostalLabel is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bLocalDefault.PostalLabel) > 15 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-local-default-postalformat6 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bLocalDefault FOR LocalDefault.
  FIND bLocalDefault WHERE ROWID(bLocalDefault) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bLocalDefault THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bLocalDefault.PostalFormat = "" OR bLocalDefault.PostalFormat = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "LocalDefault.PostalFormat is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bLocalDefault.PostalFormat) > 15 THEN plOk = NO.
END PROCEDURE.

