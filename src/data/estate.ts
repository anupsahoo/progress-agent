/**
 * The Sports2000 Enterprise legacy estate: 12 modules, ~500 ABL programs.
 * Loaded from /estate.json at the repo root (bundled at build time). If the
 * file is missing, a compact built-in description of the same estate is used
 * so the app always renders.
 */

export interface EstateField { name: string; label: string; type: string; format: string; editable: boolean }
export interface EstateScreen {
  id: string;
  title: string;
  table: string;
  legacyScreen: string;
  fields: EstateField[];
  sampleRows: Record<string, unknown>[];
  program?: string;
}
export interface EstateModule {
  id: string;
  title: string;
  description: string;
  programs: number;
  lines: number;
  screens: EstateScreen[];
  programList: { path: string; kind: string; lines: number }[];
  tables: string[];
}
export interface Estate { name: string; platform: string; modules: EstateModule[]; totalPrograms: number; totalLines: number }

/* ---------------- loading + normalisation ---------------- */

type Raw = Record<string, unknown>;
const str = (v: unknown, d = '') => (typeof v === 'string' ? v : v == null ? d : String(v));
const num = (v: unknown) => (typeof v === 'number' ? v : typeof v === 'string' && v.trim() !== '' && !isNaN(+v) ? +v : undefined);

function normField(f: Raw): EstateField {
  const name = str(f.name ?? f.field);
  return {
    name,
    label: str(f.label, name),
    type: str(f.type ?? f.dataType, 'character').toLowerCase(),
    format: str(f.format, ''),
    editable: f.editable !== false,
  };
}

function normScreen(s: Raw, i: number, moduleId: string): EstateScreen {
  const fields = Array.isArray(s.fields) ? (s.fields as Raw[]).map(normField) : [];
  return {
    id: str(s.id, `${moduleId}-${i + 1}`),
    title: str(s.title ?? s.name, `Screen ${i + 1}`),
    table: str(s.table, ''),
    legacyScreen: str(s.legacyScreen ?? s.legacy_screen ?? s.screen, ''),
    fields,
    sampleRows: Array.isArray(s.sampleRows ?? s.sample_rows) ? ((s.sampleRows ?? s.sample_rows) as Raw[]) : [],
    program: s.program ? str(s.program) : undefined,
  };
}

function normModule(m: Raw): EstateModule {
  const id = str(m.id ?? m.name);
  const screens = Array.isArray(m.screens) ? (m.screens as Raw[]).map((s, i) => normScreen(s, i, id)) : [];
  const progs = m.programs ?? m.programCount ?? m.program_count;
  let programs = num(progs);
  let lines = num(m.lines ?? m.loc ?? m.linesOfCode ?? m.lines_of_code);
  if (Array.isArray(progs)) {
    programs = progs.length;
    if (lines == null) lines = (progs as Raw[]).reduce((s, p) => s + (num(p?.lines ?? p?.loc) ?? 0), 0) || undefined;
  }
  const programList = Array.isArray(progs)
    ? (progs as Raw[]).map((p) => (typeof p === 'string' ? { path: p, kind: '', lines: 0 } : { path: str(p.path ?? p.name), kind: str(p.kind), lines: num(p.lines ?? p.loc) ?? 0 }))
    : [];
  const tables = Array.isArray(m.tables) ? (m.tables as unknown[]).map((t) => str(t)) : Array.from(new Set(screens.map((s) => s.table).filter(Boolean)));
  return {
    id,
    title: str(m.title ?? m.name, id),
    description: str(m.description ?? m.summary, ''),
    programs: num(m.programCount ?? m.program_count) ?? programs ?? 0,
    lines: lines ?? 0,
    screens,
    programList,
    tables,
  };
}

