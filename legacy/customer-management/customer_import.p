/*------------------------------------------------------------------------
    File        : customer_import.p
    Purpose     : Import Customer from CSV with upsert
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

{customer-management/tt_customer.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttCustomer.
    IMPORT DELIMITER "," ttCustomer.CustNum ttCustomer.Country ttCustomer.Name ttCustomer.Address ttCustomer.Address2 ttCustomer.City ttCustomer.State ttCustomer.PostalCode ttCustomer.Contact ttCustomer.Phone ttCustomer.SalesRep ttCustomer.CreditLimit ttCustomer.Balance ttCustomer.Terms ttCustomer.Discount ttCustomer.Comments ttCustomer.Fax ttCustomer.EmailAddress NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttCustomer.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttCustomer:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST Customer EXCLUSIVE-LOCK WHERE Customer.CustNum = ttCustomer.CustNum NO-ERROR.
        IF NOT AVAILABLE Customer THEN CREATE Customer.
        BUFFER-COPY ttCustomer EXCEPT RowState ErrorMsg TO Customer.
        RUN customer-management/customer_val.p (INPUT ROWID(Customer), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

