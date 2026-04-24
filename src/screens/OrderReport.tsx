import React, { useState } from 'react';
import { C, PageHeader, BeforeAfter } from '../components/Shell';
import { customers, ordersByCustomer, linesByOrder, itemById, customerById } from '../data/sports';

const PROGRESS_SCREEN = `Order Report for Customer : Hoops (3)
════════════════════════════════════════════════════════════

Order #3   Date: 09/23/1997   Ship: 09/28/1997   Status: Shipped
────────────────────────────────────────────────────────────
  Line  Item             Qty    Price    Extended
  ────  ────────────   ─────   ──────   ──────────
    1   Fins                4   24.00       96.00
    2   Tennis Racquet      2  119.50      227.05
    3   Cycle Helmet        6   75.00      450.00
                                         ──────────
                            Subtotal      773.05
                            Lines: 3`;

export function OrderReport() {
  const [custId, setCustId] = useState(3);
  const customer = customerById(custId);
  const custOrders = ordersByCustomer(custId);

  return (
    <div>
      <PageHeader
        title="Order Details Report"
        subtitle="Full order breakdown with line items for a customer. Originally a text report printed per order; now an interactive drill-down with subtotals and item lookups."
        source="sports/sample-order-report.p"
      />

      <BeforeAfter beforeContent={PROGRESS_SCREEN}>
        <div style={{ marginBottom: 20 }}>
          <div style={{ fontSize: 10, fontWeight: 700, color: C.t3, fontFamily: C.mono, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: 6 }}>
            Customer
          </div>
          <select
            value={custId}
            onChange={e => setCustId(parseInt(e.target.value))}
            style={{
              width: '100%', padding: '9px 12px', borderRadius: 6,
              border: `1px solid ${C.bdr}`, fontSize: 14, fontFamily: C.sans,
              background: 'white', cursor: 'pointer',
            }}
          >
            {customers.map(c => (
              <option key={c.custNum} value={c.custNum}>
                #{c.custNum} — {c.name}
              </option>
            ))}
          </select>
        </div>

        {customer && custOrders.length === 0 && (
          <div style={{ padding: 30, textAlign: 'center', color: C.t3, border: `1px dashed ${C.bdr}`, borderRadius: 8 }}>
            No orders for {customer.name}.
          </div>
        )}

        {customer && custOrders.length > 0 && (
          <>
            <div style={{ fontSize: 15, fontWeight: 700, color: C.t1, marginBottom: 4 }}>
              {customer.name}
            </div>
            <div style={{ fontSize: 12, color: C.t3, marginBottom: 20 }}>
              {custOrders.length} order{custOrders.length !== 1 ? 's' : ''} on file
            </div>

            {custOrders.map(order => {
              const lines = linesByOrder(order.orderNum);
              const subtotal = lines.reduce((s, l) => s + l.extendedPrice, 0);
              return (
                <div key={order.orderNum} style={{
                  marginBottom: 20,
                  background: 'white',
                  border: `1px solid ${C.bdr}`,
                  borderRadius: 8,
                  overflow: 'hidden',
                }}>
                  <div style={{
                    padding: '10px 14px',
                    background: `linear-gradient(90deg, ${C.indUL} 0%, transparent 100%)`,
                    borderBottom: `1px solid ${C.bdr}`,
                    display: 'flex', alignItems: 'center', gap: 10, flexWrap: 'wrap',
                  }}>
                    <div style={{ fontSize: 14, fontWeight: 700, color: C.ind, fontFamily: C.mono }}>
                      Order #{order.orderNum}
                    </div>
                    <div style={{ fontSize: 12, color: C.t3 }}>
                      Placed {order.orderDate} · Shipped {order.shipDate || '—'}
                    </div>
                    <div style={{ marginLeft: 'auto', fontSize: 10, padding: '2px 10px', borderRadius: 20, background: C.green + '18', color: C.green, fontFamily: C.mono, fontWeight: 700, textTransform: 'uppercase' }}>
                      {order.status}
                    </div>
                  </div>
                  {lines.length === 0 ? (
                    <div style={{ padding: 16, fontSize: 12, color: C.t3, fontStyle: 'italic' }}>No line items.</div>
                  ) : (
                    <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
                      <thead>
                        <tr>
                          {['#', 'Item', 'Category', 'Qty', 'Price', 'Disc', 'Extended', 'Status'].map(h => (
                            <th key={h} style={{
                              padding: '9px 12px', textAlign: 'left',
                              background: '#f8fafc', borderBottom: `1px solid ${C.bdr}`,
                              fontSize: 10, fontWeight: 700, fontFamily: C.mono,
                              textTransform: 'uppercase', letterSpacing: '0.05em', color: C.t3,
                            }}>{h}</th>
                          ))}
                        </tr>
                      </thead>
                      <tbody>
                        {lines.map(l => {
                          const item = itemById(l.itemNum);
                          return (
                            <tr key={l.lineNum} style={{ borderTop: `1px solid ${C.bdr}` }}>
                              <td style={{ padding: '9px 12px', fontFamily: C.mono, color: C.t3 }}>{l.lineNum}</td>
                              <td style={{ padding: '9px 12px', fontWeight: 600 }}>{item ? item.name : `Item #${l.itemNum}`}</td>
                              <td style={{ padding: '9px 12px', color: C.t2, fontSize: 12 }}>{item ? `${item.category1} / ${item.category2}` : '—'}</td>
                              <td style={{ padding: '9px 12px', fontFamily: C.mono, textAlign: 'right' }}>{l.qty}</td>
                              <td style={{ padding: '9px 12px', fontFamily: C.mono, textAlign: 'right' }}>${l.price.toFixed(2)}</td>
                              <td style={{ padding: '9px 12px', fontFamily: C.mono, textAlign: 'right', color: C.amber }}>{l.discount}%</td>
                              <td style={{ padding: '9px 12px', fontFamily: C.mono, textAlign: 'right', fontWeight: 700 }}>${l.extendedPrice.toFixed(2)}</td>
                              <td style={{ padding: '9px 12px' }}>
                                <span style={{ fontSize: 10, padding: '1px 8px', borderRadius: 12, background: C.green + '14', color: C.green, fontFamily: C.mono, fontWeight: 700 }}>{l.status}</span>
                              </td>
                            </tr>
                          );
                        })}
                        <tr style={{ background: '#f8fafc' }}>
                          <td colSpan={6} style={{ padding: '9px 12px', textAlign: 'right', fontSize: 11, fontWeight: 700, color: C.t3, fontFamily: C.mono, textTransform: 'uppercase', letterSpacing: '0.05em' }}>
                            Subtotal · {lines.length} lines
                          </td>
                          <td style={{ padding: '9px 12px', textAlign: 'right', fontWeight: 800, fontSize: 15, color: C.ind, fontFamily: C.mono }}>
                            ${subtotal.toFixed(2)}
                          </td>
                          <td />
                        </tr>
                      </tbody>
                    </table>
                  )}
                </div>
              );
            })}
          </>
        )}
      </BeforeAfter>
    </div>
  );
}
