// Inventory: module routes. Replaces in_menu.w.
import { useState } from 'react';
import { ItemList } from './item/ItemList';
import { ItemDetail } from './item/ItemDetail';
import { ItemEdit } from './item/ItemEdit';
import type { Item } from './item/types';
import { InventoryTransList } from './inventoryTrans/InventoryTransList';
import { InventoryTransDetail } from './inventoryTrans/InventoryTransDetail';
import { InventoryTransEdit } from './inventoryTrans/InventoryTransEdit';
import type { InventoryTrans } from './inventoryTrans/types';

function ItemScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<Item | null>(null);
  if (mode === 'view' && row) return <ItemDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <ItemEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <ItemEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <ItemList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

function InventoryTransScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<InventoryTrans | null>(null);
  if (mode === 'view' && row) return <InventoryTransDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <InventoryTransEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <InventoryTransEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <InventoryTransList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

export const inventoryRoutes = [
  { path: '/inventory/items', title: "Item maintenance", element: <ItemScreen /> },
  { path: '/inventory/inventory-transes', title: "InventoryTrans maintenance", element: <InventoryTransScreen /> },
];
