// Billing & Invoicing: module routes. Replaces bi_menu.w.
import { useState } from 'react';
import { InvoiceList } from './invoice/InvoiceList';
import { InvoiceDetail } from './invoice/InvoiceDetail';
import { InvoiceEdit } from './invoice/InvoiceEdit';
import type { Invoice } from './invoice/types';
import { BillToList } from './billTo/BillToList';
import { BillToDetail } from './billTo/BillToDetail';
import { BillToEdit } from './billTo/BillToEdit';
import type { BillTo } from './billTo/types';

function InvoiceScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<Invoice | null>(null);
  if (mode === 'view' && row) return <InvoiceDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <InvoiceEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <InvoiceEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <InvoiceList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

function BillToScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<BillTo | null>(null);
  if (mode === 'view' && row) return <BillToDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <BillToEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <BillToEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <BillToList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

export const billingInvoicingRoutes = [
  { path: '/billing-invoicing/invoices', title: "Invoice maintenance", element: <InvoiceScreen /> },
  { path: '/billing-invoicing/bill-tos', title: "BillTo maintenance", element: <BillToScreen /> },
];
