import React, { useMemo, useState } from 'react';
import { AlertTriangle, ArrowRight, CheckCircle2, CircleDollarSign, Gauge, Package, Users } from 'lucide-react';
import { customers, orders, orderLines, orderTotal, customerLabel, utilisation, isOpenOrder } from '../data/sports';
import { PROGRAMS } from '../data/modernization';
import { Card, Kpi, PageHeader, Pill, StatusPill, UtilMeter, initials } from '../components/ui';
import { T, fmtDate, fmtMoney, fmtMoney0, fmtPct } from '../theme';

const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

export function Dashboard({ onNavigate }: { onNavigate: (r: string) => void }) {
  const revenue = orderLines.reduce((s, l) => s + l.extendedPrice, 0);
  const open = orders.filter(isOpenOrder);
  const avgUtil = customers.reduce((s, c) => s + utilisation(c), 0) / customers.length;
  const countries = new Set(customers.map((c) => c.country)).size;
  const atRisk = [...customers].sort((a, b) => utilisation(b) - utilisation(a)).slice(0, 5);
  const watchCount = customers.filter((c) => utilisation(c) >= 0.5).length;
  const recent = [...orders].sort((a, b) => b.orderDate.localeCompare(a.orderDate)).slice(0, 6);

  return (
    <>
      <PageHeader
        title="Good morning, Alex"
        subtitle="Sales, orders and credit exposure across the Sports2000 customer base."
        actions={
          <>
            <button className="btn" onClick={() => onNavigate('order-report')}>Order report</button>
            <button className="btn primary" onClick={() => onNavigate('customer-maint')}>Find a customer</button>
          </>
        }
      />

      <div className="stack">
        <div className="grid-kpi">
          <Kpi label="Customers" value={customers.length} icon={<Users size={18} />} foot={`Across ${countries} countries`} />
          <Kpi label="Open orders" value={open.length} tone="warning" icon={<Package size={18} />}
            foot={<>of {orders.length} orders · {open.length} back ordered</>} />
          <Kpi label="Revenue" value={fmtMoney0(revenue)} tone="success" icon={<CircleDollarSign size={18} />}
            foot={`From ${orderLines.length} order lines`} />
          <Kpi label="Avg credit utilisation" value={fmtPct(avgUtil, 1)} tone={avgUtil > 0.5 ? 'danger' : 'brand'} icon={<Gauge size={18} />}
            foot={`${watchCount} customers at 50% or more`} />
        </div>

        <div className="dash-grid">
          <Card title="Revenue and orders" sub="By order month, Sep 1997 to Jul 1998"
            actions={<div className="legend"><span><i style={{ background: T.color.chart1 }} />Revenue</span><span><i style={{ background: T.color.chart2, borderRadius: 99 }} />Orders</span></div>}>
            <RevenueChart />
          </Card>

          <Card title="Credit alerts" sub="Customers closest to their credit limit" pad={false}
            actions={<button className="linkish" onClick={() => onNavigate('update-credit')}>Review <ArrowRight size={14} /></button>}>
            {atRisk.map((c) => {
              const u = utilisation(c);
              return (
                <div className="list-item" key={c.custNum}>
                  <span className="avatar-sm">{initials(c.name)}</span>
                  <div style={{ minWidth: 0, flex: 1 }}>
                    <div className="cell-strong" style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                      {c.name}
                      {u >= 0.8 && <AlertTriangle size={15} color={T.color.danger} aria-label="Over 80%" />}
                    </div>
                    <div className="cell-sub num">{fmtMoney(c.balance)} of {fmtMoney0(c.creditLimit)}</div>
                  </div>
                  <UtilMeter ratio={u} width={72} />
                </div>
              );
            })}
          </Card>
        </div>

        <div className="dash-grid">
          <Card title="Recent orders" sub="Latest six orders by order date" pad={false}
            actions={<button className="linkish" onClick={() => onNavigate('customer-orders')}>All orders <ArrowRight size={14} /></button>}>
            <div className="table-wrap">
              <table className="table">
                <thead>
                  <tr><th>Order</th><th>Customer</th><th>Date</th><th style={{ textAlign: 'right' }}>Total</th><th>Status</th></tr>
                </thead>
                <tbody>
                  {recent.map((o) => {
                    const total = orderTotal(o.orderNum);
                    return (
                      <tr key={o.orderNum} className="clickable" onClick={() => onNavigate(`customer-orders/${o.custNum}`)}>
                        <td className="mono cell-strong">#{o.orderNum}</td>
                        <td>{customerLabel(o.custNum)}</td>
                        <td className="num">{fmtDate(o.orderDate)}</td>
                        <td className="num right">{total ? fmtMoney(total) : <span className="muted">No lines</span>}</td>
                        <td><StatusPill status={o.status} /></td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </Card>

          <Card title="Modernized programs" sub="Every screen traces back to its ABL source" pad={false}>
            {Object.values(PROGRAMS).map((p) => (
              <button key={p.id} className="list-item" onClick={() => onNavigate(p.route)}
                style={{ width: '100%', background: 'none', border: 0, borderBottom: `1px solid ${T.color.border}`, cursor: 'pointer', textAlign: 'left' }}>
                <CheckCircle2 size={18} color={T.color.success} style={{ flex: 'none' }} />
                <div style={{ minWidth: 0, flex: 1 }}>
                  <div className="cell-strong">{p.title}</div>
                  <div className="cell-sub mono" style={{ fontSize: 12.5 }}>{p.source}</div>
                </div>
                <Pill tone={p.parity.full ? 'success' : 'neutral'}>{p.parity.label}</Pill>
              </button>
            ))}
          </Card>
        </div>
      </div>
    </>
  );
}

function RevenueChart() {
  const data = useMemo(() => {
    const out: { label: string; year: number; revenue: number; count: number }[] = [];
    for (let i = 0; i < 11; i++) {
      const m = (8 + i) % 12; // Sep 1997 .. Jul 1998
      const y = 1997 + Math.floor((8 + i) / 12);
      const key = `${y}-${String(m + 1).padStart(2, '0')}`;
      const os = orders.filter((o) => o.orderDate.startsWith(key));
      out.push({ label: MONTHS[m], year: y, revenue: os.reduce((s, o) => s + orderTotal(o.orderNum), 0), count: os.length });
    }
    return out;
  }, []);
  const [hover, setHover] = useState<number | null>(null);

  const W = 640, H = 270, padL = 50, padR = 32, padT = 14, padB = 34;
  const iw = W - padL - padR, ih = H - padT - padB;
  const maxRev = 5000;
  const maxCnt = 3;
  const bw = iw / data.length;
  const y = (v: number) => padT + ih - (v / maxRev) * ih;
  const yc = (v: number) => padT + ih - (v / maxCnt) * ih;
  const ticks = [0, 1250, 2500, 3750, 5000];
  const line = data.map((d, i) => `${i === 0 ? 'M' : 'L'}${padL + bw * i + bw / 2},${yc(d.count)}`).join(' ');

  return (
    <div style={{ position: 'relative' }}>
      <svg viewBox={`0 0 ${W} ${H}`} width="100%" role="img" aria-label="Monthly revenue bars and order count line" style={{ display: 'block' }}>
        {ticks.map((t) => (
          <g key={t}>
            <line x1={padL} x2={W - padR} y1={y(t)} y2={y(t)} stroke={T.color.chartGrid} />
            <text x={padL - 10} y={y(t) + 4} textAnchor="end" fontSize="13" fill={T.color.textMuted}>{t === 0 ? '$0' : `$${t / 1000}k`}</text>
          </g>
        ))}
        {[0, 1, 2, 3].map((c) => (
          <text key={c} x={W - padR + 10} y={yc(c) + 4} fontSize="13" fill={T.color.chart2}>{c}</text>
        ))}
        {data.map((d, i) => {
          const x = padL + bw * i;
          const h = (d.revenue / maxRev) * ih;
          return (
            <g key={i} onMouseEnter={() => setHover(i)} onMouseLeave={() => setHover(null)}>
              <rect x={x} y={padT} width={bw} height={ih} fill={hover === i ? T.color.surfaceSunken : 'transparent'} />
              {d.revenue > 0 && <rect x={x + bw * 0.22} y={y(d.revenue)} width={bw * 0.56} height={h} rx={4} fill={T.color.chart1} opacity={hover === null || hover === i ? 1 : 0.55} />}
              <text x={x + bw / 2} y={H - 12} textAnchor="middle" fontSize="13" fill={T.color.textMuted}>{d.label}</text>
            </g>
          );
        })}
        <path d={line} fill="none" stroke={T.color.chart2} strokeWidth={2.5} strokeLinejoin="round" />
        {data.map((d, i) => (
          <circle key={i} cx={padL + bw * i + bw / 2} cy={yc(d.count)} r={hover === i ? 5.5 : 4} fill="#fff" stroke={T.color.chart2} strokeWidth={2.5} pointerEvents="none" />
        ))}
      </svg>
      {hover !== null && (
        <div style={{
          position: 'absolute', top: 6, left: `${((padL + bw * hover + bw / 2) / W) * 100}%`, transform: 'translateX(-50%)',
          background: T.color.text, color: '#fff', borderRadius: 8, padding: '7px 11px', fontSize: 13, pointerEvents: 'none', whiteSpace: 'nowrap', boxShadow: T.shadow.md,
        }}>
          <b>{data[hover].label} {data[hover].year}</b> · {fmtMoney(data[hover].revenue)} · {data[hover].count} order{data[hover].count === 1 ? '' : 's'}
        </div>
      )}
    </div>
  );
}
