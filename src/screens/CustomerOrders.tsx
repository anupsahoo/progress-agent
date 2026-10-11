import React, { useMemo, useState } from 'react';
import { CircleAlert, FileText, MapPin, Search } from 'lucide-react';
import { customers, orders, customerById, ordersByCustomer, linesByOrder, itemById, orderTotal, customerLabel, type Order } from '../data/sports';
import { ModernizedLayout } from '../components/ModernizationPanel';
import { Card, DataTable, Drawer, EmptyState, Field, StatusPill, initials, type Column } from '../components/ui';
import { T, fmtDate, fmtMoney } from '../theme';

const PROGRESS_SCREEN = `┌──────────────────────────────────────────────────────────────────┐
│                   Customer Order Lookup                          │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Search: Enter Cust Num: 1                                        │
│                                                                  │
│ ┌─── Customer Info ────────────────────────────────────────┐     │
│ │ CustNum : 1                                              │     │
│ │ Name    : Lift Tours                                     │     │
│ │ City    : Burlington                                     │     │
│ └──────────────────────────────────────────────────────────┘     │
│                                                                  │
│ ┌─── Sales Orders ─────────────────────────────────────────┐     │
│ │ Order#   Date         Shipped       Status               │     │
│ │ ──────   ──────────   ──────────    ─────────            │     │
│ │ 6        02/11/98     02/16/98      Shipped              │     │
│ │ 9        04/15/98     04/20/98      Shipped              │     │
│ └──────────────────────────────────────────────────────────┘     │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘`;

