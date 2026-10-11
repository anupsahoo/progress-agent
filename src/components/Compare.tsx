import React, { useEffect, useLayoutEffect, useRef, useState } from 'react';
import { ArrowRight, Columns2, ExternalLink, MonitorSmartphone, MousePointerClick, SquareTerminal } from 'lucide-react';
import { ablSourceUrl } from '../data/modernization';

export type CompareMode = 'modern' | 'split' | 'legacy';
const MODE_KEY = 'sports2000.compare-mode';

function readMode(): CompareMode {
  try {
    const v = localStorage.getItem(MODE_KEY);
    if (v === 'modern' || v === 'split' || v === 'legacy') return v;
  } catch { /* storage unavailable */ }
  return 'split';
}

export function useCompareMode(): [CompareMode, (m: CompareMode) => void] {
  const [m, setM] = useState<CompareMode>(readMode);
  const set = (v: CompareMode) => {
    setM(v);
    try { localStorage.setItem(MODE_KEY, v); } catch { /* ignore */ }
  };
  return [m, set];
}

/** What a mapped element is, on each side, and where it lives in the ABL source. */
export interface MapInfo {
  legacy: string;
  modern: string;
  note?: string;
  lines?: [number, number];
  file?: string;
}

export function ModeToggle({ mode, onChange }: { mode: CompareMode; onChange: (m: CompareMode) => void }) {
  const opts: { id: CompareMode; label: string; icon: React.ReactNode }[] = [
    { id: 'modern', label: 'Modern', icon: <MonitorSmartphone size={17} /> },
    { id: 'split', label: 'Side by side', icon: <Columns2 size={17} /> },
    { id: 'legacy', label: 'Legacy', icon: <SquareTerminal size={17} /> },
  ];
  return (
    <div className="mode-toggle" role="radiogroup" aria-label="Compare mode">
      {opts.map((o) => (
        <button key={o.id} role="radio" aria-checked={mode === o.id} className={mode === o.id ? 'on' : ''} onClick={() => onChange(o.id)}>
          {o.icon}<span>{o.label}</span>
        </button>
      ))}
    </div>
  );
}

/** Finds the data-map key under an event target, if any. */
function keyOf(t: EventTarget | null): string | null {
  const el = (t as HTMLElement | null)?.closest?.('[data-map]') as HTMLElement | null;
  return el?.dataset.map || null;
}

/**
 * Legacy terminal on the left, modern screen on the right. Hovering or
 * focusing any mapped element highlights its counterpart and draws a
 * connector between them; the inspector bar explains the translation.
 */
