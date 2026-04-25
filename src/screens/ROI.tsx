import React, { useMemo, useState } from 'react';
import { C, PageHeader } from '../components/Shell';

/**
 * ROI / business case for modernization. Numbers update live as the user
 * drags the sliders. Designed for product/services VPs who think in
 * spreadsheets — not engineers.
 */

export function ROI() {
  const [programs, setPrograms] = useState(200);
  const [costPerProgram, setCostPerProgram] = useState(15000);
  const [daysPerProgram, setDaysPerProgram] = useState(8);
  const [flowpilotCostPerProgram, setFlowpilotCostPerProgram] = useState(2000);
  const [flowpilotDaysPerProgram, setFlowpilotDaysPerProgram] = useState(0.4);

  const m = useMemo(() => {
    const manualTotalCost = programs * costPerProgram;
    const manualTotalDays = programs * daysPerProgram;
    const flowpilotTotalCost = programs * flowpilotCostPerProgram;
    const flowpilotTotalDays = programs * flowpilotDaysPerProgram;
    const savings = manualTotalCost - flowpilotTotalCost;
    const monthsSaved = (manualTotalDays - flowpilotTotalDays) / 22; // working days
    const speedup = daysPerProgram / Math.max(flowpilotDaysPerProgram, 0.05);
    const reductionPct = ((manualTotalCost - flowpilotTotalCost) / manualTotalCost) * 100;
    return {
      manualTotalCost, manualTotalDays,
      flowpilotTotalCost, flowpilotTotalDays,
      savings, monthsSaved, speedup, reductionPct,
    };
  }, [programs, costPerProgram, daysPerProgram, flowpilotCostPerProgram, flowpilotDaysPerProgram]);

  return (
    <div>
      <PageHeader
        title="ROI Calculator"
        subtitle="Estimate cost and time savings of FlowPilot AI vs traditional manual modernization for your Progress portfolio."
      />

      {/* Headline savings */}
      <div style={{
        background: `linear-gradient(135deg, ${C.green} 0%, #059669 100%)`,
        color: 'white', borderRadius: 16, padding: 32, marginBottom: 28,
        boxShadow: '0 10px 30px rgba(16, 185, 129, 0.3)',
      }}>
        <div style={{ fontSize: 11, fontWeight: 700, letterSpacing: '0.1em', textTransform: 'uppercase', opacity: 0.85, marginBottom: 10 }}>
          Estimated savings
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 24, marginBottom: 4 }}>
          <Headline value={`$${(m.savings / 1_000_000).toFixed(2)}M`} label="Total cost saved" />
          <Headline value={`${m.monthsSaved.toFixed(1)}`} label="Months saved" />
          <Headline value={`${m.speedup.toFixed(0)}×`} label="Faster per program" />
        </div>
        <div style={{ fontSize: 13, marginTop: 12, opacity: 0.92, lineHeight: 1.6 }}>
          Modernizing <strong>{programs}</strong> Progress programs with FlowPilot AI costs ${(m.flowpilotTotalCost / 1_000_000).toFixed(2)}M instead of ${(m.manualTotalCost / 1_000_000).toFixed(2)}M — a <strong>{m.reductionPct.toFixed(0)}% reduction</strong> in cost and a <strong>{m.monthsSaved.toFixed(1)}-month</strong> shorter delivery window.
        </div>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 20, marginBottom: 28 }}>
        {/* Manual side */}
        <Pane title="Traditional manual modernization" color={C.red} subtle>
          <Slider
            label="Programs in your portfolio"
            value={programs}
            min={10} max={2000} step={10}
            format={(v) => v.toLocaleString()}
            onChange={setPrograms}
          />
          <Slider
            label="Cost per program (consulting)"
            value={costPerProgram}
            min={2000} max={40000} step={500}
            format={(v) => `$${v.toLocaleString()}`}
            onChange={setCostPerProgram}
          />
          <Slider
            label="Days per program"
            value={daysPerProgram}
            min={2} max={30} step={1}
            format={(v) => `${v} days`}
            onChange={setDaysPerProgram}
          />
          <Stat label="Total cost" value={`$${m.manualTotalCost.toLocaleString()}`} color={C.red} />
          <Stat label="Total time" value={`${(m.manualTotalDays / 22).toFixed(1)} months`} color={C.red} />
        </Pane>

        {/* FlowPilot side */}
        <Pane title="FlowPilot AI workflow" color={C.green}>
          <Slider
            label="Cost per program (FlowPilot)"
            value={flowpilotCostPerProgram}
            min={500} max={5000} step={100}
            format={(v) => `$${v.toLocaleString()}`}
            onChange={setFlowpilotCostPerProgram}
          />
          <Slider
            label="Days per program (with human review)"
            value={flowpilotDaysPerProgram}
            min={0.1} max={3} step={0.1}
            format={(v) => `${v.toFixed(1)} days`}
            onChange={setFlowpilotDaysPerProgram}
          />
          <Stat label="Total cost" value={`$${m.flowpilotTotalCost.toLocaleString()}`} color={C.green} />
          <Stat label="Total time" value={`${(m.flowpilotTotalDays / 22).toFixed(1)} months`} color={C.green} />
          <div style={{
            marginTop: 14, padding: '10px 14px', borderRadius: 8,
            background: C.green + '12', fontSize: 12, color: C.green, lineHeight: 1.6,
          }}>
            <strong>Includes</strong>: 3 PRs per program (UI / UI tests / API + tests),
            generated requirements doc, GitHub Actions CI/CD, Pages deploy.
          </div>
        </Pane>
      </div>

      {/* Bar chart */}
      <Chart manual={m.manualTotalCost} flowpilot={m.flowpilotTotalCost} />

      {/* Assumptions */}
      <Assumptions />
    </div>
  );
}