export function normaliseEstate(raw: unknown): Estate | null {
  if (!raw) return null;
  const r = raw as Raw;
  const list = Array.isArray(raw) ? raw : Array.isArray(r.modules) ? r.modules : null;
  if (!list || !list.length) return null;
  const modules = (list as Raw[]).map(normModule).filter((m) => m.id);
  const totalPrograms = num(r.totalPrograms ?? r.programs) ?? modules.reduce((s, m) => s + m.programs, 0);
  const totalLines = num(r.totalLines ?? r.lines) ?? modules.reduce((s, m) => s + m.lines, 0);
  return {
    name: str(r.name ?? r.title, 'Sports2000 Enterprise').replace(/\s*\(sample estate\)\s*$/i, ''),
    platform: str(r.platform, 'Progress OpenEdge 12.7'),
    modules,
    totalPrograms,
    totalLines,
  };
}

const bundled = import.meta.glob('../../estate.json', { eager: true, import: 'default' }) as Record<string, unknown>;
const bundledManifest = import.meta.glob('../../modernization.json', { eager: true, import: 'default' }) as Record<string, unknown>;

export const BUNDLED_MANIFEST = Object.values(bundledManifest)[0] as { modernized?: string[]; updated_at?: string; version?: unknown } | undefined;

/* ---------------- built-in fallback ---------------- */

function frame(title: string, prog: string, fields: EstateField[], row: Record<string, unknown>) {
  const w = 66;
  const line = (s: string) => `│${s.padEnd(w - 2).slice(0, w - 2)}│`;
  const t = ` ${title} `;
  const side = w - 2 - t.length;
  const out = [
    `┌${'─'.repeat(Math.floor(side / 2))}${t}${'─'.repeat(Math.ceil(side / 2))}┐`,
    line(''),
    ...fields.map((f) => line(`${(f.label + ':').padStart(18)} ${String(row[f.name] ?? '')}`)),
    line(''),
    `└${'─'.repeat(w - 2)}┘`,
    ` ${prog}`,
  ];
  return out.join('\n');
}

const F = (name: string, label: string, type: string, format: string, editable = true): EstateField => ({ name, label, type, format, editable });

function mod(id: string, title: string, description: string, programs: number, lines: number, table: string, prog: string, fields: EstateField[], rows: Record<string, unknown>[]): EstateModule {
  return {
    id, title, description, programs, lines, programList: [], tables: [table],
    screens: [{ id: `${id}-maint`, title: `${title} maintenance`, table, program: prog, fields, sampleRows: rows, legacyScreen: frame(`${table} Maintenance`, prog, fields, rows[0] ?? {}) }],
  };
}