export function CustomerOrders({ param, onNavigate }: { param?: string; onNavigate: (r: string) => void }) {
  const [view, setView] = useState<'customer' | 'all'>('customer');
  const [input, setInput] = useState(param || '1');
  const [custNum, setCustNum] = useState<number | null>(param ? parseInt(param, 10) : 1);
  const [notFound, setNotFound] = useState(false);
  const [openOrder, setOpenOrder] = useState<Order | null>(null);

  const lookup = (raw: string) => {
    const n = parseInt(raw, 10);
    if (!customerById(n)) { setNotFound(true); setCustNum(null); return; } // R2
    setNotFound(false); setCustNum(n); // R4: previous result replaced
  };

  const customer = custNum != null ? customerById(custNum) : undefined;
  const custOrders = custNum != null ? ordersByCustomer(custNum) : [];

  const baseCols: Column<Order>[] = [
    { key: 'orderNum', header: 'Order #', render: (o) => <span className="mono cell-strong">#{o.orderNum}</span>, sortValue: (o) => o.orderNum, width: 110 },
    { key: 'orderDate', header: 'Date', render: (o) => <span className="num">{fmtDate(o.orderDate)}</span>, sortValue: (o) => o.orderDate },
    { key: 'shipDate', header: 'Shipped', render: (o) => o.shipDate ? <span className="num">{fmtDate(o.shipDate)}</span> : <span className="muted">Not shipped</span>, sortValue: (o) => o.shipDate || '9999' },
    { key: 'status', header: 'Status', render: (o) => <StatusPill status={o.status} />, sortValue: (o) => o.status },
    { key: 'total', header: 'Total', align: 'right', render: (o) => { const t = orderTotal(o.orderNum); return t ? <span className="num">{fmtMoney(t)}</span> : <span className="muted">No lines</span>; }, sortValue: (o) => orderTotal(o.orderNum) },
  ];
  const allCols: Column<Order>[] = [
    baseCols[0],
    { key: 'customer', header: 'Customer', render: (o) => <><div className="cell-strong">{customerLabel(o.custNum)}</div><div className="cell-sub">#{o.custNum}</div></>, sortValue: (o) => customerLabel(o.custNum) },
    ...baseCols.slice(1),
  ];

  const statusFilterOptions = useMemo(() => Array.from(new Set(orders.map((o) => o.status))), []);
  const [status, setStatus] = useState('all');
  const allRows = status === 'all' ? orders : orders.filter((o) => o.status === status);

  return (
    <ModernizedLayout
      program="cust_orders"
      title="Orders"
      subtitle="Look up a customer to see every order on file, or browse all orders."
      crumbs={['Sales', 'Orders']}
      legacyScreen={PROGRESS_SCREEN}
      actions={
        <div className="seg" role="tablist">
          <button className={view === 'customer' ? 'on' : ''} onClick={() => setView('customer')}>By customer</button>
          <button className={view === 'all' ? 'on' : ''} onClick={() => setView('all')}>All orders <span className="count">{orders.length}</span></button>
        </div>
      }
    >
      {view === 'customer' ? (
        <>
          <Card>
            <form className="row" style={{ alignItems: 'flex-end', gap: 14, flexWrap: 'wrap' }} onSubmit={(e) => { e.preventDefault(); lookup(input); }}>
              <Field label="Customer number" htmlFor="co-num">
                <div className="input-icon" style={{ width: 200 }}>
                  <Search size={16} />
                  <input id="co-num" className="input mono" inputMode="numeric" value={input} onChange={(e) => setInput(e.target.value.replace(/[^0-9]/g, ''))} />
                </div>
              </Field>
              <button className="btn primary" type="submit">Look up</button>
              <span className="muted" style={{ margin: '0 4px 10px' }}>or</span>
              <Field label="Choose a customer" htmlFor="co-pick" className="" >
                <select id="co-pick" className="select" style={{ minWidth: 260 }} value={custNum ?? ''}
                  onChange={(e) => { setInput(e.target.value); lookup(e.target.value); }}>
                  {custNum == null && <option value="">Select a customer</option>}
                  {customers.map((c) => <option key={c.custNum} value={c.custNum}>#{c.custNum} · {c.name}</option>)}
                </select>
              </Field>
            </form>
            {notFound && <div className="alert error" role="alert" style={{ marginTop: 16 }}><CircleAlert size={18} /><span>Customer not found.</span></div>}
          </Card>

          {customer && (
            <Card pad={false}
              title={
                <span className="row" style={{ gap: 12 }}>
                  <span className="avatar-sm">{initials(customer.name)}</span>
                  <span>
                    <span style={{ display: 'block' }}>{customer.name}</span>
                    <span className="cell-sub row" style={{ gap: 6, fontWeight: 400 }}><span className="mono">#{customer.custNum}</span> · <MapPin size={13} /> {customer.city}{customer.state ? `, ${customer.state}` : ''} · {customer.country}</span>
                  </span>
                </span>
              }
              actions={<button className="btn sm" onClick={() => onNavigate(`order-report/${customer.custNum}`)}><FileText size={15} /> Order report</button>}
            >
              {custOrders.length === 0
                ? <EmptyState title="No orders for this customer." sub="Orders placed for this customer will appear here." />
                : <DataTable columns={baseCols} rows={custOrders} rowKey={(o) => o.orderNum} hideSearch onRowClick={setOpenOrder} selectedKey={openOrder?.orderNum} />}
            </Card>
          )}
        </>
      ) : (
        <Card pad={false} title="All orders" sub="Select an order to see its line items">
          <DataTable
            columns={allCols}
            rows={allRows}
            rowKey={(o) => o.orderNum}
            searchText={(o) => `${o.orderNum} ${customerLabel(o.custNum)} ${o.carrier} ${o.status}`}
            searchPlaceholder="Search order, customer or carrier"
            initialSort={{ key: 'orderDate', dir: 'desc' }}
            onRowClick={setOpenOrder}
            selectedKey={openOrder?.orderNum}
            toolbar={
              <select className="select" style={{ width: 200 }} value={status} onChange={(e) => setStatus(e.target.value)} aria-label="Filter by status">
                <option value="all">All statuses</option>
                {statusFilterOptions.map((s) => <option key={s} value={s}>{s}</option>)}
              </select>
            }
          />
        </Card>
      )}

      <OrderDrawer order={openOrder} onClose={() => setOpenOrder(null)} onNavigate={onNavigate} />
    </ModernizedLayout>
  );
}

export function OrderDrawer({ order, onClose, onNavigate }: { order: Order | null; onClose: () => void; onNavigate?: (r: string) => void }) {
  if (!order) return null;
  const lines = linesByOrder(order.orderNum);
  const total = orderTotal(order.orderNum);
  return (
    <Drawer
      open={!!order}
      onClose={onClose}
      title={<span className="row" style={{ gap: 10 }}>Order #{order.orderNum} <StatusPill status={order.status} /></span>}
      subtitle={customerLabel(order.custNum)}
      footer={onNavigate && customerById(order.custNum)
        ? <button className="btn primary" onClick={() => onNavigate(`order-report/${order.custNum}`)}><FileText size={16} /> Open order report</button>
        : undefined}
    >
      <dl className="dl">
        <dt>Order date</dt><dd>{fmtDate(order.orderDate)}</dd>
        <dt>Promised</dt><dd>{fmtDate(order.promiseDate)}</dd>
        <dt>Shipped</dt><dd>{order.shipDate ? fmtDate(order.shipDate) : <span className="muted">Not shipped yet</span>}</dd>
        <dt>Carrier</dt><dd>{order.carrier}</dd>
        <dt>Payment</dt><dd>{order.paymentMethod}</dd>
        <dt>Terms</dt><dd>{order.terms}</dd>
        <dt>Sales rep</dt><dd className="mono">{order.salesRep}</dd>
      </dl>
      <div className="section-title" style={{ marginTop: 26 }}>Line items</div>
      {lines.length === 0 ? (
        <EmptyState title="No line items on file." />
      ) : (
        <div className="card" style={{ overflow: 'hidden' }}>
          <table className="table">
            <thead><tr><th>Item</th><th style={{ textAlign: 'right' }}>Qty</th><th style={{ textAlign: 'right' }}>Total</th></tr></thead>
            <tbody>
              {lines.map((l) => {
                const it = itemById(l.itemNum);
                return (
                  <tr key={l.lineNum}>
                    <td><div className="cell-strong">{it ? it.name : `Item #${l.itemNum}`}</div><div className="cell-sub num">{fmtMoney(l.price)} each{l.discount ? ` · ${l.discount}% off` : ''}</div></td>
                    <td className="num right">{l.qty}</td>
                    <td className="num right">{fmtMoney(l.extendedPrice)}</td>
                  </tr>
                );
              })}
            </tbody>
            <tfoot><tr><td>Order total</td><td /><td className="num right" style={{ color: T.color.text }}>{fmtMoney(total)}</td></tr></tfoot>
          </table>
        </div>
      )}
    </Drawer>
  );
}
