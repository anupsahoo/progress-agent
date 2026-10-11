import React from 'react';
import { ArrowRight, Boxes, FileCode2, GitMerge, GitPullRequest, Layers, Radio, SquareTerminal } from 'lucide-react';
import { ESTATE } from '../data/estate';
import { useLive } from '../data/live';
import { Terminal, TLine } from '../components/Terminal';
import { StatusBadge } from './ModulePage';

const fmtInt = (n: number) => n.toLocaleString('en-US');

function Ring({ value, total }: { value: number; total: number }) {
  const r = 54, c = 2 * Math.PI * r;
  const pct = total ? value / total : 0;
  return (
    <div className="ring">
      <svg width="140" height="140" viewBox="0 0 140 140" aria-hidden>
        <defs>
          <linearGradient id="ring-g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stopColor="#5fd34b" /><stop offset="1" stopColor="#9cc2ff" /></linearGradient>
        </defs>
        <circle cx="70" cy="70" r={r} fill="none" stroke="rgba(255,255,255,.16)" strokeWidth="12" />
        <circle cx="70" cy="70" r={r} fill="none" stroke="url(#ring-g)" strokeWidth="12" strokeLinecap="round"
          strokeDasharray={`${c * pct} ${c}`} transform="rotate(-90 70 70)" style={{ transition: 'stroke-dasharray .8s cubic-bezier(.2,.8,.2,1)' }} />
      </svg>
      <div className="ring-label"><b>{Math.round(pct * 100)}%</b><span>{value} of {total} modules</span></div>
    </div>
  );
}

export function EstateHero() {
  const live = useLive();
  const total = ESTATE.modules.length;
  const n = live.modernCount;
  const screens = ESTATE.modules.reduce((s, m) => s + m.screens.length, 0);
  return (
    <section className={`estate-hero ${n === 0 ? 'baseline' : ''}`}>
      <div className="eh-main">
        <div className="eh-eyebrow"><SquareTerminal size={15} /> {ESTATE.name} · {ESTATE.platform}</div>
        <h1 className="eh-title">
          {n === 0
            ? <>{fmtInt(ESTATE.totalPrograms)} programs. {total} modules.<br />One legacy estate, ready to modernize.</>
            : n === total ? <>Every module modernized.</> : <>Modernizing the estate, module by module.</>}
        </h1>
        <div className="eh-progress">
          Modernization progress: <b>{n} of {total} modules</b> · <b>{fmtInt(live.modernPrograms)} of ~{fmtInt(ESTATE.totalPrograms)} programs</b>
        </div>
        <div className="eh-stats">
          <span><FileCode2 size={16} /> {fmtInt(ESTATE.totalPrograms)} ABL programs</span>
          <span><Layers size={16} /> {fmtInt(ESTATE.totalLines)} lines</span>
          <span><Boxes size={16} /> {total} modules</span>
          <span><SquareTerminal size={16} /> {screens} character screens</span>
        </div>
        <div className="eh-live"><Radio size={14} /> Live from GitHub · main + open pull requests{live.checkedAt ? ` · checked ${new Date(live.checkedAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' })}` : ''}</div>
      </div>
      <Ring value={n} total={total} />
    </section>
  );
}

export function PullStrip({ onNavigate }: { onNavigate: (r: string) => void }) {
  const live = useLive();
  const ids = Object.keys(live.prs);
  const merged = live.merged;
  return (
    <section className="card pr-strip">
      <div className="pr-head">
        <span className="pr-t"><GitPullRequest size={17} /> Pull requests in review <span className="count">{ids.length}</span></span>
        <span className="muted" style={{ fontSize: 13.5 }}>{merged.length} merged to main</span>
      </div>
      {ids.length === 0 ? (
        <div className="pr-empty"><span className="pulse" /><span>No FlowPilot pull requests open. Watching <b>anupsahoo/progress-agent</b> for branches named <code>flowpilot/estate/&lt;module&gt;-…</code></span></div>
      ) : (
        <div className="pr-list">
          {ids.map((id) => {
            const pr = live.prs[id];
            const m = ESTATE.modules.find((x) => x.id === id)!;
            return (
              <div key={id} className="pr-item">
                <GitPullRequest size={18} className="pr-ic" />
                <div style={{ minWidth: 0, flex: 1 }}>
                  <a href={pr.url} target="_blank" rel="noopener noreferrer" className="pr-title">#{pr.number} {pr.title}</a>
                  <div className="pr-sub mono">{pr.branch}</div>
                </div>
                <button className="btn sm" onClick={() => onNavigate(`m/${id}`)}>Open {m.title} <ArrowRight size={14} /></button>
              </div>
            );
          })}
        </div>
      )}
    </section>
  );
}