const FALLBACK: Estate = {
  name: 'Sports2000 Enterprise',
  platform: 'Progress OpenEdge 12.7',
  totalPrograms: 500,
  totalLines: 186400,
  modules: [
    mod('customers', 'Customer management', 'Customer master, contacts and addresses.', 48, 17200, 'Customer', 'customers/custmnt.p',
      [F('CustNum', 'Cust Num', 'integer', '>>>>9', false), F('Name', 'Name', 'character', 'x(30)'), F('City', 'City', 'character', 'x(25)'), F('Phone', 'Phone', 'character', 'x(20)'), F('CreditLimit', 'Credit Limit', 'decimal', '->,>>>,>>9.99')],
      [{ CustNum: 1, Name: 'Lift Tours', City: 'Burlington', Phone: '(617) 450-0086', CreditLimit: 66700 }, { CustNum: 3, Name: 'Hoops', City: 'Atlanta', Phone: '(617) 355-1557', CreditLimit: 75000 }]),
    mod('orders', 'Order management', 'Order entry, order lines and order inquiry.', 62, 24800, 'Order', 'orders/ordentry.p',
      [F('OrderNum', 'Order Num', 'integer', '>>>>9', false), F('CustNum', 'Cust Num', 'integer', '>>>>9'), F('OrderDate', 'Order Date', 'date', '99/99/99'), F('OrderStatus', 'Status', 'character', 'x(20)')],
      [{ OrderNum: 6, CustNum: 1, OrderDate: '02/11/98', OrderStatus: 'Shipped' }, { OrderNum: 9, CustNum: 1, OrderDate: '04/15/98', OrderStatus: 'Shipped' }]),
    mod('credit', 'Credit and collections', 'Credit limits, holds and collections.', 31, 11900, 'Customer', 'credit/credupd.p',
      [F('CustNum', 'Cust Num', 'integer', '>>>>9', false), F('Balance', 'Balance', 'decimal', '->,>>>,>>9.99', false), F('CreditLimit', 'Credit Limit', 'decimal', '->,>>>,>>9.99'), F('OnHold', 'On Hold', 'logical', 'yes/no')],
      [{ CustNum: 4, Balance: 14235.14, CreditLimit: 15000, OnHold: 'no' }]),
    mod('inventory', 'Inventory', 'Items, stock on hand and allocations.', 54, 19400, 'Item', 'inventory/itemmnt.p',
      [F('ItemNum', 'Item Num', 'integer', '>>>>9', false), F('ItemName', 'Item Name', 'character', 'x(25)'), F('OnHand', 'On Hand', 'integer', '->>>>9'), F('Price', 'Price', 'decimal', '->,>>>,>>9.99')],
      [{ ItemNum: 1, ItemName: 'Fins', OnHand: 410, Price: 21.29 }, { ItemNum: 2, ItemName: 'Tennis Racquet', OnHand: 220, Price: 37.31 }]),
    mod('purchasing', 'Purchasing', 'Suppliers, purchase orders and receipts.', 44, 16100, 'PurchaseOrder', 'purchasing/pomnt.p',
      [F('PONum', 'PO Num', 'integer', '>>>>9', false), F('SupplierNum', 'Supplier', 'integer', '>>>>9'), F('DateEntered', 'Date', 'date', '99/99/99'), F('POStatus', 'Status', 'character', 'x(12)')],
      [{ PONum: 101, SupplierNum: 7, DateEntered: '03/02/98', POStatus: 'Open' }]),
    mod('warehouse', 'Warehouse and shipping', 'Bins, picking and shipments.', 47, 17600, 'Warehouse', 'warehouse/whmnt.p',
      [F('WarehouseNum', 'Warehouse', 'integer', '>>>9', false), F('WarehouseName', 'Name', 'character', 'x(30)'), F('City', 'City', 'character', 'x(25)'), F('State', 'State', 'character', 'x(20)')],
      [{ WarehouseNum: 1, WarehouseName: 'Northeast Regional', City: 'Boston', State: 'MA' }]),
    mod('invoicing', 'Invoicing', 'Invoices, payments and statements.', 41, 15300, 'Invoice', 'invoicing/invmnt.p',
      [F('Invoicenum', 'Invoice Num', 'integer', '>>>>9', false), F('CustNum', 'Cust Num', 'integer', '>>>>9'), F('InvoiceDate', 'Date', 'date', '99/99/99'), F('Amount', 'Amount', 'decimal', '->,>>>,>>9.99')],
      [{ Invoicenum: 1, CustNum: 1, InvoiceDate: '02/16/98', Amount: 1014.31 }]),
    mod('ledger', 'General ledger', 'Accounts, journals and period close.', 39, 15800, 'GLAccount', 'ledger/glmnt.p',
      [F('AccountNum', 'Account', 'integer', '>>>>>9', false), F('Description', 'Description', 'character', 'x(30)'), F('AcctType', 'Type', 'character', 'x(10)'), F('Balance', 'Balance', 'decimal', '->>,>>>,>>9.99', false)],
      [{ AccountNum: 1000, Description: 'Cash', AcctType: 'Asset', Balance: 125000 }]),
    mod('hr', 'Human resources', 'Employees, departments and benefits.', 36, 12900, 'Employee', 'hr/empmnt.p',
      [F('EmpNum', 'Emp Num', 'integer', '>>>>9', false), F('FirstName', 'First Name', 'character', 'x(15)'), F('LastName', 'Last Name', 'character', 'x(25)'), F('DeptCode', 'Dept', 'character', 'x(3)')],
      [{ EmpNum: 1, FirstName: 'Justine', LastName: 'Smith', DeptCode: '100' }]),
    mod('pricing', 'Pricing and promotions', 'Price lists, discounts and promotions.', 33, 12100, 'PriceList', 'pricing/prcmnt.p',
      [F('ItemNum', 'Item Num', 'integer', '>>>>9', false), F('ListPrice', 'List Price', 'decimal', '->,>>9.99'), F('Discount', 'Discount %', 'integer', '>9'), F('EffDate', 'Effective', 'date', '99/99/99')],
      [{ ItemNum: 1, ListPrice: 21.29, Discount: 5, EffDate: '01/01/98' }]),
    mod('returns', 'Returns', 'Return authorisations and credits.', 29, 10500, 'RefCall', 'returns/rmamnt.p',
      [F('CallNum', 'RMA Num', 'character', 'x(6)', false), F('CustNum', 'Cust Num', 'integer', '>>>>9'), F('CallDate', 'Date', 'date', '99/99/99'), F('Parent', 'Reason', 'character', 'x(30)')],
      [{ CallNum: 'R00001', CustNum: 3, CallDate: '05/02/98', Parent: 'Damaged in transit' }]),
    mod('reporting', 'Reporting', 'Operational reports and month-end extracts.', 36, 12800, 'Report', 'reporting/rptmenu.p',
      [F('ReportId', 'Report', 'character', 'x(12)', false), F('Title', 'Title', 'character', 'x(40)'), F('Schedule', 'Schedule', 'character', 'x(10)')],
      [{ ReportId: 'SLS-001', Title: 'Sales by region', Schedule: 'Monthly' }]),
  ],
};

