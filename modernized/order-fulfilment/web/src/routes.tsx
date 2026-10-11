// Order Fulfilment: module routes. Replaces of_menu.w.
import { useState } from 'react';
import { ShipToList } from './shipTo/ShipToList';
import { ShipToDetail } from './shipTo/ShipToDetail';
import { ShipToEdit } from './shipTo/ShipToEdit';
import type { ShipTo } from './shipTo/types';

function ShipToScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<ShipTo | null>(null);
  if (mode === 'view' && row) return <ShipToDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <ShipToEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <ShipToEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <ShipToList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

export const orderFulfilmentRoutes = [
  { path: '/order-fulfilment/ship-tos', title: "ShipTo maintenance", element: <ShipToScreen /> },
];
