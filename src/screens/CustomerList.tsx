import React, { useEffect, useMemo, useState } from 'react';
import { Download, Package, Pencil } from 'lucide-react';
import { customers, ordersByCustomer, orderTotal, utilisation, type Customer } from '../data/sports';
import { ModernizedLayout } from '../components/ModernizationPanel';
import { Card, DataTable, Drawer, Pill, StatusPill, UtilMeter, initials, type Column } from '../components/ui';
import { fmtDate, fmtMoney, fmtMoney0 } from '../theme';

/** R2: FOR EACH Customer NO-LOCK BY Customer.State BY Customer.Name */
const legacyOrder = (a: Customer, b: Customer) => a.state.localeCompare(b.state) || a.name.localeCompare(b.name);

const ablNum = (n: number) => n.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

function legacyScreen(rows: Customer[]) {
  const head = `Cust# Customer Name             State     Balance\n───── ───────────────────────── ───── ───────────`;
  const body = rows.map((c) =>
    `${String(c.custNum).padStart(5)} ${c.name.slice(0, 25).padEnd(25)} ${c.state.slice(0, 5).padEnd(5)} ${ablNum(c.balance).padStart(11)}`).join('\n');
  const total = rows.reduce((s, c) => s + c.balance, 0);
  return `${head}\n${body}\n\n┌─ Information ──────────────────────┐\n│ Total Customers: ${String(rows.length).padEnd(18)}│\n│ Total Balance: ${ablNum(total).padStart(15).padEnd(20)}│\n│              [ OK ]                │\n└────────────────────────────────────┘`;
}

export function CustomerList({ param, onNavigate }: { param?: string; onNavigate: (r: string) => void }) {
  const [country, setCountry] = useState('all');
  const [selected, setSelected] = useState<Customer | null>(null);

  useEffect(() => {
    if (param) setSelected(customers.find((c) => c.custNum === parseInt(param, 10)) || null);
  }, [param]);

  const ordered = useMemo(() => [...customers].sort(legacyOrder), []);
  const countries = useMemo(() => Array.from(new Set(customers.map((c) => c.country))).sort(), []);
  const rows = country === 'all' ? ordered : ordered.filter((c) => c.country === country);
  const screen = useMemo(() => legacyScreen(ordered), [ordered]);

  const cols: Column<Customer>[] = [
    { key: 'custNum', header: 'Cust#', render: (c) => <span className="mono cell-strong">{c.custNum}</span>, sortValue: (c) => c.custNum },
    { key: 'name', header: 'Customer', render: (c) => <><div className="cell-strong">{c.name}</div><div className="cell-sub">{c.contact}</div></>, sortValue: (c) => c.name },
    { key: 'state', header: 'State', render: (c) => c.state || <span className="muted">None</span>, sortValue: (c) => c.state },
    { key: 'city', header: 'Location', render: (c) => <><div>{c.city}</div><div className="cell-sub">{c.country}</div></>, sortValue: (c) => c.city },
    { key: 'balance', header: 'Balance', align: 'right', render: (c) => <span className="num cell-strong">{fmtMoney(c.balance)}</span>, sortValue: (c) => c.balance },
    { key: 'util', header: 'Credit used', render: (c) => <UtilMeter ratio={utilisation(c)} width={48} />, sortValue: (c) => utilisation(c) },
  ];

  const exportCsv = () => {
    const csv = ['CustNum,Name,State,Balance', ...rows.map((c) => `${c.custNum},"${c.name}",${c.state},${c.balance.toFixed(2)}`)].join('\n');
    const a = document.createElement('a');
    a.href = URL.createObjectURL(new Blob([csv], { type: 'text/csv' }));
    a.download = 'customers.csv';
    a.click();
  };

  return (
    <ModernizedLayout
      program="customer_list"
      title="Customers"
      subtitle="Every customer account, ordered by state and name as in the original report, with live balance totals."
      crumbs={['Customers', 'All customers']}
      legacyScreen={screen}
      actions={<button className="btn" onClick={exportCsv}><Download size={16} /> Export CSV</button>}
    >
      <Card pad={false}>
        <DataTable
          columns={cols}
          rows={rows}
          rowKey={(c) => c.custNum}
          searchText={(c) => `${c.custNum} ${c.name} ${c.city} ${c.state} ${c.contact}`}
          searchPlaceholder="Search name, city, state or number"
          onRowClick={setSelected}
          selectedKey={selected?.custNum}
          maxHeight={600}
          toolbar={
            <>
              <select className="select" style={{ width: 200 }} value={country} onChange={(e) => setCountry(e.target.value)} aria-label="Filter by country">
                <option value="all">All countries</option>
                {countries.map((c) => <option key={c} value={c}>{c}</option>)}
              </select>
              <span className="muted" style={{ fontSize: 13.5, marginLeft: 'auto' }}>Default order: State, then Name</span>
            </>
          }
          footer={(all) => (
            <tr>
              <td colSpan={4}>Total customers: <span className="num">{all.length}</span></td>
              <td className="num right">{fmtMoney(all.reduce((s, c) => s + c.balance, 0))}</td>
              <td className="muted" style={{ fontWeight: 500 }}>Total balance</td>
            </tr>
          )}
        />
      </Card>

      <CustomerDrawer customer={selected} onClose={() => setSelected(null)} onNavigate={onNavigate} />
    </ModernizedLayout>
  );
}

