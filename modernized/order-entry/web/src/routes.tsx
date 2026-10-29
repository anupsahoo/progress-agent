// Order Entry: module routes. Replaces oe_menu.w.
import { useState } from 'react';
import { OrderList } from './order/OrderList';
import { OrderDetail } from './order/OrderDetail';
import { OrderEdit } from './order/OrderEdit';
import type { Order } from './order/types';
import { OrderLineList } from './orderLine/OrderLineList';
import { OrderLineDetail } from './orderLine/OrderLineDetail';
import { OrderLineEdit } from './orderLine/OrderLineEdit';
import type { OrderLine } from './orderLine/types';

function OrderScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<Order | null>(null);
  if (mode === 'view' && row) return <OrderDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <OrderEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <OrderEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <OrderList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

function OrderLineScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<OrderLine | null>(null);
  if (mode === 'view' && row) return <OrderLineDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <OrderLineEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <OrderLineEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <OrderLineList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

export const orderEntryRoutes = [
  { path: '/order-entry/orders', title: "Order maintenance", element: <OrderScreen /> },
  { path: '/order-entry/order-lines', title: "OrderLine maintenance", element: <OrderLineScreen /> },
];
