/*------------------------------------------------------------------------
    File        : sample-update-credit.p
    Purpose     : Update credit limit for customers based on balance
    Database    : Sports2000
    Notes       : Customers with balance > 80% of credit limit get 
                  a 20% credit increase
------------------------------------------------------------------------*/

DEFINE VARIABLE iUpdated   AS INTEGER NO-UNDO.
DEFINE VARIABLE dOldLimit  AS DECIMAL NO-UNDO.
DEFINE VARIABLE dThreshold AS DECIMAL NO-UNDO INITIAL 0.8.
DEFINE VARIABLE dIncrease  AS DECIMAL NO-UNDO INITIAL 1.2.

DEFINE TEMP-TABLE ttCreditChange NO-UNDO
    FIELD CustNum    AS INTEGER
    FIELD CustName   AS CHARACTER
    FIELD OldLimit   AS DECIMAL
    FIELD NewLimit   AS DECIMAL
    FIELD Balance    AS DECIMAL.

FOR EACH Customer EXCLUSIVE-LOCK
    WHERE Customer.Balance > (Customer.CreditLimit * dThreshold)
      AND Customer.CreditLimit > 0:

    ASSIGN 
        dOldLimit = Customer.CreditLimit.

    CREATE ttCreditChange.
    ASSIGN 
        ttCreditChange.CustNum  = Customer.CustNum
        ttCreditChange.CustName = Customer.Name
        ttCreditChange.OldLimit = dOldLimit
        ttCreditChange.Balance  = Customer.Balance
        ttCreditChange.NewLimit = dOldLimit * dIncrease.

    ASSIGN 
        Customer.CreditLimit = dOldLimit * dIncrease
        iUpdated = iUpdated + 1.
END.

/* Display results */
FOR EACH ttCreditChange:
    DISPLAY 
        ttCreditChange.CustNum  FORMAT ">>>>9"        LABEL "Cust#"
        ttCreditChange.CustName FORMAT "X(20)"         LABEL "Name"
        ttCreditChange.Balance  FORMAT "->>>,>>9.99"   LABEL "Balance"
        ttCreditChange.OldLimit FORMAT "->>>,>>9.99"   LABEL "Old Limit"
        ttCreditChange.NewLimit FORMAT "->>>,>>9.99"   LABEL "New Limit"
        WITH DOWN WIDTH 90 TITLE "Credit Limit Updates".
END.

MESSAGE iUpdated "customer(s) updated."
    VIEW-AS ALERT-BOX INFORMATION.
