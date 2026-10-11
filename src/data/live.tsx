import React, { createContext, useContext, useEffect, useMemo, useRef, useState } from 'react';
import { BUNDLED_MANIFEST, ESTATE } from './estate';

/**
 * Live modernization status. A module counts as modernized when it is listed
 * in modernization.json on main ("merged") or when an open pull request's
 * head branch starts with flowpilot/estate/<module-id>- ("in review").
 * Both are fetched from GitHub at runtime (no rebuild needed) and polled.
 */

const REPO = 'anupsahoo/progress-agent';
const MANIFEST_URL = `https://api.github.com/repos/${REPO}/contents/modernization.json?ref=main`;
const MODERNIZED_DIR_URL = `https://api.github.com/repos/${REPO}/contents/modernized?ref=main`;
const PULLS_URL = `https://api.github.com/repos/${REPO}/pulls?state=open&per_page=100`;
const BRANCH_PREFIX = 'flowpilot/estate/';

export interface PullInfo { number: number; url: string; title: string; branch: string; updatedAt: string }
export type ModuleStatus = 'legacy' | 'merged' | 'pr';

interface LiveState {
  merged: string[];
  prs: Record<string, PullInfo>;
  manifestUpdatedAt?: string;
  checkedAt?: number;
  source: 'live' | 'bundled' | 'override';
  /** Module ids whose status changed on the last refresh (for flip animations). */
  changed: string[];
}

interface LiveApi extends LiveState {
  status: (id: string) => ModuleStatus;
  isModern: (id: string) => boolean;
  modernCount: number;
  modernPrograms: number;
  refresh: () => void;
  /** User-initiated: check every 5 seconds for 2 minutes, then stop. */
  watch: () => void;
  watching: boolean;
}

const Ctx = createContext<LiveApi | null>(null);

function params() {
  const q = new URLSearchParams(window.location.search);
  return { manifest: q.get('manifest'), prs: q.get('prs') };
}

function moduleFromBranch(ref: string): string | undefined {
  // The single-program AI-DLC run (flowpilot/<stage>/customer_maint-<run>) modernizes customer maintenance.
  if (/^flowpilot\/(spec|ui|ui-tests|api)\/customer_maint-/.test(ref)) return 'customer-management';
  if (!ref.startsWith(BRANCH_PREFIX)) return undefined;
  const rest = ref.slice(BRANCH_PREFIX.length);
  // Longest module id that matches "<id>-" wins (ids may contain hyphens).
  return ESTATE.modules
    .map((m) => m.id)
    .filter((id) => rest.startsWith(id + '-'))
    .sort((a, b) => b.length - a.length)[0];
}

function validIds(list: unknown): string[] {
  const ids = new Set(ESTATE.modules.map((m) => m.id));
  return Array.isArray(list) ? list.filter((x): x is string => typeof x === 'string' && ids.has(x)) : [];
}

