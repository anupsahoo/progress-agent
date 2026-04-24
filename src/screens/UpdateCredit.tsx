import React, { useState, useMemo } from 'react';
import { C, PageHeader, BeforeAfter } from '../components/Shell';
import { customers } from '../data/sports';

const PROGRESS_SCREEN = `Credit Limit Adjustment Job
════════════════════════════════════════════════════════════

Processing... Please wait.

Customer                      Old Limit    Balance      New Limit
───────────────────────────   ──────────   ─────────    ──────────
Go Fishing Ltd                    15,000    14,235.14    18,000
Game Set Match                    15,000     8,254.00    18,000

2 customers updated.
Done.`;

type Candidate = {
  custNum: number;
  name: string;
  oldLimit: number;
  balance: number;
  ratio: number;
  newLimit: number;
};

export function UpdateCredit() {
  const [applied, setApplied] = useState<Set<number>>(new Set());
  const [threshold, setThreshold] = useState(0.8);
  const [multiplier, setMultiplier] = useState(1.2);

  const candidates: Candidate[] = useMemo(() => {
    return customers
      .filter(c => c.creditLimit > 0 && c.balance / c.creditLimit > threshold)
      .map(c => ({
        custNum: c.custNum,
        name: c.name,
        oldLimit: c.creditLimit,
        balance: c.balance,
        ratio: c.balance / c.creditLimit,
        newLimit: Math.round(c.creditLimit * multiplier),
      }))
      .sort((a, b) => b.ratio - a.ratio);
  }, [threshold, multiplier]);

  const applyAll = () => setApplied(new Set(candidates.map(c => c.custNum)));
  const apply = (n: number) => setApplied(new Set([...applied, n]));
  const reset = () => setApplied(new Set());

  const appliedCount = candidates.filter(c => applied.has(c.custNum)).length;
  const totalIncrease = candidates
    .filter(c => applied.has(c.custNum))
    .reduce((s, c) => s + (c.newLimit - c.oldLimit), 0);

  return (
    <div>
      <PageHeader
        title="Credit Limit Adjustment"
        subtitle="Batch-increase credit limits for customers with high balance-to-limit ratios. Originally a blocking EXCLUSIVE-LOCK batch job; now a preview-and-approve UI with granular control."
        source="sports/sample-update-credit.p"
      />

      <BeforeAfter beforeContent={PROGRESS_SCREEN}>
        <div>
          {/* Controls */}
          <div style={{
            display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12,
            padding: 14, background: C.card, borderRadius: 8, marginBottom: 16,
          }}>
            <SliderInput
              label={`Threshold (Balance / Limit > ${(threshold * 100).toFixed(0)}%)`}
              value={threshold}
              min={0.5} max={1.0} step={0.05}
              onChange={setThreshold}
            />
            <SliderInput
              label={`Multiplier (New = Old × ${multiplier.toFixed(2)})`}
              value={multiplier}
              min={1.1} max={1.5} step={0.05}
              onChange={setMultiplier}
            />
          </div>

          {/* Summary */}
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 10, marginBottom: 16 }}>
            <StatCard label="Candidates" value={String(candidates.length)} color={C.amber} />
            <StatCard label="Approved" value={`${appliedCount} / ${candidates.length}`} color={C.green} />
            <StatCard label="Limit Increase" value={`+$${totalIncrease.toLocaleString()}`} color={C.ind} />
          </div>

          {candidates.length === 0 ? (
            <div style={{ padding: 30, textAlign: 'center', color: C.t3, border: `1px dashed ${C.bdr}`, borderRadius: 8 }}>
              No customers above the threshold. Try lowering it.
            </div>
          ) : (
            <>
              <div style={{ display: 'flex', gap: 8, marginBottom: 12, flexWrap: 'wrap' }}>
                <button
                  onClick={applyAll}
                  disabled={appliedCount === candidates.length}
                  style={{
                    padding: '7px 14px', borderRadius: 6, fontSize: 13, fontWeight: 700,
                    background: C.green, color: 'white', border: 'none',
                    cursor: appliedCount === candidates.length ? 'default' : 'pointer',
                    opacity: appliedCount === candidates.length ? 0.5 : 1,
                  }}
                >✓ Approve all {candidates.length}</button>
                {appliedCount > 0 && (
                  <button
                    onClick={reset}
                    style={{
                      padding: '7px 14px', borderRadius: 6, fontSize: 13, fontWeight: 700,
                      background: 'transparent', color: C.red, border: `1px solid ${C.red}`, cursor: 'pointer',
                    }}
                  >Reset</button>
                )}
              </div>

              <div style={{ background: 'white', border: `1px solid ${C.bdr}`, borderRadius: 8, overflow: 'hidden' }}>
                <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
                  <thead>
                    <tr>
                      {['#', 'Customer', 'Old Limit', 'Balance', 'Ratio', 'New Limit', 'Delta', 'Action'].map(h => (
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
                    {candidates.map(c => {
                      const done = applied.has(c.custNum);
                      const delta = c.newLimit - c.oldLimit;
                      return (
                        <tr key={c.custNum} style={{ borderTop: `1px solid ${C.bdr}`, background: done ? '#ecfdf5' : 'white' }}>
                          <td style={{ padding: '9px 12px', fontFamily: C.mono, color: C.t3 }}>#{c.custNum}</td>
                          <td style={{ padding: '9px 12px', fontWeight: 600 }}>{c.name}</td>
                          <td style={{ padding: '9px 12px', fontFamily: C.mono, textAlign: 'right' }}>
                            ${c.oldLimit.toLocaleString()}
                          </td>
                          <td style={{ padding: '9px 12px', fontFamily: C.mono, textAlign: 'right', fontWeight: 700 }}>
                            ${c.balance.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                          </td>
                          <td style={{ padding: '9px 12px', fontFamily: C.mono, textAlign: 'right' }}>
                            <span style={{
                              padding: '2px 8px', borderRadius: 20,
                              background: c.ratio > 0.9 ? '#fee2e2' : '#fef3c7',
                              color: c.ratio > 0.9 ? '#991b1b' : '#92400e',
                              fontWeight: 700,
                            }}>
                              {(c.ratio * 100).toFixed(0)}%
                            </span>
                          </td>
                          <td style={{ padding: '9px 12px', fontFamily: C.mono, textAlign: 'right', fontWeight: 700, color: C.green }}>
                            ${c.newLimit.toLocaleString()}
                          </td>
                          <td style={{ padding: '9px 12px', fontFamily: C.mono, textAlign: 'right', color: C.green }}>
                            +${delta.toLocaleString()}
                          </td>
                          <td style={{ padding: '9px 12px' }}>
                            {done ? (
                              <span style={{ fontSize: 11, color: C.green, fontWeight: 700 }}>✓ Applied</span>
                            ) : (
                              <button
                                onClick={() => apply(c.custNum)}
                                style={{
                                  padding: '5px 11px', borderRadius: 5, fontSize: 11, fontWeight: 700,
                                  background: C.ind, color: 'white', border: 'none', cursor: 'pointer',
                                }}
                              >Apply</button>
                            )}
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            </>
          )}
        </div>
      </BeforeAfter>
    </div>
  );
}

function SliderInput({ label, value, min, max, step, onChange }: { label: string; value: number; min: number; max: number; step: number; onChange: (v: number) => void }) {
  return (
    <div>
      <div style={{ fontSize: 11, fontWeight: 600, color: C.t2, marginBottom: 6 }}>{label}</div>
      <input
        type="range"
        min={min} max={max} step={step}
        value={value}
        onChange={e => onChange(parseFloat(e.target.value))}
        style={{ width: '100%', accentColor: C.ind }}
      />
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
      <div style={{ fontSize: 18, fontWeight: 800, color, marginTop: 3 }}>{value}</div>
    </div>
  );
}
