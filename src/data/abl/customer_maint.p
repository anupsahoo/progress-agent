/*------------------------------------------------------------------------
    File        : cust_maint.p
    Purpose     : Simple Customer Maintenance for Sports2000
------------------------------------------------------------------------*/

DEFINE VARIABLE iCustNum AS INTEGER NO-UNDO LABEL "Enter Cust Num".

/* Define the UI Frame */
DEFINE FRAME fMain
    Customer.CustNum    COLON 15
    Customer.Name       COLON 15
    Customer.Address    COLON 15
    Customer.City       COLON 15
    Customer.State      COLON 15
    Customer.PostalCode COLON 15
    Customer.Phone      COLON 15
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER 1 DOWN.

REPEAT:
    /* 1. Prompt for Customer Number */
    UPDATE iCustNum WITH FRAME fPrompt TITLE "Search".

    /* 2. Find the record */
    /* EXCLUSIVE-LOCK ensures no one else edits while we are */
    FIND FIRST Customer WHERE Customer.CustNum = iCustNum 
         EXCLUSIVE-LOCK NO-ERROR.

    IF AVAILABLE Customer THEN DO:
        /* 3. Display and allow updates */
        /*
        DISPLAY Customer WITH FRAME fMain.
        UPDATE Customer WITH FRAME fMain.
        */
        disp Customer.CustNum with fram fmain.
        update
        Customer.Name      
        Customer.Address   
        Customer.City      
        Customer.State      
        Customer.PostalCode 
        Customer.Phone WITH FRAME fMain.
        
        
        MESSAGE "Record updated successfully." VIEW-AS ALERT-BOX INFORMATION.
    END.
    ELSE DO:
        MESSAGE "Customer not found." VIEW-AS ALERT-BOX ERROR.
    END.

    RELEASE Customer. /* Release the lock */
END.