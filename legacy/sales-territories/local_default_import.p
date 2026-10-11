/*------------------------------------------------------------------------
    File        : local_default_import.p
    Purpose     : Import LocalDefault from CSV with upsert
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

{sales-territories/tt_local_default.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttLocalDefault.
    IMPORT DELIMITER "," ttLocalDefault.Country ttLocalDefault.Region1Label ttLocalDefault.Region2Label ttLocalDefault.PostalLabel ttLocalDefault.PostalFormat ttLocalDefault.TelFormat ttLocalDefault.CurrencySymbol ttLocalDefault.DateFormat ttLocalDefault.LocalDefNum NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttLocalDefault.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttLocalDefault:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST LocalDefault EXCLUSIVE-LOCK WHERE LocalDefault.LocalDefNum = ttLocalDefault.LocalDefNum NO-ERROR.
        IF NOT AVAILABLE LocalDefault THEN CREATE LocalDefault.
        BUFFER-COPY ttLocalDefault EXCEPT RowState ErrorMsg TO LocalDefault.
        RUN sales-territories/local_default_val.p (INPUT ROWID(LocalDefault), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

