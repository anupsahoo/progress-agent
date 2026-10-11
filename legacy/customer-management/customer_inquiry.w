&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : customer_inquiry.w
    Purpose     : Read-only Customer inquiry with record navigation
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qNav FOR Customer SCROLLING.

DEFINE BUTTON btnFirst LABEL "First" SIZE 10 BY 1.14.
DEFINE BUTTON btnPrev LABEL "Prev" SIZE 10 BY 1.14.
DEFINE BUTTON btnNext LABEL "Next" SIZE 10 BY 1.14.
DEFINE BUTTON btnLast LABEL "Last" SIZE 10 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 10 BY 1.14.

DEFINE FRAME fView
    Customer.CustNum AT ROW 1.50 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.Country AT ROW 2.60 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.Name AT ROW 3.70 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.Address AT ROW 4.80 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.Address2 AT ROW 5.90 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.City AT ROW 7.00 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.State AT ROW 8.10 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.PostalCode AT ROW 9.20 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.Contact AT ROW 10.30 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.Phone AT ROW 11.40 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.SalesRep AT ROW 12.50 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.CreditLimit AT ROW 13.60 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.Balance AT ROW 14.70 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.Terms AT ROW 15.80 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.Discount AT ROW 16.90 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.Comments AT ROW 18.00 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.Fax AT ROW 19.10 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Customer.EmailAddress AT ROW 20.20 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    btnFirst AT ROW 21.80 COL 4 btnPrev btnNext btnLast btnClose
    WITH SIDE-LABELS THREE-D SIZE 90 BY 24 TITLE "Customer Inquiry".

ON CHOOSE OF btnFirst IN FRAME fView DO:
  GET FIRST qNav.
  IF NOT AVAILABLE Customer THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnPrev IN FRAME fView DO:
  GET PREV qNav.
  IF NOT AVAILABLE Customer THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnNext IN FRAME fView DO:
  GET NEXT qNav.
  IF NOT AVAILABLE Customer THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnLast IN FRAME fView DO:
  GET LAST qNav.
  IF NOT AVAILABLE Customer THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnClose IN FRAME fView DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

PROCEDURE show-record :
  IF AVAILABLE Customer THEN
    DISPLAY Customer.CustNum
            Customer.Country
            Customer.Name
            Customer.Address
            Customer.Address2
            Customer.City
            Customer.State
            Customer.PostalCode
            Customer.Contact
            Customer.Phone
            Customer.SalesRep
            Customer.CreditLimit
            Customer.Balance
            Customer.Terms
            Customer.Discount
            Customer.Comments
            Customer.Fax
            Customer.EmailAddress
        WITH FRAME fView.
END PROCEDURE.

OPEN QUERY qNav FOR EACH Customer NO-LOCK BY Customer.CustNum.
GET FIRST qNav.
RUN show-record.
ENABLE btnFirst btnPrev btnNext btnLast btnClose WITH FRAME fView.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

