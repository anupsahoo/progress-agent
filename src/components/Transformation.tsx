import React, { useEffect, useRef, useState } from 'react';
import { CheckCircle2, ArrowRight, Columns2, RotateCcw, X } from 'lucide-react';
import { useLive } from '../data/live';
import { ESTATE } from '../data/estate';

/**
 * The "1-minute transformation": when modules switch from legacy to modern,
 * replay the change as a short story. Legacy estate -> module tiles flip ->
 * UI-to-UI field mapping -> the modern app.
 */
const FIELDS: [string, string][] = [
  ['Cust Num', 'Customer number'], ['Name', 'Name'], ['Address', 'Address'], ['City', 'City'],
  ['State', 'State'], ['Postal Code', 'Postal code'], ['Phone', 'Phone'],
];
const SAMPLE = ['3', 'Hoops', 'Suite 415', 'Atlanta', 'GA', '02112', '(617) 355-1557'];
const W = 36; // box width in characters
const TERM = [
  '┌─ Customer Maintenance ' + '─'.repeat(W - 25) + '┐',
  ...FIELDS.map(([l], i) => '│ ' + (l + ':').padEnd(13) + ' ' + SAMPLE[i].padEnd(W - 18) + '│'),
  '└' + '─'.repeat(W - 2) + '┘',
  ' F1=GO  F4=END-ERROR  F8=CLEAR',
].join('\n');

export function Transformation() {
  const live = useLive();
  const [open, setOpen] = useState(false);
  const [phase, setPhase] = useState(0);
  const [flipped, setFlipped] = useState(0);
  const firstCheck = useRef(true);
  const newly = useRef<string[]>([]);

  // Trigger when a refresh reports modules that became modern.
  useEffect(() => {
    if (!live.checkedAt) return;
    if (firstCheck.current) { firstCheck.current = false; return; }
    const became = live.changed.filter((id) => live.isModern(id));
    if (became.length) { newly.current = became; play(); }
  }, [live.checkedAt]); // eslint-disable-line react-hooks/exhaustive-deps

  // Manual replay from anywhere: window.dispatchEvent(new Event('pa:transform'))
  useEffect(() => {
    const f = () => { newly.current = ESTATE.modules.filter((m) => live.isModern(m.id)).map((m) => m.id); play(); };
    window.addEventListener('pa:transform', f);
    return () => window.removeEventListener('pa:transform', f);
  }, [live]);

  const timers = useRef<number[]>([]);
  const play = () => {
    timers.current.forEach(clearTimeout);
    setOpen(true); setPhase(0); setFlipped(0);
    const t = (ms: number, f: () => void) => timers.current.push(window.setTimeout(f, ms));
    t(2200, () => setPhase(1));
    ESTATE.modules.forEach((_, i) => t(2500 + i * 280, () => setFlipped(i + 1)));
    t(2500 + ESTATE.modules.length * 280 + 900, () => setPhase(2));
  };
  const close = (hash?: string) => { timers.current.forEach(clearTimeout); setOpen(false); if (hash) window.location.hash = hash; };

  if (!open) return null;
  const modern = ESTATE.modules.filter((m) => live.isModern(m.id));
  const modernSet = new Set(modern.map((m) => m.id));

  return (
    <div className="tx-root" role="dialog" aria-label="Modernization by FlowPilot AI">
      <button className="tx-close" onClick={() => close()} aria-label="Close"><X size={20} /></button>

      {phase === 0 && (
        <div className="tx-legacy">
          <pre className="tx-term">{`SPORTS2000 ENTERPRISE · MAIN MENU
Progress OpenEdge 12.7

${ESTATE.totalPrograms} programs · ${ESTATE.totalLines.toLocaleString('en-US')} lines · ${ESTATE.modules.length} modules`}<span className="tx-cursor">█</span></pre>
          <div className="tx-caption">Modernizing with <b>FlowPilot AI</b>…</div>
        </div>
      )}

      {phase === 1 && (
        <div className="tx-stage">
          <div className="tx-title">{Math.min(flipped, modern.length)} of {ESTATE.modules.length} modules modernized</div>
          <div className="tx-grid">
            {ESTATE.modules.map((m, i) => {
              const on = modernSet.has(m.id) && i < flipped;
              return (
                <div key={m.id} className={`tx-tile ${on ? 'on' : ''}`}>
                  <div className="tx-face tx-back"><span>{m.title}</span><code>{m.programs} ABL programs</code></div>
                  <div className="tx-face tx-front"><CheckCircle2 size={20} /><span>{m.title}</span><code>React + TypeScript</code></div>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {phase === 2 && (
        <div className="tx-stage">
          <div className="tx-title">Same data, same rules. A new experience.</div>
          <div className="tx-map">
            <pre className="tx-term small">{TERM}</pre>
            <svg className="tx-lines" viewBox="0 0 120 280" preserveAspectRatio="none" aria-hidden>
              {FIELDS.map((_, i) => (
                <path key={i} d={`M0 ${52 + i * 26} C 60 ${52 + i * 26}, 60 ${48 + i * 31}, 120 ${48 + i * 31}`} style={{ animationDelay: `${i * 0.18}s` }} />
              ))}
            </svg>
            <div className="tx-form">
              <div className="tx-form-h">Customer maintenance</div>
              {FIELDS.map(([, label], i) => (
                <label key={label} style={{ animationDelay: `${0.2 + i * 0.18}s` }}>
                  <span>{label}</span><input readOnly value={SAMPLE[i]} disabled={i === 0} />
                </label>
              ))}
            </div>
          </div>
          <div className="tx-actions">
            <button className="tx-btn primary" onClick={() => close('#dashboard')}>Open the modern app <ArrowRight size={18} /></button>
            <button className="tx-btn" onClick={() => { try { localStorage.setItem('sports2000.compare-mode', 'split'); } catch { /* ignore */ } close('#customer-maint'); }}><Columns2 size={18} /> Compare side by side</button>
            <button className="tx-btn" onClick={play}><RotateCcw size={18} /> Replay</button>
          </div>
          <div className="tx-foot">Modernized from Progress OpenEdge by FlowPilot AI · CogenSight</div>
        </div>
      )}
    </div>
  );
}

export const replayTransformation = () => window.dispatchEvent(new Event('pa:transform'));
void React;
