import React, { useMemo, useState } from 'react';
import { ChevronDown, ChevronRight, CircleAlert, Printer, Search } from 'lucide-react';
import { customers, customerById, ordersByCustomer, linesByOrder, itemById, type Order } from '../data/sports';
import { ModernizedLayout } from '../components/ModernizationPanel';
import { Card, EmptyState, Field, Kpi, StatusPill } from '../components/ui';
import { T, ablDate, fmtDate, fmtMoney } from '../theme';

const ablNum = (n: number) => n.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

/** R3: FOR EACH Order OF Customer BY Order.OrderDate DESCENDING */
function reportOrders(custNum: number): Order[] {
  return [...ordersByCustomer(custNum)].sort((a, b) => b.orderDate.localeCompare(a.orderDate));
}

function legacyScreen(custNum: number) {
  const c = customerById(custNum);
  if (!c) return `┌─ Error ───────────────────────────┐\n│ Customer ${custNum} not found.${' '.repeat(Math.max(0, 14 - String(custNum).length))}│\n│              [ OK ]               │\n└───────────────────────────────────┘`;
  const out: string[] = [`Orders for ${c.name}`, '═'.repeat(60)];
  const os = reportOrders(custNum);
  if (os.length === 0) out.push('', '(no orders)');
  os.forEach((o) => {
    const lines = linesByOrder(o.orderNum);
    const total = lines.reduce((s, l) => s + l.extendedPrice, 0);
    out.push('', 'Order#  Date      Ship Date Status', '──────  ────────  ───────── ────────────',
      `${String(o.orderNum).padStart(6)}  ${ablDate(o.orderDate).padEnd(8)}  ${ablDate(o.shipDate).padEnd(9)} ${o.status}`, '',
      '  Line Item                      Qty       Price       Total',
      '  ──── ──────────────────── ──────── ─────────── ───────────');
    lines.forEach((l) => {
      const it = itemById(l.itemNum);
      out.push(`  ${String(l.lineNum).padStart(4)} ${(it?.name ?? '').slice(0, 20).padEnd(20)} ${String(l.qty).padStart(8)} ${ablNum(l.price).padStart(11)} ${ablNum(l.extendedPrice).padStart(11)}`);
    });
    out.push(`  > Order ${o.orderNum} : ${lines.length} lines, Total: ${ablNum(total)}`);
  });
  return out.join('\n');
}

