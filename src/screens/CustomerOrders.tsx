import React, { useState } from 'react';
import { C, PageHeader, BeforeAfter } from '../components/Shell';
import { customers, orders, customerById, ordersByCustomer } from '../data/sports';

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

export function CustomerOrders() {
  const [custId, setCustId] = useState(1);
  const customer = customerById(custId);
  const custOrders = ordersByCustomer(custId);

  return (
    <div>
      <PageHeader
        title="Customer Orders"
        subtitle="Look up a customer and instantly see their orders. Originally a REPEAT loop with two ABL frames; now a searchable master-detail view."
        source="sports/cust_orders.p"
      />

      <BeforeAfter beforeContent={PROGRESS_SCREEN}>
        <div>
          <div style={{ marginBottom: 20 }}>
            <div style={{
              fontSize: 10, fontWeight: 700, color: C.t3, fontFamily: C.mono,
              textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: 6,
            }}>
              Select customer
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
                  #{c.custNum} — {c.name} ({c.city}, {c.country})
                </option>
              ))}
            </select>
          </div>

          {customer && (
            <>
              <div style={{
                padding: '12px 16px',
                background: `linear-gradient(135deg, ${C.indUL} 0%, transparent 100%)`,
                borderRadius: 8, marginBottom: 16,
                border: `1px solid ${C.ind}22`,
              }}>
                <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, marginBottom: 4 }}>
                  <div style={{ fontSize: 18, fontWeight: 700, color: C.t1 }}>{customer.name}</div>
                  <div style={{ fontSize: 11, color: C.t3, fontFamily: C.mono }}>#{customer.custNum}</div>
                </div>
                <div style={{ fontSize: 13, color: C.t2 }}>
                  {customer.contact} &middot; {customer.city}{customer.state ? `, ${customer.state}` : ''} &middot; {customer.country}
                </div>
              </div>

              <div style={{
                fontSize: 10, fontWeight: 700, color: C.t3, fontFamily: C.mono,
                textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: 8,
              }}>
                Sales Orders ({custOrders.length})
              </div>

              {custOrders.length === 0 ? (
                <div style={{ padding: 24, textAlign: 'center', color: C.t3, border: `1px dashed ${C.bdr}`, borderRadius: 8, fontSize: 13 }}>
                  No orders for this customer.
                </div>
              ) : (
                <table style={tableStyle}>
                  <thead>
                    <tr>
                      <Th>Order #</Th>
                      <Th>Order Date</Th>
                      <Th>Ship Date</Th>
                      <Th>Carrier</Th>
                      <Th>Payment</Th>
                      <Th>Status</Th>
                    </tr>
                  </thead>
                  <tbody>
                    {custOrders.map(o => (
                      <tr key={o.orderNum}>
                        <Td mono>#{o.orderNum}</Td>
                        <Td>{o.orderDate}</Td>
                        <Td>{o.shipDate || '—'}</Td>
                        <Td>{o.carrier}</Td>
                        <Td>{o.paymentMethod}</Td>
                        <Td><StatusBadge status={o.status} /></Td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              )}
            </>
          )}
        </div>
      </BeforeAfter>
    </div>
  );
}

const tableStyle: React.CSSProperties = {
  width: '100%', borderCollapse: 'collapse', fontSize: 13,
  background: 'white', border: `1px solid ${C.bdr}`, borderRadius: 8, overflow: 'hidden',
};

function Th({ children }: { children: React.ReactNode }) {
  return (
    <th style={{
      padding: '10px 14px', textAlign: 'left',
      background: C.card, borderBottom: `1px solid ${C.bdr}`,
      fontSize: 10, fontWeight: 700, fontFamily: C.mono,
      textTransform: 'uppercase', letterSpacing: '0.05em', color: C.t3,
    }}>
      {children}
    </th>
  );
}

function Td({ children, mono }: { children: React.ReactNode; mono?: boolean }) {
  return (
    <td style={{
      padding: '10px 14px',
      borderBottom: `1px solid ${C.bdr}`,
      color: C.t1,
      fontFamily: mono ? C.mono : C.sans,
      fontWeight: mono ? 600 : 400,
    }}>
      {children}
    </td>
  );
}

function StatusBadge({ status }: { status: string }) {
  const s = status.toLowerCase();
  const color = s === 'shipped' ? C.green : s.includes('back') ? C.amber : C.t3;
  return (
    <span style={{
      display: 'inline-block',
      fontSize: 10, fontWeight: 700, padding: '2px 10px', borderRadius: 20,
      background: color + '18', color,
      textTransform: 'uppercase', letterSpacing: '0.04em', fontFamily: C.mono,
    }}>
      {status}
    </span>
  );
}
