import React, { useMemo, useState } from 'react';
import { CircleAlert, FileText, MapPin, Search } from 'lucide-react';
import { customers, orders, customerById, ordersByCustomer, linesByOrder, itemById, orderTotal, customerLabel, type Order } from '../data/sports';
import { ModernizedLayout } from '../components/ModernizationPanel';
import { Card, DataTable, Drawer, EmptyState, Field, StatusPill, initials, type Column } from '../components/ui';
import { T, ablDate, fmtDate, fmtMoney } from '../theme';
import { Terminal, TFrame, TField, TLabel, TLine, TT, ablKeys } from '../components/Terminal';
import type { MapInfo } from '../components/Compare';
import { ReportTerminal, describeReport } from './OrderReport';

const OFILE = 'sports/cust_orders.p';
function describeOrders(key: string): MapInfo | undefined {
  if (key.startsWith('order-')) return { legacy: 'FOR EACH Order WHERE Order.CustNum = Customer.CustNum NO-LOCK: DISPLAY ... DOWN WITH FRAME fOrders', modern: '<DataTable rows={ordersByCustomer(custNum)}> row', note: 'A 10 DOWN frame becomes a sortable, paged table; click a row for line items.', lines: [31, 39] };
  switch (key) {
    case 'custnum-input': return { legacy: 'UPDATE iCustNum WITH FRAME fPrompt TITLE "Search"', modern: 'Customer number input + customer picker', lines: [18, 19] };
    case 'c-num': case 'c-name': case 'c-city':
      return { legacy: 'DISPLAY Customer.custnum customer.name customer.city WITH FRAME fCust', modern: 'Card header: avatar, name, #number and city', note: 'FIND FIRST ... NO-LOCK: read only, nothing is locked.', lines: [22, 25] };
    case 'f-orders': return { legacy: 'DEFINE FRAME fOrders ... WITH 10 DOWN TITLE "Sales Orders"', modern: '<DataTable columns={Order #, Date, Shipped, Status, Total}>', note: 'CLEAR FRAME fOrders ALL becomes replacing the rows.', lines: [11, 16] };
    case 'f-cust': return { legacy: 'DEFINE FRAME fCust ... WITH SIDE-LABELS TITLE "Customer Info"', modern: '<Card title={customer header}>', lines: [4, 8] };
    case 'msg': return { legacy: 'MESSAGE "Customer not found." VIEW-AS ALERT-BOX ERROR.', modern: '<div role="alert">Customer not found.</div>', note: 'Same text, verbatim.', lines: [41, 42] };
    case 'fkey-F1': return { legacy: 'F1 = GO  (run the lookup)', modern: '<button type="submit">Look up</button>', lines: [19, 19] };
  }
  return undefined;
}

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
  const [prog, setProg] = useState<'orders' | 'report'>('orders');
  const [dismissed, setDismissed] = useState(false);

  const lookup = (raw: string) => {
    const n = parseInt(raw, 10);
    setDismissed(false);
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

  const tabs = (
    <>
      <button className={prog === 'orders' ? 'on' : ''} onClick={() => setProg('orders')}>cust_orders.p</button>
      <button className={prog === 'report' ? 'on' : ''} onClick={() => setProg('report')}>sample-order-report.p</button>
    </>
  );
  const legacy = ({ big }: { big: boolean }) => {
    if (prog === 'report') return <ReportTerminal custNum={custNum ?? (parseInt(input, 10) || 0)} big={big} tabs={tabs} />;
    const rows = custOrders.slice(0, 10);
    const W = 56;
    return (
      <Terminal program={OFILE} cols={W} rows={20} maxFont={big ? 22 : 17} tabs={tabs}
        status="Enter data or press F4 to end."
        fkeys={[{ k: 'F1', label: 'GO', onClick: () => lookup(input) }, { k: 'F2', label: 'HELP' }, { k: 'F4', label: 'END-ERROR' }, { k: 'F8', label: 'CLEAR', onClick: () => setInput('') }]}
        alert={notFound && !dismissed ? { kind: 'error', text: 'Customer not found.', map: 'msg', onOk: () => setDismissed(true) } : null}>
        <TFrame title="Search" width={W} lines={[
          <><TLabel colon={16}>Enter Cust Num</TLabel><TField value={input} width={9} numeric map="custnum-input" label="Enter Cust Num"
            onChange={setInput} onKeyDown={ablKeys({ onGo: () => lookup(input) })} /></>,
        ]} />
        <TFrame title="Customer Info" width={W} map="f-cust" lines={[
          <><TLabel>Cust Num</TLabel><TT map="c-num" bright>{customer ? String(customer.custNum).padStart(5) : ''}</TT></>,
          <><TLabel>Name</TLabel><TT map="c-name" bright>{customer?.name ?? ''}</TT></>,
          <><TLabel>City</TLabel><TT map="c-city" bright>{customer?.city ?? ''}</TT></>,
        ]} />
        <TFrame title="Sales Orders" width={W} map="f-orders" lines={[
          <span className="tb">{' Order#  Date      Shipped   Status'}</span>,
          <span className="td">{' ------- --------  --------  --------------------'}</span>,
          ...Array.from({ length: 10 }, (_, i) => {
            const o = rows[i];
            if (!o) return '';
            return (
              <span data-map={`order-${o.orderNum}`} style={{ cursor: 'pointer' }} onClick={() => setOpenOrder(o)}>
                {` ${String(o.orderNum).padStart(7)} ${ablDate(o.orderDate).padEnd(8)}  ${ablDate(o.shipDate).padEnd(8)}  ${o.status.slice(0, 20)}`}
              </span>
            );
          }),
        ]} />
      </Terminal>
    );
  };

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
      compare={view === 'customer' ? {
        legacy,
        describe: (k) => (prog === 'report' ? describeReport(k, custNum ?? 0) : describeOrders(k)),
        legacyLabel: prog === 'report' ? 'sports/sample-order-report.p' : OFILE,
      } : undefined}
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
                  <input id="co-num" data-map="custnum-input" className="input mono" inputMode="numeric" value={input} onChange={(e) => setInput(e.target.value.replace(/[^0-9]/g, ''))} />
                </div>
              </Field>
              <button className="btn primary" type="submit" data-map="fkey-F1">Look up</button>
              <span className="muted" style={{ margin: '0 4px 10px' }}>or</span>
              <Field label="Choose a customer" htmlFor="co-pick" className="" >
                <select id="co-pick" className="select" style={{ minWidth: 260 }} value={custNum ?? ''}
                  onChange={(e) => { setInput(e.target.value); lookup(e.target.value); }}>
                  {custNum == null && <option value="">Select a customer</option>}
                  {customers.map((c) => <option key={c.custNum} value={c.custNum}>#{c.custNum} · {c.name}</option>)}
                </select>
              </Field>
            </form>
            {notFound && <div className="alert error" data-map="msg" role="alert" style={{ marginTop: 16 }}><CircleAlert size={18} /><span>Customer not found.</span></div>}
          </Card>

          {customer && (
            <Card pad={false}
              title={
                <span className="row" style={{ gap: 12 }}>
                  <span className="avatar-sm" data-map="f-cust">{initials(customer.name)}</span>
                  <span>
                    <span style={{ display: 'block' }} data-map="c-name">{customer.name}</span>
                    <span className="cell-sub row" style={{ gap: 6, fontWeight: 400 }}><span className="mono" data-map="c-num">#{customer.custNum}</span> · <MapPin size={13} /> <span data-map="c-city">{customer.city}</span>{customer.state ? `, ${customer.state}` : ''} · {customer.country}</span>
                  </span>
                </span>
              }
              actions={<button className="btn sm" onClick={() => onNavigate(`order-report/${customer.custNum}`)}><FileText size={15} /> Order report</button>}
            >
              {custOrders.length === 0
                ? <EmptyState title="No orders for this customer." sub="Orders placed for this customer will appear here." />
                : <DataTable columns={baseCols} rows={custOrders} rowKey={(o) => o.orderNum} rowMap={(o) => `order-${o.orderNum}`} hideSearch onRowClick={setOpenOrder} selectedKey={openOrder?.orderNum} />}
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
