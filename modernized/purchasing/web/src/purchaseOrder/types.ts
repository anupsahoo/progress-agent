// PurchaseOrder: generated from the sports2000 schema. The purchaseorder table contains information pertaining to the purchase order including: PO number and status.
// Primary key: PONum

export interface PurchaseOrder {
  /** PO Num. ABL integer, format "zzzzzzzzz9". */
  PONum: number;
  /** Date Entered. ABL date, format "99/99/9999". */
  DateEntered?: string | null;
  /** Supplier ID. ABL integer, format "zzzzzzzzz9". */
  SupplierIDNum?: number | null;
  /** Date Received. ABL date, format "99/99/9999". */
  ReceiveDate?: string | null;
  /** PO Status. ABL character, format "x(20)". */
  POStatus?: string | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type PurchaseOrderKey = { PONum: number };

export const purchaseOrderLabels: Record<string, string> = {
  PONum: "PO Num",
  DateEntered: "Date Entered",
  SupplierIDNum: "Supplier ID",
  ReceiveDate: "Date Received",
  POStatus: "PO Status",
};