export function LiveProvider({ children, onChange }: { children: React.ReactNode; onChange?: (msg: string) => void }) {
  const [state, setState] = useState<LiveState>(() => ({
    merged: validIds(BUNDLED_MANIFEST?.modernized),
    prs: {},
    manifestUpdatedAt: BUNDLED_MANIFEST?.updated_at,
    source: 'bundled',
    changed: [],
  }));
  const first = useRef(true);
  const stateRef = useRef(state);
  stateRef.current = state;
  const onChangeRef = useRef(onChange);
  onChangeRef.current = onChange;

  // Bounded watch, started by a person: 5-second checks for 2 minutes, then stop.
  const [watching, setWatching] = useState(false);
  const watchTimer = useRef<number | null>(null);
  const watch = () => {
    if (watchTimer.current) window.clearInterval(watchTimer.current);
    setWatching(true);
    const until = Date.now() + 120_000;
    refresh();
    watchTimer.current = window.setInterval(() => {
      if (Date.now() > until) { window.clearInterval(watchTimer.current!); watchTimer.current = null; setWatching(false); return; }
      refresh();
    }, 5000);
  };

  const refresh = async () => {
    const p = params();
    const prev = stateRef.current;
    let merged = prev.merged;
    let updatedAt = prev.manifestUpdatedAt;
    let source = prev.source;
    let prs = prev.prs;

    // 1. Manifest on main (or a local override for demos/tests).
    if (p.manifest === 'none') {
      merged = []; source = 'override';
    } else {
      try {
        const url = p.manifest || MANIFEST_URL;
        const r = await fetch(url, { cache: 'no-store', headers: p.manifest ? {} : { Accept: 'application/vnd.github.raw+json' } });
        if (r.ok) {
          const j = await r.json();
          merged = validIds(j?.modernized);
          updatedAt = j?.updated_at ?? updatedAt;
          source = p.manifest ? 'override' : 'live';
        }
      } catch { /* offline or rate limited: keep last state */ }
      // A merged module PR adds modernized/<module>/ to main; count those too,
      // so module PRs never need to edit a shared file.
      if (!p.manifest) {
        try {
          const r = await fetch(MODERNIZED_DIR_URL, { cache: 'no-store', headers: { Accept: 'application/vnd.github+json' } });
          if (r.ok) {
            const dirs = (await r.json()) as { name: string; type: string }[];
            merged = Array.from(new Set([...merged, ...validIds(dirs.filter((d) => d.type === 'dir').map((d) => d.name))]));
          }
        } catch { /* keep last state */ }
      }
    }

    // 2. Open FlowPilot pull requests.
    if (p.prs === 'off' || p.manifest) {
      if (p.prs === 'off') prs = {};
    } else {
      try {
        const r = await fetch(PULLS_URL, { cache: 'no-store', headers: { Accept: 'application/vnd.github+json' } });
        if (r.ok) {
          const list = (await r.json()) as { number: number; html_url: string; title: string; updated_at: string; head?: { ref?: string } }[];
          const next: Record<string, PullInfo> = {};
          list.forEach((pr) => {
            const ref = pr.head?.ref ?? '';
            const id = moduleFromBranch(ref);
            if (id && (!next[id] || next[id].number < pr.number)) {
              next[id] = { number: pr.number, url: pr.html_url, title: pr.title, branch: ref, updatedAt: pr.updated_at };
            }
          });
          prs = next;
        }
      } catch { /* keep last state */ }
    }

    const statusOf = (s: { merged: string[]; prs: Record<string, PullInfo> }, id: string): ModuleStatus =>
      s.merged.includes(id) ? 'merged' : s.prs[id] ? 'pr' : 'legacy';
    const changed = ESTATE.modules.map((m) => m.id).filter((id) => statusOf(prev, id) !== statusOf({ merged, prs }, id));
    const prChanged = JSON.stringify(Object.keys(prs).sort().map((k) => prs[k].number)) !== JSON.stringify(Object.keys(prev.prs).sort().map((k) => prev.prs[k].number));

    setState({ merged, prs, manifestUpdatedAt: updatedAt, source, checkedAt: Date.now(), changed });
    if (!first.current && (changed.length || prChanged)) onChangeRef.current?.('Updated just now');
    first.current = false;
  };

  useEffect(() => {
    // No timer: check once on load and whenever the tab comes back into view
    // (e.g. after switching from FlowPilot). A Refresh button calls refresh().
    refresh();
    const vis = () => { if (document.visibilityState === 'visible') refresh(); };
    document.addEventListener('visibilitychange', vis);
    window.addEventListener('focus', vis);
    return () => { document.removeEventListener('visibilitychange', vis); window.removeEventListener('focus', vis); };
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const api = useMemo<LiveApi>(() => {
    const status = (id: string): ModuleStatus => (state.merged.includes(id) ? 'merged' : state.prs[id] ? 'pr' : 'legacy');
    const modern = ESTATE.modules.filter((m) => status(m.id) !== 'legacy');
    return {
      ...state,
      status,
      isModern: (id) => status(id) !== 'legacy',
      modernCount: modern.length,
      modernPrograms: modern.reduce((s, m) => s + m.programs, 0),
      refresh,
      watch,
      watching,
    };
  }, [state, watching]); // eslint-disable-line react-hooks/exhaustive-deps

  return <Ctx.Provider value={api}>{children}</Ctx.Provider>;
}

export function useLive(): LiveApi {
  const v = useContext(Ctx);
  if (!v) throw new Error('useLive outside LiveProvider');
  return v;
}
