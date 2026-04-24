import React, { useState, useMemo } from 'react';
import { C, PageHeader, BeforeAfter } from '../components/Shell';
import { customers } from '../data/sports';

const PROGRESS_SCREEN = `CustNum  Name                          State       Balance
───────  ───────────────────────────   ────────    ─────────
      6  Fanatical Athletes            AL          1,202.66
      8  Game Set Match                AL          8,254.00
     51  Mountain Bikes Etc            CO          2,100.00
     66  Runners High                  CO            785.40
      3  Hoops                         GA          1,199.95
      1  Lift Tours                    MA            903.64
      5  Match Point Tennis            MA              0.00
      ...

Total Customers : 12
Total Balance   : 38,914.50`;

type SortKey = 'custNum' | 'name' | 'state' | 'balance' | 'creditLimit';

export function CustomerList() {
  const [sortKey, setSortKey] = useState<SortKey>('state');
  const [search, setSearch] = useState('');
  const [countryFilter, setCountryFilter] = useState('all');

  const countries = Array.from(new Set(customers.map(c => c.country))).sort();

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    return customers.filter(c => {
      if (countryFilter !== 'all' && c.country !== countryFilter) return false;
      if (!q) return true;
      return c.name.toLowerCase().includes(q) || c.city.toLowerCase().includes(q) || String(c.custNum).includes(q);
    });
  }, [search, countryFilter]);

  const sorted = useMemo(() => [...filtered].sort((a, b) => {
    const av: any = (a as any)[sortKey];
    const bv: any = (b as any)[sortKey];
    if (typeof av === 'number') return bv - av;
    return String(av).localeCompare(String(bv));
  }), [filtered, sortKey]);

  const totalBalance = filtered.reduce((s, c) => s + c.balance, 0);
  const totalCreditLimit = filtered.reduce((s, c) => s + c.creditLimit, 0);

  return (
    <div>
      <PageHeader
        title="Customer List"
        subtitle="All customers sorted by state & name. Originally a scrolling text report; now a sortable, searchable table with live totals."
        source="sports/sample-customer-list.p"
      />

      <BeforeAfter beforeContent={PROGRESS_SCREEN}>
        {/* Toolbar */}
        <div style={{ display: 'flex', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
          <input
            value={search}
            onChange={e => setSearch(e.target.value)}
            placeholder="Search name, city, or #…"
            style={{
              flex: 1, minWidth: 180,
              padding: '9px 12px', borderRadius: 6,
              border: `1px solid ${C.bdr}`, fontSize: 13, fontFamily: C.sans,
            }}
          />
          <select
            value={countryFilter}
            onChange={e => setCountryFilter(e.target.value)}
            style={{ padding: '9px 12px', borderRadius: 6, border: `1px solid ${C.bdr}`, fontSize: 13, background: 'white', cursor: 'pointer' }}
          >
            <option value="all">All countries ({customers.length})</option>
            {countries.map(c => (
              <option key={c} value={c}>{c}</option>
            ))}
          </select>
          <select
            value={sortKey}
            onChange={e => setSortKey(e.target.value as SortKey)}
            style={{ padding: '9px 12px', borderRadius: 6, border: `1px solid ${C.bdr}`, fontSize: 13, background: 'white', cursor: 'pointer' }}
          >
            <option value="state">Sort by State</option>
            <option value="name">Sort by Name</option>
            <option value="custNum">Sort by Cust #</option>
            <option value="balance">Sort by Balance</option>
            <option value="creditLimit">Sort by Credit Limit</option>
          </select>
        </div>

        {/* Summary cards */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 10, marginBottom: 16 }}>
          <StatCard label="Customers" value={String(filtered.length)} color={C.ind} />
          <StatCard label="Total Balance" value={`$${totalBalance.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`} color={C.amber} />
          <StatCard label="Credit Limit" value={`$${totalCreditLimit.toLocaleString()}`} color={C.green} />
        </div>

        {/* Table */}
        <div style={{ overflow: 'auto', maxHeight: 420, border: `1px solid ${C.bdr}`, borderRadius: 8 }}>
          <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13, background: 'white' }}>
            <thead style={{ position: 'sticky', top: 0 }}>
              <tr>
                {['#', 'Name', 'Country', 'State', 'City', 'Rep', 'Credit', 'Balance'].map(h => (
                  <th key={h} style={{
                    padding: '10px 12px', textAlign: 'left',
                    background: C.card, borderBottom: `1px solid ${C.bdr}`,
                    fontSize: 10, fontWeight: 700, fontFamily: C.mono,
                    textTransform: 'uppercase', letterSpacing: '0.05em', color: C.t3,
                  }}>{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {sorted.map(c => (
                <tr key={c.custNum} style={{ borderTop: `1px solid ${C.bdr}` }}>
                  <td style={{ padding: '9px 12px', fontFamily: C.mono, fontWeight: 600, color: C.t2 }}>#{c.custNum}</td>
                  <td style={{ padding: '9px 12px', fontWeight: 600, color: C.t1 }}>{c.name}</td>
                  <td style={{ padding: '9px 12px', color: C.t2 }}>{c.country}</td>
                  <td style={{ padding: '9px 12px', fontFamily: C.mono, fontSize: 12, color: C.t2 }}>{c.state || '—'}</td>
                  <td style={{ padding: '9px 12px', color: C.t2 }}>{c.city}</td>
                  <td style={{ padding: '9px 12px', fontFamily: C.mono, fontSize: 12, color: C.t2 }}>{c.salesRep}</td>
                  <td style={{ padding: '9px 12px', fontFamily: C.mono, fontWeight: 600, textAlign: 'right', color: C.t1 }}>
                    ${c.creditLimit.toLocaleString()}
                  </td>
                  <td style={{ padding: '9px 12px', fontFamily: C.mono, fontWeight: 700, textAlign: 'right', color: c.balance > c.creditLimit * 0.8 ? C.red : C.t1 }}>
                    ${c.balance.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </BeforeAfter>
    </div>
  );
}

function StatCard({ label, value, color }: { label: string; value: string; color: string }) {
  return (
    <div style={{
      padding: '12px 14px', borderRadius: 8, background: 'white',
      border: `1px solid ${color}22`, borderTop: `3px solid ${color}`,
    }}>
      <div style={{ fontSize: 10, fontWeight: 700, color: C.t3, fontFamily: C.mono, textTransform: 'uppercase', letterSpacing: '0.05em' }}>
        {label}
      </div>
      <div style={{ fontSize: 20, fontWeight: 800, color, marginTop: 3 }}>{value}</div>
    </div>
  );
}
