/*------------------------------------------------------------------------
    File        : family_import.p
    Purpose     : Import Family from CSV with upsert
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

{hr-payroll/tt_family.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttFamily.
    IMPORT DELIMITER "," ttFamily.EmpNum ttFamily.RelativeName ttFamily.Relation ttFamily.Birthdate ttFamily.CoveredOnBenefits ttFamily.BenefitDate NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttFamily.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttFamily:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST Family EXCLUSIVE-LOCK WHERE Family.EmpNum = ttFamily.EmpNum AND Family.RelativeName = ttFamily.RelativeName NO-ERROR.
        IF NOT AVAILABLE Family THEN CREATE Family.
        BUFFER-COPY ttFamily EXCEPT RowState ErrorMsg TO Family.
        RUN hr-payroll/family_val.p (INPUT ROWID(Family), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

