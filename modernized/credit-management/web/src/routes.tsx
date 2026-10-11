// Credit Management: module routes. Replaces cr_menu.w.
import { useState } from 'react';
import { RefCallList } from './refCall/RefCallList';
import { RefCallDetail } from './refCall/RefCallDetail';
import { RefCallEdit } from './refCall/RefCallEdit';
import type { RefCall } from './refCall/types';

function RefCallScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<RefCall | null>(null);
  if (mode === 'view' && row) return <RefCallDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <RefCallEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <RefCallEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <RefCallList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

export const creditManagementRoutes = [
  { path: '/credit-management/ref-calls', title: "RefCall maintenance", element: <RefCallScreen /> },
];
