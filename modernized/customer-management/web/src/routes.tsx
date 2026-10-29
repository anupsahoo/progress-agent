// Customer Management: module routes. Replaces cm_menu.w.
import { useState } from 'react';
import { CustomerList } from './customer/CustomerList';
import { CustomerDetail } from './customer/CustomerDetail';
import { CustomerEdit } from './customer/CustomerEdit';
import type { Customer } from './customer/types';
import { FeedbackList } from './feedback/FeedbackList';
import { FeedbackDetail } from './feedback/FeedbackDetail';
import { FeedbackEdit } from './feedback/FeedbackEdit';
import type { Feedback } from './feedback/types';

function CustomerScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<Customer | null>(null);
  if (mode === 'view' && row) return <CustomerDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <CustomerEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <CustomerEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <CustomerList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

function FeedbackScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<Feedback | null>(null);
  if (mode === 'view' && row) return <FeedbackDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <FeedbackEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <FeedbackEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <FeedbackList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

export const customerManagementRoutes = [
  { path: '/customer-management/customers', title: "Customer maintenance", element: <CustomerScreen /> },
  { path: '/customer-management/feedbacks', title: "Feedback maintenance", element: <FeedbackScreen /> },
];
