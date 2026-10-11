import React, { useLayoutEffect, useRef, useState } from 'react';

/**
 * A Progress OpenEdge character-mode screen, rendered on a fixed character
 * grid. Every screen builds its terminal from the same React state as the
 * modern UI, so the two sides always show the same values. Elements carry a
 * `data-map` key; the compare view uses it to trace a legacy field to its
 * modern counterpart.
 */

export type TermTheme = 'green' | 'amber' | 'blue';
const THEME_KEY = 'sports2000.term-theme';
const THEMES: { id: TermTheme; label: string }[] = [
  { id: 'green', label: 'Phosphor' },
  { id: 'amber', label: 'Amber' },
  { id: 'blue', label: 'Progress blue' },
];

function readTheme(): TermTheme {
  try {
    const v = localStorage.getItem(THEME_KEY);
    if (v === 'green' || v === 'amber' || v === 'blue') return v;
  } catch { /* storage unavailable */ }
  return 'green';
}

/** Shared theme so every terminal on the page switches together. */
const listeners = new Set<(t: TermTheme) => void>();
function useTermTheme(): [TermTheme, (t: TermTheme) => void] {
  const [t, setT] = useState<TermTheme>(readTheme);
  useLayoutEffect(() => {
    listeners.add(setT);
    return () => { listeners.delete(setT); };
  }, []);
  const set = (v: TermTheme) => {
    try { localStorage.setItem(THEME_KEY, v); } catch { /* ignore */ }
    listeners.forEach((l) => l(v));
  };
  return [t, set];
}

/** Width of one monospace character as a fraction of the font size. */
let CH_RATIO = 0;
function chRatio() {
  if (CH_RATIO) return CH_RATIO;
  const s = document.createElement('span');
  s.style.cssText = 'position:absolute;visibility:hidden;white-space:pre;font-size:100px;font-family:var(--font-mono);font-variant-ligatures:none';
  s.textContent = 'M'.repeat(50);
  document.body.appendChild(s);
  const r = s.getBoundingClientRect().width / 5000;
  s.remove();
  if (r > 0.3 && r < 1) CH_RATIO = r;
  return r || 0.6;
}

export interface FKey { k: string; label: string; onClick?: () => void; title?: string }
export interface TermAlert { kind: 'error' | 'info'; text: string; onOk?: () => void; map?: string }

export function Terminal({
  program, cols = 64, rows = 20, status, fkeys = [], alert, children, maxFont = 17, minFont = 10, tabs,
}: {
  program: string;
  cols?: number;
  rows?: number;
  status?: React.ReactNode;
  fkeys?: FKey[];
  alert?: TermAlert | null;
  children: React.ReactNode;
  maxFont?: number;
  minFont?: number;
  tabs?: React.ReactNode;
}) {
  const [theme, setTheme] = useTermTheme();
  const screen = useRef<HTMLDivElement>(null);
  const [font, setFont] = useState(14);

  useLayoutEffect(() => {
    const el = screen.current;
    if (!el) return;
    const measure = () => {
      const pad = 40;
      const w = el.clientWidth - pad;
      const f = w / ((cols + 0.5) * chRatio());
      setFont(Math.max(minFont, Math.min(maxFont, Math.floor(f * 10) / 10)));
    };
    measure();
    const ro = new ResizeObserver(measure);
    ro.observe(el);
    // Re-measure once the web font has loaded (character width changes).
    (document as Document & { fonts?: FontFaceSet }).fonts?.ready.then(() => { CH_RATIO = 0; measure(); });
    return () => ro.disconnect();
  }, [cols, maxFont, minFont]);

  return (
    <div className={`term-win term-${theme}`}>
      <div className="term-bar">
        <span className="term-dots" aria-hidden><i /><i /><i /></span>
        <span className="term-title"><b>_progres</b> -db sports2000 -p {program}</span>
        <span className="term-themes" role="group" aria-label="Terminal colours">
          {THEMES.map((t) => (
            <button key={t.id} className={`tt-${t.id} ${theme === t.id ? 'on' : ''}`} onClick={() => setTheme(t.id)}
              title={t.label} aria-label={`${t.label} colours`} aria-pressed={theme === t.id} />
          ))}
        </span>
      </div>
      {tabs && <div className="term-tabs">{tabs}</div>}
      <div className="term-screen" ref={screen} style={{ fontSize: font }}>
        <div className="term-inner" style={{ width: `${cols}ch` }}>
          <div className="term-grid" style={{ minHeight: `${rows * 1.32}em` }}>{children}</div>
          {alert && <TAlertBox alert={alert} cols={cols} />}
          {status != null && <div className="term-status">{status}</div>}
          {fkeys.length > 0 && <div className="term-fkeys">
            {fkeys.map((f) => (
              <button key={f.k} type="button" onClick={f.onClick} disabled={!f.onClick} title={f.title} data-map={`fkey-${f.k}`}>
                <b>{f.k}</b>={f.label}
              </button>
            ))}
          </div>}
        </div>
        <div className="term-scan" aria-hidden />
      </div>
    </div>
  );
}

