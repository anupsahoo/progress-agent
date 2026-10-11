import React, { useLayoutEffect, useRef, useState } from 'react';
import {
  BadgeCheck, Check, ExternalLink, FileCode2, FlaskConical, GitPullRequest, Github, Maximize2,
  PanelRightClose, PanelRightOpen, Scale, Sparkles,
} from 'lucide-react';
import { PROGRAMS, LIFECYCLE, PULLS_URL, REPO_URL, type ProgramId } from '../data/modernization';
import { Modal, PageHeader } from './ui';

const STORAGE_KEY = 'sports2000.mp-open';

function initialOpen() {
  try {
    const v = localStorage.getItem(STORAGE_KEY);
    if (v !== null) return v === '1';
  } catch { /* storage unavailable */ }
  return typeof window !== 'undefined' ? window.innerWidth >= 1360 : true;
}

/** Page layout for every modernized screen: header, content and the provenance panel. */
export function ModernizedLayout({ program, title, subtitle, crumbs, actions, legacyScreen, children }: {
  program: ProgramId;
  title: string;
  subtitle?: React.ReactNode;
  crumbs?: string[];
  actions?: React.ReactNode;
  legacyScreen: string;
  children: React.ReactNode;
}) {
  const [open, setOpen] = useState(initialOpen);
  const set = (v: boolean) => {
    setOpen(v);
    try { localStorage.setItem(STORAGE_KEY, v ? '1' : '0'); } catch { /* ignore */ }
  };
  return (
    <>
      <PageHeader
        title={title}
        subtitle={subtitle}
        crumbs={crumbs}
        actions={
          <>
            {actions}
            {!open && (
              <button className="mp-toggle no-print" onClick={() => set(true)}>
                <PanelRightOpen size={17} /> How this was modernized
              </button>
            )}
          </>
        }
      />
      <div className={`page ${open ? 'with-panel' : ''}`}>
        <div className="stack" style={{ minWidth: 0 }}>{children}</div>
        {open && <ModernizationPanel program={program} legacyScreen={legacyScreen} onClose={() => set(false)} />}
      </div>
    </>
  );
}

