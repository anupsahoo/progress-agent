// Sales & Territories: module routes. Replaces st_menu.w.
import { useState } from 'react';
import { SalesrepList } from './salesrep/SalesrepList';
import { SalesrepDetail } from './salesrep/SalesrepDetail';
import { SalesrepEdit } from './salesrep/SalesrepEdit';
import type { Salesrep } from './salesrep/types';
import { StateList } from './state/StateList';
import { StateDetail } from './state/StateDetail';
import { StateEdit } from './state/StateEdit';
import type { State } from './state/types';
import { LocalDefaultList } from './localDefault/LocalDefaultList';
import { LocalDefaultDetail } from './localDefault/LocalDefaultDetail';
import { LocalDefaultEdit } from './localDefault/LocalDefaultEdit';
import type { LocalDefault } from './localDefault/types';

function SalesrepScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<Salesrep | null>(null);
  if (mode === 'view' && row) return <SalesrepDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <SalesrepEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <SalesrepEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <SalesrepList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

function StateScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<State | null>(null);
  if (mode === 'view' && row) return <StateDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <StateEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <StateEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <StateList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

function LocalDefaultScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<LocalDefault | null>(null);
  if (mode === 'view' && row) return <LocalDefaultDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <LocalDefaultEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <LocalDefaultEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <LocalDefaultList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

export const salesTerritoriesRoutes = [
  { path: '/sales-territories/salesreps', title: "Salesrep maintenance", element: <SalesrepScreen /> },
  { path: '/sales-territories/states', title: "State maintenance", element: <StateScreen /> },
  { path: '/sales-territories/local-defaults', title: "LocalDefault maintenance", element: <LocalDefaultScreen /> },
];