export function ModuleGrid({ onNavigate }: { onNavigate: (r: string) => void }) {
  const live = useLive();
  return (
    <div className="mod-grid">
      {ESTATE.modules.map((m) => {
        const st = live.status(m.id);
        const flip = live.changed.includes(m.id);
        const preview = (m.screens[0]?.legacyScreen || '').split('\n').slice(0, 6).join('\n');
        return (
          <button key={`${m.id}-${st}`} className={`mod-tile ${st === 'legacy' ? 'legacy' : 'modern'} ${flip ? 'flip' : ''}`} onClick={() => onNavigate(`m/${m.id}`)}>
            <div className="mt-top">
              <span className="mt-title">{m.title}</span>
              {st === 'legacy' ? <SquareTerminal size={18} /> : st === 'pr' ? <GitPullRequest size={18} /> : <GitMerge size={18} />}
            </div>
            {st === 'legacy'
              ? <pre className="mt-ascii" aria-hidden>{preview}</pre>
              : <div className="mt-modern" aria-hidden><i /><i /><i /><i className="b" /></div>}
            <div className="mt-foot">
              <span>{fmtInt(m.programs)} programs · {fmtInt(m.lines)} lines</span>
            </div>
            <StatusBadge status={st} pr={live.prs[m.id]} size="sm" />
          </button>
        );
      })}
    </div>
  );
}

/** The estate's character-mode main menu: what users see today. */
export function LegacyMainMenu({ onNavigate }: { onNavigate: (r: string) => void }) {
  const live = useLive();
  const W = 60;
  const half = Math.ceil(ESTATE.modules.length / 2);
  const item = (i: number) => {
    const m = ESTATE.modules[i];
    if (!m) return null;
    return (
      <span data-map={`menu-${m.id}`} style={{ cursor: 'pointer' }} onClick={() => onNavigate(`m/${m.id}`)}>
        {`${String(i + 1).padStart(2)}. ${m.title.slice(0, 22).padEnd(22)}${live.isModern(m.id) ? '*' : ' '}`}
      </span>
    );
  };
  return (
    <Terminal program="menu/mainmenu.p" cols={W} rows={18} maxFont={17}
      status="Enter selection or press F4 to exit.     * = modernized"
      fkeys={[{ k: 'F1', label: 'GO' }, { k: 'F2', label: 'HELP' }, { k: 'F4', label: 'EXIT' }]}>
      <TLine>{' '.repeat(Math.floor((W - 34) / 2))}<span className="tb">SPORTS2000 ENTERPRISE · MAIN MENU</span></TLine>
      <TLine><span className="td">{' '.repeat(Math.floor((W - 38) / 2))}{ESTATE.platform} · {new Date().toLocaleDateString('en-US', { month: '2-digit', day: '2-digit', year: '2-digit' })}</span></TLine>
      <TLine>{'═'.repeat(W)}</TLine>
      <TLine />
      {Array.from({ length: half }, (_, i) => (
        <TLine key={i}>{'   '}{item(i)}{'   '}{item(i + half)}</TLine>
      ))}
      <TLine />
      <TLine>{'─'.repeat(W)}</TLine>
      <TLine>{'   Selection: '}<span className="tf" style={{ display: 'inline-block', width: '3ch' }}>{' '}</span></TLine>
    </Terminal>
  );
}
