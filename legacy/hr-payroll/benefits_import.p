/*------------------------------------------------------------------------
    File        : benefits_import.p
    Purpose     : Import Benefits from CSV with upsert
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

{hr-payroll/tt_benefits.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttBenefits.
    IMPORT DELIMITER "," ttBenefits.EmpNum ttBenefits.HealthCare ttBenefits.LifeInsurance ttBenefits.Pension401K ttBenefits.StockPurchase ttBenefits.MedicalSpending ttBenefits.DependentCare NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttBenefits.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttBenefits:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST Benefits EXCLUSIVE-LOCK WHERE Benefits.EmpNum = ttBenefits.EmpNum NO-ERROR.
        IF NOT AVAILABLE Benefits THEN CREATE Benefits.
        BUFFER-COPY ttBenefits EXCEPT RowState ErrorMsg TO Benefits.
        RUN hr-payroll/benefits_val.p (INPUT ROWID(Benefits), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

