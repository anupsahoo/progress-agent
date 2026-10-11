import React, { useMemo, useState } from 'react';
import { Clock, PiggyBank, Zap } from 'lucide-react';
import { Card, Kpi, PageHeader } from '../components/ui';
import { T, fmtMoney0 } from '../theme';

/** Business case for modernization. Numbers update live as inputs change. */
export function ROI() {
  const [programs, setPrograms] = useState(200);
  const [costPerProgram, setCostPerProgram] = useState(15000);
  const [daysPerProgram, setDaysPerProgram] = useState(8);
  const [fpCost, setFpCost] = useState(2000);
  const [fpDays, setFpDays] = useState(0.4);

  const m = useMemo(() => {
    const manualTotalCost = programs * costPerProgram;
    const manualTotalDays = programs * daysPerProgram;
    const fpTotalCost = programs * fpCost;
    const fpTotalDays = programs * fpDays;
    const savings = manualTotalCost - fpTotalCost;
    const monthsSaved = (manualTotalDays - fpTotalDays) / 22;
    const speedup = daysPerProgram / Math.max(fpDays, 0.05);
    const reductionPct = (savings / manualTotalCost) * 100;
    return { manualTotalCost, manualTotalDays, fpTotalCost, fpTotalDays, savings, monthsSaved, speedup, reductionPct };
  }, [programs, costPerProgram, daysPerProgram, fpCost, fpDays]);

  const millions = (n: number) => `$${(n / 1_000_000).toFixed(2)}M`;

  return (
    <>
      <PageHeader
        title="ROI calculator"
        crumbs={['Modernization', 'ROI']}
        subtitle="Estimate the cost and time of modernizing a Progress OpenEdge portfolio with FlowPilot compared with a traditional manual rewrite."
      />

      <div className="stack">
        <div className="grid-kpi" style={{ gridTemplateColumns: 'repeat(3, minmax(0, 1fr))' }}>
          <Kpi label="Total cost saved" value={millions(m.savings)} tone="success" icon={<PiggyBank size={18} />} foot={`${m.reductionPct.toFixed(0)}% lower than a manual rewrite`} />
          <Kpi label="Delivery time saved" value={`${m.monthsSaved.toFixed(1)} months`} tone="brand" icon={<Clock size={18} />} foot="At 22 working days per month" />
          <Kpi label="Faster per program" value={`${m.speedup.toFixed(0)}x`} tone="warning" icon={<Zap size={18} />} foot={`${daysPerProgram} days down to ${fpDays.toFixed(1)} days`} />
        </div>

        <div className="grid-2">
          <Card title="Traditional manual modernization" sub="Consulting led rewrite">
            <Slider label="Programs in your portfolio" value={programs} min={10} max={2000} step={10} format={(v) => v.toLocaleString()} onChange={setPrograms} />
            <Slider label="Cost per program" value={costPerProgram} min={2000} max={40000} step={500} format={fmtMoney0} onChange={setCostPerProgram} />
            <Slider label="Days per program" value={daysPerProgram} min={2} max={30} step={1} format={(v) => `${v} days`} onChange={setDaysPerProgram} />
            <Stat label="Total cost" value={fmtMoney0(m.manualTotalCost)} />
            <Stat label="Total time" value={`${(m.manualTotalDays / 22).toFixed(1)} months`} />
          </Card>
          <Card title="FlowPilot AI-DLC" sub="Governed, agent driven modernization">
            <Slider label="Cost per program" value={fpCost} min={500} max={5000} step={100} format={fmtMoney0} onChange={setFpCost} />
            <Slider label="Days per program, including human review" value={fpDays} min={0.1} max={3} step={0.1} format={(v) => `${v.toFixed(1)} days`} onChange={setFpDays} />
            <Stat label="Total cost" value={fmtMoney0(m.fpTotalCost)} good />
            <Stat label="Total time" value={`${(m.fpTotalDays / 22).toFixed(1)} months`} good />
            <div className="alert info" style={{ marginTop: 16, fontSize: 14 }}>
              <span>Each program includes an approved spec, generated tests, a multi-agent build, a behavioural parity check and a reviewed pull request.</span>
            </div>
          </Card>
        </div>

        <Card title="Cost comparison" sub={`${programs.toLocaleString()} programs`}>
          <Bar label="Manual modernization" value={m.manualTotalCost} max={Math.max(m.manualTotalCost, m.fpTotalCost)} color="#94a3b8" />
          <Bar label="FlowPilot" value={m.fpTotalCost} max={Math.max(m.manualTotalCost, m.fpTotalCost)} color={T.color.brand} />
          <p className="muted" style={{ margin: '14px 0 0', fontSize: 14.5 }}>
            Modernizing <b style={{ color: T.color.text }}>{programs.toLocaleString()}</b> programs costs {millions(m.fpTotalCost)} with FlowPilot instead of {millions(m.manualTotalCost)}, and finishes {m.monthsSaved.toFixed(1)} months sooner.
          </p>
        </Card>

        <Card title="Assumptions">
          <ul style={{ paddingLeft: 20, margin: 0, color: T.color.textSecondary, lineHeight: 1.8 }}>
            <li>Manual cost includes consulting time, project management, QA and infrastructure setup.</li>
            <li>FlowPilot cost includes model usage, platform fees and human review and approval time.</li>
            <li>Days per program is calendar time from kickoff to a merged pull request.</li>
            <li>Months are calculated at 22 working days per month.</li>
            <li>Figures exclude one-time onboarding, typically two weeks per engagement.</li>
          </ul>
        </Card>
      </div>
    </>
  );
}

function Slider({ label, value, min, max, step, format, onChange }: { label: string; value: number; min: number; max: number; step: number; format: (v: number) => string; onChange: (v: number) => void }) {
  return (
    <div className="field" style={{ marginBottom: 18 }}>
      <label style={{ justifyContent: 'space-between' }}>{label}<span className="num" style={{ color: T.color.text, fontWeight: 700 }}>{format(value)}</span></label>
      <input className="range" type="range" min={min} max={max} step={step} value={value} onChange={(e) => onChange(parseFloat(e.target.value))} aria-label={label} />
    </div>
  );
}

function Stat({ label, value, good }: { label: string; value: string; good?: boolean }) {
  return (
    <div className="row" style={{ justifyContent: 'space-between', padding: '12px 0', borderTop: `1px solid ${T.color.border}` }}>
      <span className="muted">{label}</span>
      <span className="num" style={{ fontSize: 19, fontWeight: 700, color: good ? T.color.success : T.color.text }}>{value}</span>
    </div>
  );
}

function Bar({ label, value, max, color }: { label: string; value: number; max: number; color: string }) {
  return (
    <div style={{ marginBottom: 14 }}>
      <div className="row" style={{ justifyContent: 'space-between', marginBottom: 6, fontSize: 14.5 }}>
        <span>{label}</span><span className="num" style={{ fontWeight: 700 }}>{fmtMoney0(value)}</span>
      </div>
      <div style={{ height: 14, background: T.color.surfaceSunken, borderRadius: 7, overflow: 'hidden' }}>
        <div style={{ width: `${(value / max) * 100}%`, height: '100%', background: color, borderRadius: 7, transition: 'width .3s' }} />
      </div>
    </div>
  );
}
