import type { EstateField } from './estate';

/** Interprets Progress FORMAT strings for validation and display. */
export type Kind = 'text' | 'int' | 'dec' | 'date' | 'bool';

export function kindOf(f: EstateField): Kind {
  const t = f.type.toLowerCase();
  const fm = f.format.toLowerCase();
  if (t.startsWith('int') || t === 'int64') return 'int';
  if (t.startsWith('dec')) return 'dec';
  if (t.startsWith('date')) return 'date';
  if (t.startsWith('log') || /^[^/]+\/[^/]+$/.test(fm) && !/9/.test(fm)) return 'bool';
  if (/^[-+>z9,]+\.[9>z]+$/i.test(f.format)) return 'dec';
  if (/^[-+>z9,]+$/i.test(f.format) && f.format) return 'int';
  if (/^99\/99\/(99|9999)$/.test(f.format)) return 'date';
  return 'text';
}

export function maxChars(f: EstateField): number | undefined {
  const m = /x\((\d+)\)/i.exec(f.format);
  if (m) return +m[1];
  if (/^x+$/i.test(f.format)) return f.format.length;
  return undefined;
}

function digits(s: string) { return (s.match(/[>9z]/gi) || []).length; }

export function boolOptions(f: EstateField): [string, string] {
  const parts = f.format.split('/');
  return parts.length === 2 && parts[0] && parts[1] ? [parts[0], parts[1]] : ['yes', 'no'];
}

/** Human-readable rule derived from the FORMAT, shown as a hint. */
export function ruleText(f: EstateField): string {
  const k = kindOf(f);
  if (k === 'text') { const n = maxChars(f); return n ? `Up to ${n} characters · ${f.format}` : f.format || 'Text'; }
  if (k === 'int') return `Whole number, up to ${digits(f.format) || 9} digits${f.format.includes('-') ? ', may be negative' : ''}`;
  if (k === 'dec') { const [i, d] = f.format.split('.'); return `Number with ${digits(d || '99')} decimals, up to ${digits(i || '9') || 9} digits before the point`; }
  if (k === 'date') return `Date as ${f.format.length === 10 ? 'mm/dd/yyyy' : 'mm/dd/yy'}`;
  return `${boolOptions(f).join(' or ')}`;
}

export function validate(f: EstateField, v: string): string | undefined {
  const k = kindOf(f);
  const s = v.trim();
  if (k === 'text') {
    const n = maxChars(f);
    if (n && v.length > n) return `${f.label} can be at most ${n} characters (${f.format}).`;
    return undefined;
  }
  if (!s) return k === 'bool' ? undefined : undefined;
  if (k === 'int') {
    if (!/^-?\d+$/.test(s.replace(/,/g, ''))) return `${f.label} must be a whole number.`;
    if (s.startsWith('-') && !f.format.includes('-')) return `${f.label} cannot be negative.`;
    const d = digits(f.format);
    if (d && s.replace(/[-,]/g, '').length > d) return `${f.label} can have at most ${d} digits (${f.format}).`;
    return undefined;
  }
  if (k === 'dec') {
    const clean = s.replace(/[$,]/g, '');
    if (!/^-?\d+(\.\d+)?$/.test(clean)) return `${f.label} must be a number.`;
    if (clean.startsWith('-') && !f.format.includes('-')) return `${f.label} cannot be negative.`;
    const [ip, dp] = f.format.split('.');
    const [vi, vd = ''] = clean.replace('-', '').split('.');
    if (dp && vd.length > digits(dp)) return `${f.label} allows ${digits(dp)} decimal places (${f.format}).`;
    if (ip && digits(ip) && vi.replace(/^0+/, '').length > digits(ip)) return `${f.label} is too large for ${f.format}.`;
    return undefined;
  }
  if (k === 'date') {
    const m = /^(\d{1,2})\/(\d{1,2})\/(\d{2}|\d{4})$/.exec(s);
    if (!m) return `${f.label} must be a date like ${f.format.length === 10 ? '04/15/1998' : '04/15/98'}.`;
    const mo = +m[1], d = +m[2];
    if (mo < 1 || mo > 12 || d < 1 || d > 31) return `${f.label} is not a valid date.`;
    return undefined;
  }
  return undefined;
}

export function display(f: EstateField, v: unknown): string {
  if (v == null || v === '') return '';
  const k = kindOf(f);
  if (k === 'dec' && typeof v === 'number') return v.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  if (k === 'bool' && typeof v === 'boolean') return v ? boolOptions(f)[0] : boolOptions(f)[1];
  return String(v);
}

/** Converts edited text back to the stored type. */
export function parse(f: EstateField, v: string): unknown {
  const k = kindOf(f);
  if ((k === 'int' || k === 'dec') && v.trim() !== '') return Number(v.replace(/[$,]/g, ''));
  return v;
}