export function OrderReport({ param }: { param?: string }) {
  const [input, setInput] = useState(param || '1');
  const [custNum, setCustNum] = useState<number>(param ? parseInt(param, 10) || 0 : 1);
  const [collapsed, setCollapsed] = useState<Set<number>>(new Set());

  const customer = customerById(custNum);
  const os = useMemo(() => reportOrders(custNum), [custNum]);
  const totals = useMemo(() => {
    let lines = 0, value = 0;
    os.forEach((o) => linesByOrder(o.orderNum).forEach((l) => { lines++; value += l.extendedPrice; }));
    return { lines, value };
  }, [os]);
  const screen = useMemo(() => legacyScreen(custNum), [custNum]);

  const toggle = (n: number) => setCollapsed((s) => { const x = new Set(s); x.has(n) ? x.delete(n) : x.add(n); return x; });

  return (
    <ModernizedLayout
      program="order_report"
      title="Order report"
      subtitle="Orders for one customer, newest first, with line items, line counts and order totals."
      crumbs={['Sales', 'Order report']}
      legacyScreen={screen}
      actions={<button className="btn" onClick={() => window.print()}><Printer size={16} /> Print</button>}
    >
      <Card>
        <form className="row" style={{ alignItems: 'flex-end', gap: 14, flexWrap: 'wrap' }}
          onSubmit={(e) => { e.preventDefault(); setCustNum(parseInt(input, 10) || 0); setCollapsed(new Set()); }}>
          <Field label="Customer number" htmlFor="or-num">
            <div className="input-icon" style={{ width: 200 }}>
              <Search size={16} />
              <input id="or-num" className="input mono" inputMode="numeric" value={input} onChange={(e) => setInput(e.target.value.replace(/[^0-9]/g, ''))} />
            </div>
          </Field>
          <button className="btn primary" type="submit">Run report</button>
          <span className="muted" style={{ margin: '0 4px 10px' }}>or</span>
          <Field label="Choose a customer" htmlFor="or-pick">
            <select id="or-pick" className="select" style={{ minWidth: 260 }} value={customer ? custNum : ''}
              onChange={(e) => { setInput(e.target.value); setCustNum(parseInt(e.target.value, 10)); setCollapsed(new Set()); }}>
              {!customer && <option value="">Select a customer</option>}
              {customers.map((c) => <option key={c.custNum} value={c.custNum}>#{c.custNum} · {c.name}</option>)}
            </select>
          </Field>
        </form>
        {!customer && (
          <div className="alert error" role="alert" style={{ marginTop: 16 }}>
            <CircleAlert size={18} /><span>Customer {custNum} not found.</span>
          </div>
        )}
      </Card>

      {customer && (
        <>
          <div className="grid-kpi" style={{ gridTemplateColumns: 'repeat(3, minmax(0, 1fr))' }}>
            <Kpi label={`Orders for ${customer.name}`} value={os.length} foot={`Customer #${customer.custNum} · ${customer.city}`} />
            <Kpi label="Order lines" value={totals.lines} tone="success" foot="Across all orders" />
            <Kpi label="Report total" value={fmtMoney(totals.value)} tone="success" foot="Sum of extended price" />
          </div>

          {os.length === 0 && <Card><EmptyState title={`No orders for ${customer.name}.`} /></Card>}

          {os.map((o) => {
            const lines = linesByOrder(o.orderNum);
            const total = lines.reduce((s, l) => s + l.extendedPrice, 0);
            const isCollapsed = collapsed.has(o.orderNum);
            return (
              <section key={o.orderNum} className="card" style={{ overflow: 'hidden' }}>
                <button onClick={() => toggle(o.orderNum)} aria-expanded={!isCollapsed}
                  style={{ all: 'unset', boxSizing: 'border-box', width: '100%', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 14, padding: '16px 20px', borderBottom: isCollapsed ? 0 : `1px solid ${T.color.border}`, flexWrap: 'wrap' }}>
                  {isCollapsed ? <ChevronRight size={18} /> : <ChevronDown size={18} />}
                  <span style={{ fontWeight: 700, fontSize: 17 }}>Order #{o.orderNum}</span>
                  <StatusPill status={o.status} />
                  <span className="muted num" style={{ fontSize: 14 }}>
                    Placed {fmtDate(o.orderDate)} · {o.shipDate ? `Shipped ${fmtDate(o.shipDate)}` : 'Not shipped'}
                  </span>
                  <span style={{ marginLeft: 'auto', textAlign: 'right' }}>
                    <span className="muted" style={{ fontSize: 13.5, marginRight: 10 }}>{lines.length} {lines.length === 1 ? 'line' : 'lines'}</span>
                    <span className="num" style={{ fontWeight: 700, fontSize: 16.5 }}>{fmtMoney(total)}</span>
                  </span>
                </button>
                {!isCollapsed && (lines.length === 0 ? (
                  <div className="muted" style={{ padding: '16px 20px', fontSize: 14.5 }}>No line items on this order. Total {fmtMoney(0)}.</div>
                ) : (
                  <div className="table-wrap">
                    <table className="table">
                      <thead>
                        <tr>
                          <th style={{ width: 70 }}>Line</th><th>Item</th>
                          <th style={{ textAlign: 'right' }}>Qty</th><th style={{ textAlign: 'right' }}>Price</th>
                          <th style={{ textAlign: 'right' }}>Discount</th><th style={{ textAlign: 'right' }}>Total</th>
                        </tr>
                      </thead>
                      <tbody>
                        {lines.map((l) => {
                          const it = itemById(l.itemNum);
                          return (
                            <tr key={l.lineNum}>
                              <td className="mono muted">{l.lineNum}</td>
                              <td><div className="cell-strong">{it ? it.name : `Item #${l.itemNum}`}</div>{it && <div className="cell-sub">{it.category1} · {it.category2}</div>}</td>
                              <td className="num right">{l.qty}</td>
                              <td className="num right">{fmtMoney(l.price)}</td>
                              <td className="num right">{l.discount ? `${l.discount}%` : <span className="muted">None</span>}</td>
                              <td className="num right cell-strong">{fmtMoney(l.extendedPrice)}</td>
                            </tr>
                          );
                        })}
                      </tbody>
                      <tfoot>
                        <tr>
                          <td colSpan={5} style={{ textAlign: 'right' }}>Order {o.orderNum}: {lines.length} lines, total</td>
                          <td className="num right" style={{ color: T.color.brand, fontSize: 16 }}>{fmtMoney(total)}</td>
                        </tr>
                      </tfoot>
                    </table>
                  </div>
                ))}
              </section>
            );
          })}
        </>
      )}
    </ModernizedLayout>
  );
}
