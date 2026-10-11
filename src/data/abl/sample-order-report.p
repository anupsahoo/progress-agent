/*------------------------------------------------------------------------
    File        : sample-order-report.p
    Purpose     : Show orders for a given customer with line items
    Database    : Sports2000
------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER piCustNum AS INTEGER NO-UNDO.

DEFINE VARIABLE dOrderTotal AS DECIMAL NO-UNDO.
DEFINE VARIABLE iLineCount  AS INTEGER NO-UNDO.

FIND Customer WHERE Customer.CustNum = piCustNum NO-LOCK NO-ERROR.

IF NOT AVAILABLE Customer THEN DO:
    MESSAGE "Customer" piCustNum "not found." 
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

MESSAGE "Orders for:" Customer.Name VIEW-AS ALERT-BOX.

FOR EACH Order OF Customer NO-LOCK
    BY Order.OrderDate DESCENDING:

    DISPLAY 
        Order.OrderNum    LABEL "Order#"
        Order.OrderDate   LABEL "Date"
        Order.ShipDate    LABEL "Ship Date"
        Order.OrderStatus LABEL "Status"
        WITH DOWN WIDTH 80 TITLE "Orders for " + Customer.Name.

    ASSIGN dOrderTotal = 0
           iLineCount  = 0.

    FOR EACH OrderLine OF Order NO-LOCK:

        FIND Item WHERE Item.ItemNum = OrderLine.ItemNum NO-LOCK NO-ERROR.

        DISPLAY 
            OrderLine.LineNum   FORMAT ">>9"         LABEL "  Line"
            Item.ItemName       FORMAT "X(20)"       LABEL "Item"
            OrderLine.Qty       FORMAT "->>>,>>9"    LABEL "Qty"
            OrderLine.Price     FORMAT "->>>,>>9.99" LABEL "Price"
            OrderLine.ExtendedPrice FORMAT "->>>,>>9.99" LABEL "Total"
            WITH DOWN WIDTH 80.

        ASSIGN 
            dOrderTotal = dOrderTotal + OrderLine.ExtendedPrice
            iLineCount  = iLineCount + 1.
    END.

    MESSAGE "Order" Order.OrderNum ":" 
            iLineCount "lines, Total:" STRING(dOrderTotal, "->>>,>>9.99")
        VIEW-AS ALERT-BOX.
END.