export function ModernizationPanel({ program, legacyScreen, onClose }: { program: ProgramId; legacyScreen: string; onClose: () => void }) {
  const p = PROGRAMS[program];
  const [tab, setTab] = useState<'rules' | 'legacy' | 'lifecycle'>('rules');
  const [zoom, setZoom] = useState(false);

  return (
    <aside className="card mp" aria-label="How this was modernized">
      <div className="mp-head">
        <div className="mp-eyebrow"><Sparkles size={14} /> AI-DLC provenance</div>
        <div className="mp-title">
          How this was modernized
          <button className="btn ghost sm icon" onClick={onClose} aria-label="Collapse panel" title="Collapse panel"><PanelRightClose size={17} /></button>
        </div>
        <div className="mp-src">
          <FileCode2 size={15} />
          <span className="tag">{p.source}</span>
          <span>{p.lines} lines of ABL</span>
        </div>
        <div className="chips" style={{ marginTop: 12 }}>
          <span className="chip"><BadgeCheck size={14} /> Spec approved</span>
          <span className="chip"><FlaskConical size={14} /> Automated tests</span>
          <span className={`chip ${p.parity.full ? '' : 'neutral'}`}><Scale size={14} /> {p.parity.label}</span>
        </div>
      </div>

      <div style={{ padding: '14px 18px 0' }}>
        <div className="tabs" role="tablist">
          <button role="tab" aria-selected={tab === 'rules'} className={tab === 'rules' ? 'on' : ''} onClick={() => setTab('rules')}>Rules</button>
          <button role="tab" aria-selected={tab === 'legacy'} className={tab === 'legacy' ? 'on' : ''} onClick={() => setTab('legacy')}>Legacy screen</button>
          <button role="tab" aria-selected={tab === 'lifecycle'} className={tab === 'lifecycle' ? 'on' : ''} onClick={() => setTab('lifecycle')}>Lifecycle</button>
        </div>
      </div>

      <div style={{ padding: 18 }}>
        {tab === 'rules' && (
          <>
            <div className="section-title">Business rules implemented</div>
            <ol className="rules">
              {p.rules.map((r, i) => (
                <li key={i}><span className="rid">R{i + 1}</span><span>{r}</span></li>
              ))}
            </ol>
            <div className="section-title" style={{ marginTop: 18 }}>ABL constructs translated</div>
            <div className="chips">
              {p.ablConstructs.map((c) => <span key={c} className="tag">{c}</span>)}
            </div>
          </>
        )}

        {tab === 'legacy' && (
          <>
            <div className="row" style={{ justifyContent: 'space-between', marginBottom: 10 }}>
              <div className="section-title" style={{ margin: 0 }}>Original character UI</div>
              <button className="linkish" onClick={() => setZoom(true)}><Maximize2 size={14} /> Full size</button>
            </div>
            <FitTerminal text={legacyScreen} onOpen={() => setZoom(true)} />
            <p className="muted" style={{ fontSize: 13.5, margin: '10px 0 0' }}>
              Same data and rules as the screen on the left. Rendered from the {p.tables.join(', ')} {p.tables.length > 1 ? 'tables' : 'table'}.
            </p>
          </>
        )}

        {tab === 'lifecycle' && (
          <ol className="steps">
            {LIFECYCLE.map((s) => (
              <li key={s.t}>
                <span className="ok"><Check size={13} strokeWidth={3} /></span>
                <div>
                  <div className="s-t">{s.t}</div>
                  <div className="s-d">
                    {s.t === 'Behavioural parity'
                      ? (p.parity.full ? '12 of 12 legacy scenarios matched' : 'Sample scenarios replayed against legacy output')
                      : s.d}
                  </div>
                </div>
              </li>
            ))}
          </ol>
        )}

        <div className="divider" style={{ margin: '18px 0 14px' }} />
        <div className="mp-links">
          <a href={PULLS_URL} target="_blank" rel="noopener noreferrer">
            <GitPullRequest size={17} />
            <span>Pull requests<div className="sub">Spec, tests and code with review</div></span>
            <ExternalLink size={15} />
          </a>
          <a href={REPO_URL} target="_blank" rel="noopener noreferrer">
            <Github size={17} />
            <span>Repository<div className="sub">anupsahoo/progress-agent</div></span>
            <ExternalLink size={15} />
          </a>
        </div>
      </div>

      <Modal open={zoom} onClose={() => setZoom(false)} title={`Legacy screen · ${p.source}`}>
        <pre className="terminal lg">{legacyScreen}</pre>
      </Modal>
    </aside>
  );
}

/** Scales the legacy character screen to fit the panel width; click opens it full size. */
function FitTerminal({ text, onOpen }: { text: string; onOpen: () => void }) {
  const box = useRef<HTMLDivElement>(null);
  const pre = useRef<HTMLPreElement>(null);
  const [fit, setFit] = useState({ scale: 1, h: 0 });
  useLayoutEffect(() => {
    const measure = () => {
      if (!box.current || !pre.current) return;
      const avail = box.current.clientWidth - 24;
      const natural = pre.current.scrollWidth;
      const scale = Math.min(1, avail / natural);
      setFit({ scale, h: pre.current.offsetHeight * scale });
    };
    measure();
    const ro = new ResizeObserver(measure);
    if (box.current) ro.observe(box.current);
    return () => ro.disconnect();
  }, [text]);
  return (
    <div ref={box} className="term-fit" onClick={onOpen} title="Open full size" role="button" tabIndex={0}
      onKeyDown={(e) => { if (e.key === 'Enter') onOpen(); }}>
      <div style={{ height: fit.h || undefined }}>
        <pre ref={pre} style={{ transform: `scale(${fit.scale})`, width: 'max-content' }}>{text}</pre>
      </div>
    </div>
  );
}