export const ESTATE: Estate = normaliseEstate(Object.values(bundled)[0]) ?? FALLBACK;
export const ESTATE_SOURCE: 'estate.json' | 'built-in' = normaliseEstate(Object.values(bundled)[0]) ? 'estate.json' : 'built-in';

export function moduleById(id: string) { return ESTATE.modules.find((m) => m.id === id); }

/* ---------------- hand-built screens ---------------- */

/** The four polished screens, attached to the estate module they belong to. */
export interface FeaturedScreen { route: string; title: string }
const FEATURED: { match: RegExp; screens: FeaturedScreen[] }[] = [
  { match: /cust/i, screens: [{ route: 'customer-list', title: 'Customers' }, { route: 'customer-maint', title: 'Customer maintenance' }] },
  { match: /order-entry|^orders?$|order/i, screens: [{ route: 'customer-orders', title: 'Orders' }, { route: 'order-report', title: 'Order report' }] },
  { match: /credit|collect|receiv/i, screens: [{ route: 'update-credit', title: 'Credit management' }] },
];

export const FEATURED_BY_MODULE: Record<string, FeaturedScreen[]> = (() => {
  const out: Record<string, FeaturedScreen[]> = {};
  const placed = new Set<string>();
  FEATURED.forEach((f) => {
    const m = ESTATE.modules.find((x) => f.match.test(x.id)) ?? ESTATE.modules.find((x) => f.match.test(x.title));
    if (m) { out[m.id] = [...(out[m.id] ?? []), ...f.screens]; f.screens.forEach((s) => placed.add(s.route)); }
  });
  // Anything unplaced (e.g. no credit module) goes with the customer module.
  const cust = ESTATE.modules.find((x) => /cust/i.test(x.id)) ?? ESTATE.modules[0];
  FEATURED.forEach((f) => f.screens.forEach((s) => {
    if (!placed.has(s.route) && cust) { out[cust.id] = [...(out[cust.id] ?? []), s]; placed.add(s.route); }
  }));
  return out;
})();

/** Which module a hand-built route belongs to (for sidebar highlighting and legacy gating). */
export function moduleForRoute(route: string): string | undefined {
  return Object.keys(FEATURED_BY_MODULE).find((k) => FEATURED_BY_MODULE[k].some((s) => s.route === route));
}
