// Purchasing: module routes. Replaces po_menu.w.
import { useState } from 'react';
import { PurchaseOrderList } from './purchaseOrder/PurchaseOrderList';
import { PurchaseOrderDetail } from './purchaseOrder/PurchaseOrderDetail';
import { PurchaseOrderEdit } from './purchaseOrder/PurchaseOrderEdit';
import type { PurchaseOrder } from './purchaseOrder/types';
import { POLineList } from './pOLine/POLineList';
import { POLineDetail } from './pOLine/POLineDetail';
import { POLineEdit } from './pOLine/POLineEdit';
import type { POLine } from './pOLine/types';

function PurchaseOrderScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<PurchaseOrder | null>(null);
  if (mode === 'view' && row) return <PurchaseOrderDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <PurchaseOrderEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <PurchaseOrderEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <PurchaseOrderList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

function POLineScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<POLine | null>(null);
  if (mode === 'view' && row) return <POLineDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <POLineEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <POLineEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <POLineList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

export const purchasingRoutes = [
  { path: '/purchasing/purchase-orders', title: "PurchaseOrder maintenance", element: <PurchaseOrderScreen /> },
  { path: '/purchasing/po-lines', title: "POLine maintenance", element: <POLineScreen /> },
];