/* ─── Subcomponents ─────────────────────────────────────── */

function Headline({ value, label }: { value: string; label: string }) {
  return (
    <div>
      <div style={{ fontSize: 36, fontWeight: 800, letterSpacing: '-0.02em', lineHeight: 1 }}>{value}</div>
      <div style={{ fontSize: 13, opacity: 0.85, marginTop: 6 }}>{label}</div>
    </div>
  );
}

function Pane({ title, color, subtle, children }: { title: string; color: string; subtle?: boolean; children: React.ReactNode }) {
  return (
    <div style={{
      background: 'white',
      border: `1px solid ${C.bdr}`,
      borderTop: `3px solid ${color}`,
      borderRadius: 12,
      padding: 22,
      opacity: subtle ? 0.96 : 1,
    }}>
      <div style={{
        fontSize: 11, fontWeight: 700, color, fontFamily: C.mono,
        textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: 16,
      }}>
        {title}
      </div>
      {children}
    </div>
  );
}

function Slider({ label, value, min, max, step, format, onChange }: { label: string; value: number; min: number; max: number; step: number; format: (v: number) => string; onChange: (v: number) => void }) {
  return (
    <div style={{ marginBottom: 18 }}>
      <div style={{ display: 'flex', alignItems: 'baseline', marginBottom: 6 }}>
        <div style={{ fontSize: 12, fontWeight: 600, color: C.t2 }}>{label}</div>
        <div style={{ marginLeft: 'auto', fontSize: 14, fontWeight: 800, color: C.t1, fontFamily: C.mono }}>
          {format(value)}
        </div>
      </div>
      <input
        type="range"
        min={min} max={max} step={step}
        value={value}
        onChange={(e) => onChange(parseFloat(e.target.value))}
        style={{ width: '100%', accentColor: C.ind }}
      />
    </div>
  );
}

function Stat({ label, value, color }: { label: string; value: string; color: string }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'baseline', justifyContent: 'space-between',
      padding: '10px 0', borderTop: `1px solid ${C.bdr}`,
    }}>
      <div style={{ fontSize: 12, color: C.t3, fontWeight: 600, fontFamily: C.mono, textTransform: 'uppercase', letterSpacing: '0.04em' }}>
        {label}
      </div>
      <div style={{ fontSize: 18, fontWeight: 800, color, fontFamily: C.mono }}>
        {value}
      </div>
    </div>
  );
}

function Chart({ manual, flowpilot }: { manual: number; flowpilot: number }) {
  const max = Math.max(manual, flowpilot, 1);
  return (
    <div style={{
      background: 'white', border: `1px solid ${C.bdr}`, borderRadius: 12,
      padding: 22, marginBottom: 28,
    }}>
      <div style={{
        fontSize: 11, fontWeight: 700, color: C.t3, fontFamily: C.mono,
        textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: 18,
      }}>
        Cost comparison
      </div>
      <BarRow label="Manual modernization" value={manual} max={max} color={C.red} />
      <BarRow label="FlowPilot AI" value={flowpilot} max={max} color={C.green} />
    </div>
  );
}

function BarRow({ label, value, max, color }: { label: string; value: number; max: number; color: string }) {
  const pct = (value / max) * 100;
  return (
    <div style={{ marginBottom: 14 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 12, marginBottom: 5, color: C.t2 }}>
        <span>{label}</span>
        <span style={{ fontFamily: C.mono, fontWeight: 700, color: C.t1 }}>${value.toLocaleString()}</span>
      </div>
      <div style={{ width: '100%', height: 14, background: C.bdr, borderRadius: 7, overflow: 'hidden' }}>
        <div style={{
          width: `${pct}%`, height: '100%',
          background: `linear-gradient(90deg, ${color} 0%, ${color}cc 100%)`,
          transition: 'width 0.3s',
        }} />
      </div>
    </div>
  );
}

function Assumptions() {
  return (
    <div style={{
      background: 'white', border: `1px solid ${C.bdr}`, borderRadius: 12,
      padding: 22, fontSize: 13,
    }}>
      <div style={{
        fontSize: 11, fontWeight: 700, color: C.t3, fontFamily: C.mono,
        textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: 12,
      }}>
        Assumptions
      </div>
      <ul style={{ paddingLeft: 20, margin: 0, color: C.t2, lineHeight: 1.8 }}>
        <li>Manual cost includes consulting time, project management, QA, and infrastructure setup.</li>
        <li>FlowPilot cost includes LLM API usage, FlowPilot platform fees, and human review/approval time.</li>
        <li>"Days per program" is end-to-end calendar days from kickoff to deployed PR.</li>
        <li>Months calculated at 22 working days per month.</li>
        <li>Numbers exclude one-time onboarding (typically 2 weeks, applies once per customer).</li>
      </ul>
    </div>
  );
}
