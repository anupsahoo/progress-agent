&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : of_menu.w
    Purpose     : Order Fulfilment menu
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE lAllowed AS LOGICAL NO-UNDO.
DEFINE SUB-MENU mProg
    MENU-ITEM m0 LABEL "ShipTo maintenance"
    MENU-ITEM m1 LABEL "ShipTo report"
    MENU-ITEM m2 LABEL "Pick list by warehouse and bin"
    MENU-ITEM m3 LABEL "Shipment confirmation"
    MENU-ITEM m4 LABEL "Post shipment to stock and order status"
    MENU-ITEM m5 LABEL "Carrier rate shopping by weight"
    MENU-ITEM m6 LABEL "Release back orders when stock arrives"
    MENU-ITEM m7 LABEL "Wave picking across orders"
    MENU-ITEM m8 LABEL "EDI 856 advance ship notice"
    MENU-ITEM m9 LABEL "Packing slip print"
    MENU-ITEM m10 LABEL "Ship-to address validation"
    MENU-ITEM m11 LABEL "Delivery tracking inquiry"
    .
DEFINE MENU mbMain MENUBAR SUB-MENU mProg LABEL "&Order Fulfilment".

ON CHOOSE OF MENU-ITEM m0 DO:
  RUN shared/security.p (INPUT "order-fulfilment/ship_to_browse.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-fulfilment/ship_to_browse.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m1 DO:
  RUN shared/security.p (INPUT "order-fulfilment/ship_to_report.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-fulfilment/ship_to_report.p.
END.

ON CHOOSE OF MENU-ITEM m2 DO:
  RUN shared/security.p (INPUT "order-fulfilment/pick_list.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-fulfilment/pick_list.p.
END.

ON CHOOSE OF MENU-ITEM m3 DO:
  RUN shared/security.p (INPUT "order-fulfilment/ship_confirm.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-fulfilment/ship_confirm.w PERSISTENT.
END.

ON CHOOSE OF MENU-ITEM m4 DO:
  RUN shared/security.p (INPUT "order-fulfilment/ship_post.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-fulfilment/ship_post.p.
END.

ON CHOOSE OF MENU-ITEM m5 DO:
  RUN shared/security.p (INPUT "order-fulfilment/carrier_rate.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-fulfilment/carrier_rate.p.
END.

ON CHOOSE OF MENU-ITEM m6 DO:
  RUN shared/security.p (INPUT "order-fulfilment/backorder_release.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-fulfilment/backorder_release.p.
END.

ON CHOOSE OF MENU-ITEM m7 DO:
  RUN shared/security.p (INPUT "order-fulfilment/wave_pick.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-fulfilment/wave_pick.p.
END.

ON CHOOSE OF MENU-ITEM m8 DO:
  RUN shared/security.p (INPUT "order-fulfilment/asn_856.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-fulfilment/asn_856.p.
END.

ON CHOOSE OF MENU-ITEM m9 DO:
  RUN shared/security.p (INPUT "order-fulfilment/packing_slip.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-fulfilment/packing_slip.p.
END.

ON CHOOSE OF MENU-ITEM m10 DO:
  RUN shared/security.p (INPUT "order-fulfilment/shipto_validate.p", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-fulfilment/shipto_validate.p.
END.

ON CHOOSE OF MENU-ITEM m11 DO:
  RUN shared/security.p (INPUT "order-fulfilment/delivery_track.w", OUTPUT lAllowed).
  IF lAllowed THEN RUN order-fulfilment/delivery_track.w PERSISTENT.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Order Fulfilment" MENUBAR = MENU mbMain:HANDLE.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

