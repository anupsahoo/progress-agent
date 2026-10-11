/**
 * Sports2000 design tokens. Single source of truth for colour, type,
 * spacing, radius and elevation. Tokens are exposed to CSS as custom
 * properties (see applyTheme) and to TypeScript via `T` for the few places
 * that need raw values (inline SVG charts, computed styles).
 */

export const tokens = {
  color: {
    bg: '#f6f7f9',
    surface: '#ffffff',
    surfaceMuted: '#f9fafb',
    surfaceSunken: '#f1f3f6',
    border: '#e3e6eb',
    borderStrong: '#cfd4dc',

    text: '#0b1220',
    textSecondary: '#3d4757',
    textMuted: '#5d6878',
    textFaint: '#8a94a3',

    brand: '#1F4E9E',
    brandHover: '#183f80',
    brandSoft: '#E8EFFA',
    brandSoftBorder: '#c8d7ef',
    brandInk: '#153a78',
    accent: '#3A9A2E',
    accentSoft: '#edf7ea',
    gradient: 'linear-gradient(135deg, #3A9A2E 0%, #1F4E9E 100%)',
    wordmark: '#1d1d1f',

    success: '#2e7d24',
    successSoft: '#edf7ea',
    successBorder: '#c3e2bb',
    warning: '#b45309',
    warningSoft: '#fdf3e2',
    warningBorder: '#f3d9a8',
    danger: '#b91c1c',
    dangerSoft: '#fdecec',
    dangerBorder: '#f5c2c2',
    info: '#0369a1',
    infoSoft: '#e6f3fa',

    sidebar: '#0e1c36',
    sidebarHover: '#16284a',
    sidebarActive: '#1d3561',
    sidebarText: '#c4cad6',
    sidebarTextMuted: '#7e889c',

    terminalBg: '#0a0f1a',
    terminalText: '#7ee2a8',
    terminalDim: '#5d6b80',

    chart1: '#1F4E9E',
    chart2: '#3A9A2E',
    chartGrid: '#e9ecf1',
  },
  font: {
    sans: "'Inter', ui-sans-serif, system-ui, -apple-system, 'Segoe UI', sans-serif",
    mono: "'JetBrains Mono', ui-monospace, SFMono-Regular, Menlo, monospace",
  },
  size: {
    xs: '12.5px',
    sm: '13.5px',
    base: '15px',
    md: '16px',
    lg: '18px',
    xl: '22px',
    xxl: '28px',
    display: '32px',
  },
  radius: { sm: '6px', md: '8px', lg: '12px', xl: '16px', pill: '999px' },
  shadow: {
    xs: '0 1px 2px rgba(16, 24, 40, 0.05)',
    sm: '0 1px 3px rgba(16, 24, 40, 0.08), 0 1px 2px rgba(16, 24, 40, 0.04)',
    md: '0 6px 16px -4px rgba(16, 24, 40, 0.10), 0 2px 6px -2px rgba(16, 24, 40, 0.05)',
    lg: '0 24px 48px -12px rgba(16, 24, 40, 0.22)',
    focus: '0 0 0 3px rgba(31, 78, 158, 0.24)',
  },
  layout: { sidebar: '268px', topbar: '64px', panel: '344px', content: '1320px' },
} as const;

export const T = tokens;

function kebab(s: string) {
  return s.replace(/[A-Z]/g, (m) => '-' + m.toLowerCase());
}

/** Writes every token to :root as a CSS custom property, e.g. --color-brand. */
export function applyTheme() {
  const lines: string[] = [];
  (Object.keys(tokens) as (keyof typeof tokens)[]).forEach((group) => {
    const g = tokens[group] as Record<string, string>;
    Object.keys(g).forEach((k) => lines.push(`--${group}-${kebab(k)}: ${g[k]};`));
  });
  const el = document.createElement('style');
  el.id = 'theme-tokens';
  el.textContent = `:root{${lines.join('')}}`;
  document.head.prepend(el);
}

/* ---------- formatting helpers shared by every screen ---------- */

export const fmtMoney = (n: number, digits = 2) =>
  '$' + n.toLocaleString('en-US', { minimumFractionDigits: digits, maximumFractionDigits: digits });

export const fmtMoney0 = (n: number) => fmtMoney(n, 0);

export const fmtPct = (n: number, digits = 0) => `${(n * 100).toFixed(digits)}%`;

const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
export function fmtDate(iso: string) {
  if (!iso) return '';
  const [y, m, d] = iso.split('-').map(Number);
  return `${MONTHS[m - 1]} ${d}, ${y}`;
}
/** Legacy ABL default date format (mm/dd/yy). */
export function ablDate(iso: string) {
  if (!iso) return '';
  const [y, m, d] = iso.split('-');
  return `${m}/${d}/${y.slice(2)}`;
}
