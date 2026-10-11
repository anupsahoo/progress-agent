// Warehousing: module routes. Replaces wh_menu.w.
import { useState } from 'react';
import { WarehouseList } from './warehouse/WarehouseList';
import { WarehouseDetail } from './warehouse/WarehouseDetail';
import { WarehouseEdit } from './warehouse/WarehouseEdit';
import type { Warehouse } from './warehouse/types';
import { BinList } from './bin/BinList';
import { BinDetail } from './bin/BinDetail';
import { BinEdit } from './bin/BinEdit';
import type { Bin } from './bin/types';

function WarehouseScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<Warehouse | null>(null);
  if (mode === 'view' && row) return <WarehouseDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <WarehouseEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <WarehouseEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <WarehouseList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

function BinScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<Bin | null>(null);
  if (mode === 'view' && row) return <BinDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <BinEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <BinEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <BinList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

export const warehousingRoutes = [
  { path: '/warehousing/warehouses', title: "Warehouse maintenance", element: <WarehouseScreen /> },
  { path: '/warehousing/bins', title: "Bin maintenance", element: <BinScreen /> },
];
