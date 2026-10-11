/*------------------------------------------------------------------------
    File        : salesrep_import.p
    Purpose     : Import Salesrep from CSV with upsert
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

{sales-territories/tt_salesrep.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttSalesrep.
    IMPORT DELIMITER "," ttSalesrep.SalesRep ttSalesrep.RepName ttSalesrep.Region NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttSalesrep.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttSalesrep:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST Salesrep EXCLUSIVE-LOCK WHERE Salesrep.SalesRep = ttSalesrep.SalesRep NO-ERROR.
        IF NOT AVAILABLE Salesrep THEN CREATE Salesrep.
        BUFFER-COPY ttSalesrep EXCEPT RowState ErrorMsg TO Salesrep.
        RUN sales-territories/salesrep_val.p (INPUT ROWID(Salesrep), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