export function CompareSplit({ legacy, children, describe, source, legacyLabel }: {
  legacy: React.ReactNode;
  children: React.ReactNode;
  describe: (key: string) => MapInfo | undefined;
  source: string;
  legacyLabel?: string;
}) {
  const [hover, setHover] = useState<string | null>(null);
  const [focus, setFocus] = useState<string | null>(null);
  const active = hover ?? focus;
  const info = active ? describe(active) : undefined;
  const root = useRef<HTMLDivElement>(null);
  const path = useRef<SVGPathElement>(null);
  const glow = useRef<SVGPathElement>(null);
  const dotA = useRef<SVGCircleElement>(null);
  const dotB = useRef<SVGCircleElement>(null);

  // Draw the connector directly on the SVG (no React state), so it can
  // follow scrolling and typing without re-rendering the screen.
  const draw = () => {
    const r = root.current;
    const hide = () => { [path, glow].forEach((p) => p.current?.setAttribute('d', '')); [dotA, dotB].forEach((d) => d.current?.setAttribute('r', '0')); };
    if (!r || !active || !info) return hide();
    const sel = `[data-map="${CSS.escape(active)}"]`;
    const a = r.querySelector(`.cmp-legacy ${sel}`) as HTMLElement | null;
    const b = r.querySelector(`.cmp-modern ${sel}`) as HTMLElement | null;
    if (!a || !b) return hide();
    const o = r.getBoundingClientRect();
    const ra = a.getBoundingClientRect();
    const rb = b.getBoundingClientRect();
    if (!ra.width || !rb.width) return hide();
    const x1 = ra.right - o.left + 3, y1 = ra.top + ra.height / 2 - o.top;
    const x2 = rb.left - o.left - 3, y2 = rb.top + Math.min(rb.height / 2, 22) - o.top;
    const dx = Math.max(40, (x2 - x1) * 0.5);
    const d = `M${x1},${y1} C${x1 + dx},${y1} ${x2 - dx},${y2} ${x2},${y2}`;
    path.current?.setAttribute('d', d);
    glow.current?.setAttribute('d', d);
    dotA.current?.setAttribute('cx', String(x1)); dotA.current?.setAttribute('cy', String(y1)); dotA.current?.setAttribute('r', '4.5');
    dotB.current?.setAttribute('cx', String(x2)); dotB.current?.setAttribute('cy', String(y2)); dotB.current?.setAttribute('r', '4.5');
  };

  useLayoutEffect(draw);
  useEffect(() => {
    let raf = 0;
    const on = () => { cancelAnimationFrame(raf); raf = requestAnimationFrame(draw); };
    window.addEventListener('scroll', on, true);
    window.addEventListener('resize', on);
    return () => { window.removeEventListener('scroll', on, true); window.removeEventListener('resize', on); cancelAnimationFrame(raf); };
  });

  const css = active
    ? `.cmp-legacy [data-map="${CSS.escape(active)}"]{background:var(--t-fg)!important;color:var(--t-bg)!important;text-shadow:none!important;border-radius:2px;box-shadow:0 0 0 2px var(--t-fg),0 0 18px var(--t-glow)}` +
      `.cmp-legacy [data-map="${CSS.escape(active)}"] *{color:var(--t-bg)!important;text-shadow:none!important}` +
      `.cmp-modern [data-map="${CSS.escape(active)}"]:not(tr){outline:2px solid var(--color-accent);outline-offset:3px;border-radius:8px;box-shadow:0 0 0 6px rgba(58,154,46,.14)}` +
      `.cmp-modern tr[data-map="${CSS.escape(active)}"] td{background:#EEF8EC!important;box-shadow:inset 0 2px 0 #3A9A2E,inset 0 -2px 0 #3A9A2E}`
    : '';

  return (
    <div
      className={`cmp ${active ? 'tracing' : ''}`}
      ref={root}
      onMouseOver={(e) => setHover(keyOf(e.target))}
      onMouseLeave={() => setHover(null)}
      onFocus={(e) => setFocus(keyOf(e.target))}
      onBlur={() => setFocus(null)}
    >
      <style>{css}</style>
      <div className={`cmp-inspector ${info ? 'on' : ''}`} aria-live="polite">
        {info ? (
          <>
            <div className="ci-row">
              <span className="ci-side legacy"><span className="ci-k">ABL</span><code title={info.legacy}>{info.legacy}</code></span>
              <ArrowRight size={18} className="ci-arrow" />
              <span className="ci-side modern"><span className="ci-k">Modern</span><code title={info.modern}>{info.modern}</code></span>
            </div>
            <div className="ci-row">
              <span className="ci-note">{info.note ?? ''}</span>
              {info.lines && (
                <a className="ci-src" href={ablSourceUrl(info.file ?? source, info.lines)} target="_blank" rel="noopener noreferrer">
                  {(info.file ?? source).split('/').pop()}:{info.lines[0]}{info.lines[1] !== info.lines[0] ? `–${info.lines[1]}` : ''}<ExternalLink size={13} />
                </a>
              )}
            </div>
          </>
        ) : (
          <span className="ci-hint"><MousePointerClick size={17} /> Hover or click into any field on either side to trace how it was translated. Both screens share one state: type in either and the other follows.</span>
        )}
      </div>
      <div className="cmp-grid">
        <div className="cmp-pane cmp-legacy">
          <div className="cmp-sticky">
            <div className="cmp-label legacy"><SquareTerminal size={15} /> Before · Progress character UI <span className="cmp-file">{legacyLabel ?? source}</span></div>
            {legacy}
          </div>
        </div>
        <div className="cmp-pane cmp-modern">
          <div className="cmp-label modern"><MonitorSmartphone size={15} /> After · React + TypeScript <span className="cmp-file">Same data, same rules</span></div>
          <div className="stack">{children}</div>
        </div>
      </div>
      <svg className="cmp-wires" aria-hidden>
        <defs>
          <linearGradient id="wire-g" x1="0" x2="1" y1="0" y2="0">
            <stop offset="0" stopColor="#3A9A2E" /><stop offset="1" stopColor="#1F4E9E" />
          </linearGradient>
        </defs>
        <path ref={glow} className="w-glow" />
        <path ref={path} className="w-line" />
        <circle ref={dotA} className="w-dot a" r="0" />
        <circle ref={dotB} className="w-dot b" r="0" />
      </svg>
    </div>
  );
}

/** The legacy screen on its own, large and centred. */
export function LegacyStage({ children, hint }: { children: React.ReactNode; hint?: React.ReactNode }) {
  return (
    <div className="legacy-stage">
      {children}
      {hint && <p className="legacy-hint">{hint}</p>}
    </div>
  );
}
