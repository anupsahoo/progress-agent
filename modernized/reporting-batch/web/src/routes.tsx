// Reporting & Batch: module routes. Replaces rb_menu.w.
import { useState } from 'react';
import { CustomerList } from './customer/CustomerList';
import { CustomerDetail } from './customer/CustomerDetail';
import type { Customer } from './customer/types';
import { OrderList } from './order/OrderList';
import { OrderDetail } from './order/OrderDetail';
import type { Order } from './order/types';
import { OrderLineList } from './orderLine/OrderLineList';
import { OrderLineDetail } from './orderLine/OrderLineDetail';
import type { OrderLine } from './orderLine/types';

function CustomerScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<Customer | null>(null);
  if (mode === 'view' && row) return <CustomerDetail row={row} onBack={() => setMode('list')} />;
  return <CustomerList onOpen={(r) => { setRow(r); setMode('view'); }} />;
}

function OrderScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<Order | null>(null);
  if (mode === 'view' && row) return <OrderDetail row={row} onBack={() => setMode('list')} />;
  return <OrderList onOpen={(r) => { setRow(r); setMode('view'); }} />;
}

function OrderLineScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<OrderLine | null>(null);
  if (mode === 'view' && row) return <OrderLineDetail row={row} onBack={() => setMode('list')} />;
  return <OrderLineList onOpen={(r) => { setRow(r); setMode('view'); }} />;
}

export const reportingBatchRoutes = [
  { path: '/reporting-batch/customers', title: "Customer report", element: <CustomerScreen /> },
  { path: '/reporting-batch/orders', title: "Order report", element: <OrderScreen /> },
  { path: '/reporting-batch/order-lines', title: "OrderLine report", element: <OrderLineScreen /> },
];
