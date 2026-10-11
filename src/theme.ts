/**
 * Sports2000 design tokens. Single source of truth for colour, type,
 * spacing, radius and elevation. Tokens are exposed to CSS as custom
 * properties (see applyTheme) and to TypeScript via `T` for the few places
 * that need raw values (inline SVG charts, computed styles).
 */

export const tokens = {
  color: {
    bg: '#F4F7FB',
    surface: '#ffffff',
    surfaceMuted: '#F4F7FB',
    surfaceSunken: '#E8EFFA',
    border: '#DCE5F0',
    borderStrong: '#C5D3E5',

    text: '#0E1E3A',
    textSecondary: '#2B3D5C',
    textMuted: '#55688A',
    textFaint: '#8A9AB5',

    brand: '#1F4E9E',
    brandHover: '#12306A',
    brandSoft: '#E8EFFA',
    brandSoftBorder: '#B9CCEA',
    brandInk: '#12306A',
    accent: '#3A9A2E',
    accentSoft: '#EEF8EC',
    gradient: 'linear-gradient(135deg, #3A9A2E 0%, #1F4E9E 100%)',
    wordmark: '#0E1E3A',

    success: '#2B7A22',
    successSoft: '#EEF8EC',
    successBorder: '#C6E6C0',
    warning: '#1F4E9E',
    warningSoft: '#E8EFFA',
    warningBorder: '#B9CCEA',
    danger: '#2C64B8',
    dangerSoft: '#F4F7FB',
    dangerBorder: '#B9CCEA',
    info: '#1F4E9E',
    infoSoft: '#E8EFFA',

    sidebar: '#0B1F44',
    sidebarHover: '#0B1F44',
    sidebarActive: '#12306A',
    sidebarText: '#B9CCEA',
    sidebarTextMuted: '#8A9AB5',

    terminalBg: '#0E1E3A',
    terminalText: '#8ACB80',
    terminalDim: '#55688A',

    chart1: '#1F4E9E',
    chart2: '#3A9A2E',
    chartGrid: '#E8EFFA',
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
    xs: '0 1px 2px rgba(14,30,58, 0.05)',
    sm: '0 1px 3px rgba(14,30,58, 0.08), 0 1px 2px rgba(14,30,58, 0.04)',
    md: '0 6px 16px -4px rgba(14,30,58, 0.10), 0 2px 6px -2px rgba(14,30,58, 0.05)',
    lg: '0 24px 48px -12px rgba(14,30,58, 0.22)',
    focus: '0 0 0 3px rgba(31,78,158, 0.24)',
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