function CustomerDrawer({ customer: c, onClose, onNavigate }: { customer: Customer | null; onClose: () => void; onNavigate: (r: string) => void }) {
  if (!c) return null;
  const os = ordersByCustomer(c.custNum);
  return (
    <Drawer
      open
      onClose={onClose}
      title={<span className="row" style={{ gap: 12 }}><span className="avatar-sm">{initials(c.name)}</span>{c.name}</span>}
      subtitle={<span><span className="mono">#{c.custNum}</span> · {c.city}{c.state ? `, ${c.state}` : ''} · {c.country}</span>}
      footer={
        <>
          <button className="btn" onClick={() => onNavigate(`customer-orders/${c.custNum}`)}><Package size={16} /> View orders</button>
          <button className="btn primary" onClick={() => onNavigate(`customer-maint/${c.custNum}`)}><Pencil size={16} /> Edit customer</button>
        </>
      }
    >
      <div className="grid-2" style={{ gap: 12, marginBottom: 22 }}>
        <div className="card" style={{ padding: 14 }}>
          <div className="muted" style={{ fontSize: 13.5 }}>Balance</div>
          <div style={{ fontSize: 22, fontWeight: 700 }} className="num">{fmtMoney(c.balance)}</div>
        </div>
        <div className="card" style={{ padding: 14 }}>
          <div className="muted" style={{ fontSize: 13.5 }}>Credit limit</div>
          <div style={{ fontSize: 22, fontWeight: 700 }} className="num">{fmtMoney0(c.creditLimit)}</div>
        </div>
      </div>
      <div style={{ marginBottom: 22 }}><UtilMeter ratio={utilisation(c)} width={380} /></div>
      {c.comments && <div className="alert warn" style={{ marginBottom: 22 }}><span><b>Note:</b> {c.comments}</span></div>}

      <div className="section-title">Contact</div>
      <dl className="dl" style={{ marginBottom: 24 }}>
        <dt>Contact</dt><dd>{c.contact}</dd>
        <dt>Phone</dt><dd className="num">{c.phone}</dd>
        <dt>Address</dt><dd>{c.address}{c.address2 && c.address2 !== 'Address 2' ? <><br />{c.address2}</> : null}<br />{c.city}{c.state ? `, ${c.state}` : ''} {c.postalCode}</dd>
        <dt>Sales rep</dt><dd className="mono">{c.salesRep}</dd>
        <dt>Terms</dt><dd>{c.terms} · {c.discount}% discount</dd>
      </dl>

      <div className="section-title">Orders ({os.length})</div>
      {os.length === 0 ? <p className="muted" style={{ margin: 0 }}>No orders on file.</p> : (
        <div className="card" style={{ overflow: 'hidden' }}>
          {os.map((o) => (
            <div className="list-item" key={o.orderNum} style={{ padding: '11px 14px' }}>
              <span className="mono cell-strong">#{o.orderNum}</span>
              <span className="muted num">{fmtDate(o.orderDate)}</span>
              <span className="num" style={{ marginLeft: 'auto' }}>{orderTotal(o.orderNum) ? fmtMoney(orderTotal(o.orderNum)) : ''}</span>
              <StatusPill status={o.status} />
            </div>
          ))}
        </div>
      )}
      <div style={{ marginTop: 16 }}><Pill tone="neutral">Read only view · NO-LOCK</Pill></div>
    </Drawer>
  );
}