/** VIEW-AS ALERT-BOX, drawn with box characters and centred on the screen. */
function TAlertBox({ alert, cols }: { alert: TermAlert; cols: number }) {
  const title = alert.kind === 'error' ? ' Error ' : ' Information ';
  const w = Math.min(cols - 6, Math.max(alert.text.length + 6, 30));
  const inner = w - 2;
  const side = inner - title.length;
  const top = '┌' + '─'.repeat(Math.floor(side / 2)) + title + '─'.repeat(Math.ceil(side / 2)) + '┐';
  const pad = (s: string) => {
    const l = Math.floor((inner - s.length) / 2);
    return ' '.repeat(l) + s + ' '.repeat(inner - s.length - l);
  };
  const ok = useRef<HTMLButtonElement>(null);
  return (
    <div className={`term-alert ${alert.kind}`} role={alert.kind === 'error' ? 'alert' : 'status'} data-map={alert.map}>
      <div>{top}</div>
      <div>│{pad('')}│</div>
      <div>│{pad(alert.text)}│</div>
      <div>│{pad('')}│</div>
      <div>│{' '.repeat(Math.floor((inner - 8) / 2))}<button ref={ok} type="button" onClick={alert.onOk} className="term-ok">&lt; OK &gt;</button>{' '.repeat(inner - 8 - Math.floor((inner - 8) / 2))}│</div>
      <div>└{'─'.repeat(inner)}┘</div>
    </div>
  );
}

/* ---------------- grid primitives ---------------- */

/** One character row. */
export function TLine({ children, map, className }: { children?: React.ReactNode; map?: string; className?: string }) {
  return <div className={`tl ${className || ''}`} data-map={map}>{children ?? ' '}</div>;
}

/** Plain text, optionally padded to a fixed width. */
export function TT({ children, w, map, dim, bright, right }: { children: string; w?: number; map?: string; dim?: boolean; bright?: boolean; right?: boolean }) {
  const s = w == null ? children : right ? children.slice(0, w).padStart(w) : children.slice(0, w).padEnd(w);
  return <span className={`${dim ? 'td' : ''} ${bright ? 'tb' : ''}`} data-map={map}>{s}</span>;
}

/** SIDE-LABELS with COLON n: label right-aligned so the colon sits in column n. */
export function TLabel({ children, colon = 15 }: { children: string; colon?: number }) {
  return <span className="tlab">{(children + ':').padStart(colon) + ' '}</span>;
}

/** A field. Editable (UPDATE) when onChange is given, display-only (DISPLAY) otherwise. */
export function TField({
  value, width, map, onChange, onKeyDown, inputRef, label, numeric,
}: {
  value: string;
  width: number;
  map?: string;
  onChange?: (v: string) => void;
  onKeyDown?: (e: React.KeyboardEvent<HTMLInputElement>) => void;
  inputRef?: React.Ref<HTMLInputElement>;
  label?: string;
  numeric?: boolean;
}) {
  if (onChange) {
    return (
      <input
        ref={inputRef}
        className="tf"
        style={{ width: `${width}ch` }}
        value={value}
        maxLength={width}
        spellCheck={false}
        autoComplete="off"
        inputMode={numeric ? 'numeric' : undefined}
        aria-label={label}
        data-map={map}
        onChange={(e) => onChange(numeric ? e.target.value.replace(/[^0-9]/g, '') : e.target.value)}
        onKeyDown={onKeyDown}
      />
    );
  }
  return <span className="tv" data-map={map}>{value.slice(0, width).padEnd(width)}</span>;
}

/**
 * A frame with a box border and an optional centred title. `lines` are the
 * rows inside the border; each is clipped/padded to the inner width.
 */
export function TFrame({ title, width, lines, map }: { title?: string; width: number; lines: React.ReactNode[]; map?: string }) {
  const inner = width - 2;
  const t = title ? ` ${title} ` : '';
  const side = inner - t.length;
  return (
    <div className="tframe">
      <div className="tl" data-map={map}>┌{'─'.repeat(Math.floor(side / 2))}{t && <span className="ttitle">{t}</span>}{'─'.repeat(Math.ceil(side / 2))}┐</div>
      {lines.map((l, i) => (
        <div className="tl" key={i}>│<span className="tcell" style={{ width: `${inner}ch` }}>{l ?? ''}</span>│</div>
      ))}
      <div className="tl">└{'─'.repeat(inner)}┘</div>
    </div>
  );
}

/** Keyboard behaviour of an UPDATE statement: RETURN moves on, F1 is GO, F4/ESC is END-ERROR. */
export function ablKeys(opts: { onGo?: () => void; onEnd?: () => void; onNext?: () => void }) {
  return (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'F1') { e.preventDefault(); opts.onGo?.(); }
    else if (e.key === 'F4' || e.key === 'Escape') { e.preventDefault(); opts.onEnd?.(); }
    else if (e.key === 'Enter') { e.preventDefault(); (opts.onNext ?? opts.onGo)?.(); }
  };
}
