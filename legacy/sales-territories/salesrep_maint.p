/*------------------------------------------------------------------------
    File        : salesrep_maint.p
    Purpose     : Maintain Salesrep records
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-01  jkm  remove dead code
 *  2016-10  mab  credit hold rule
 *  2003-07  kpo  new report column
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{sales-territories/st_defs.i}
{sales-territories/salesrep_lookup.i}

DEFINE VARIABLE pSalesRep AS CHARACTER NO-UNDO FORMAT "x(4)" LABEL "Sales Rep".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pSalesRep COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " Salesrep Lookup ".

DEFINE FRAME fMain
    Salesrep.SalesRep COLON 22
    Salesrep.RepName COLON 22
    Salesrep.Region COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " Salesrep Maintenance ".

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pSalesRep WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST Salesrep WHERE Salesrep.SalesRep = pSalesRep
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED Salesrep THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "Salesrep is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE Salesrep THEN DO:
        MESSAGE "Salesrep not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE Salesrep.
            ASSIGN Salesrep.SalesRep = pSalesRep.
        END.

        DISPLAY Salesrep.SalesRep WITH FRAME fMain.
        UPDATE
            Salesrep.RepName
            Salesrep.Region
            WITH FRAME fMain.

        RUN sales-territories/salesrep_val.p (INPUT ROWID(Salesrep), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "Salesrep", INPUT STRING(ROWID(Salesrep)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "Salesrep saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE Salesrep.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

