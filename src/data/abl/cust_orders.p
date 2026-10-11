DEFINE VARIABLE iCustNum AS INTEGER NO-UNDO LABEL "Enter Cust Num".

/* Frame for Customer Details */
DEFINE FRAME fCust
    Customer.CustNum    COLON 15
    Customer.Name       COLON 15
    Customer.City       COLON 15
    WITH SIDE-LABELS TITLE "Customer Info" 1 DOWN.

/* Frame for Orders (Displaying multiple rows) */
DEFINE FRAME fOrders
    Order.OrderNum      COLUMN-LABEL "Order#"
    Order.OrderDate     COLUMN-LABEL "Date"
    Order.ShipDate      COLUMN-LABEL "Shipped"
    Order.OrderStatus   COLUMN-LABEL "Status"
    WITH 10 DOWN TITLE "Sales Orders".

REPEAT:
    UPDATE iCustNum WITH FRAME fPrompt TITLE "Search".

    /* Find Customer with NO-LOCK since we are just viewing */
    FIND FIRST Customer WHERE Customer.CustNum = iCustNum NO-LOCK NO-ERROR.

    IF AVAILABLE Customer THEN DO:
        DISPLAY Customer.custnum customer.name customer.city WITH FRAME fCust.
        
        /* Clear the order frame from previous searches */
        CLEAR FRAME fOrders ALL.

        /* Iterate through related Orders */
        FOR EACH Order WHERE Order.CustNum = Customer.CustNum NO-LOCK:
            DISPLAY 
                Order.OrderNum 
                Order.OrderDate 
                Order.ShipDate 
                Order.OrderStatus 
            WITH FRAME fOrders.
            DOWN WITH FRAME fOrders.
        END.
    END.
    ELSE 
        MESSAGE "Customer not found." VIEW-AS ALERT-BOX ERROR.
END.