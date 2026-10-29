// Supplier Management: module routes. Replaces sm_menu.w.
import { useState } from 'react';
import { SupplierList } from './supplier/SupplierList';
import { SupplierDetail } from './supplier/SupplierDetail';
import { SupplierEdit } from './supplier/SupplierEdit';
import type { Supplier } from './supplier/types';
import { SupplierItemXrefList } from './supplierItemXref/SupplierItemXrefList';
import { SupplierItemXrefDetail } from './supplierItemXref/SupplierItemXrefDetail';
import { SupplierItemXrefEdit } from './supplierItemXref/SupplierItemXrefEdit';
import type { SupplierItemXref } from './supplierItemXref/types';

function SupplierScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<Supplier | null>(null);
  if (mode === 'view' && row) return <SupplierDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <SupplierEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <SupplierEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <SupplierList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

function SupplierItemXrefScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<SupplierItemXref | null>(null);
  if (mode === 'view' && row) return <SupplierItemXrefDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <SupplierItemXrefEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <SupplierItemXrefEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <SupplierItemXrefList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

export const supplierManagementRoutes = [
  { path: '/supplier-management/suppliers', title: "Supplier maintenance", element: <SupplierScreen /> },
  { path: '/supplier-management/supplier-item-xrefs', title: "SupplierItemXref maintenance", element: <SupplierItemXrefScreen /> },
];
