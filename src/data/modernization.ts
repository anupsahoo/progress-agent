/**
 * Provenance for each modernized screen: which ABL program it came from,
 * the business rules extracted during spec, and the evidence produced by the
 * FlowPilot AI-DLC run.
 */

export type ProgramId = 'customer_maint' | 'cust_orders' | 'customer_list' | 'order_report' | 'update_credit';

export interface Program {
  id: ProgramId;
  source: string;
  lines: number;
  tables: string[];
  route: string;
  title: string;
  summary: string;
  rules: string[];
  parity: { label: string; full: boolean };
  ablConstructs: string[];
}

export const REPO_URL = 'https://github.com/anupsahoo/progress-agent';
export const PULLS_URL = 'https://github.com/anupsahoo/progress-agent/pulls';

export const PROGRAMS: Record<ProgramId, Program> = {
  customer_maint: {
    id: 'customer_maint',
    source: 'sports/customer_maint.p',
    lines: 50,
    tables: ['Customer'],
    route: 'customer-maint',
    title: 'Customer maintenance',
    summary: 'Find a customer by number and update contact and address details.',
    rules: [
      'When a user enters a customer number, look up the customer by CustNum.',
      'If no customer matches, show "Customer not found."',
      'When found, show CustNum read-only and allow editing of Name, Address, City, State, PostalCode and Phone.',
      'When the user saves, persist the record and show "Record updated successfully."',
      'While a record is being edited, prevent conflicting updates (EXCLUSIVE-LOCK becomes an optimistic version check).',
      'When an edit ends, release the lock or version hold.',
      'Allow repeated lookups without restarting the program.',
    ],
    parity: { label: 'Parity 12/12', full: true },
    ablConstructs: ['FIND FIRST ... EXCLUSIVE-LOCK', 'UPDATE ... WITH FRAME', 'MESSAGE VIEW-AS ALERT-BOX', 'RELEASE', 'REPEAT'],
  },
  cust_orders: {
    id: 'cust_orders',
    source: 'sports/cust_orders.p',
    lines: 42,
    tables: ['Customer', 'Order'],
    route: 'customer-orders',
    title: 'Customer orders',
    summary: 'Look up a customer and list every order on file.',
    rules: [
      'Prompt for a customer number and read the customer without locking (NO-LOCK).',
      'If no customer matches, show "Customer not found."',
      'Show the customer header: CustNum, Name and City.',
      'Clear the previous result before showing a new lookup.',
      'List every order for the customer with Order#, Date, Shipped and Status.',
      'Allow repeated lookups in the same session.',
    ],
    parity: { label: 'Parity: sample', full: false },
    ablConstructs: ['FIND FIRST ... NO-LOCK', 'FOR EACH Order WHERE ...', 'CLEAR FRAME ... ALL', 'DOWN WITH FRAME'],
  },
  customer_list: {
    id: 'customer_list',
    source: 'sports/sample-customer-list.p',
    lines: 28,
    tables: ['Customer'],
    route: 'customer-list',
    title: 'Customer list',
    summary: 'All customers ordered by state and name, with balance totals.',
    rules: [
      'Read every customer without locking (NO-LOCK).',
      'Order the list by State, then by Name.',
      'Show Cust#, Customer Name, State and Balance for each customer.',
      'Count customers and accumulate the total balance.',
      'Show "Total Customers" and "Total Balance" when the list ends.',
    ],
    parity: { label: 'Parity: sample', full: false },
    ablConstructs: ['FOR EACH ... NO-LOCK BY State BY Name', 'DISPLAY ... WITH DOWN', 'ASSIGN accumulators'],
  },
  order_report: {
    id: 'order_report',
    source: 'sports/sample-order-report.p',
    lines: 55,
    tables: ['Customer', 'Order', 'OrderLine', 'Item'],
    route: 'order-report',
    title: 'Order report',
    summary: 'Orders for one customer with line items, line counts and totals.',
    rules: [
      'Take a customer number as input.',
      'If the customer does not exist, show "Customer <n> not found." and stop.',
      'List the customer\'s orders newest first (BY OrderDate DESCENDING).',
      'For each order, list lines with item name, Qty, Price and Total.',
      'For each order, report the number of lines and the sum of ExtendedPrice.',
      'Read only: no record locks are taken.',
    ],
    parity: { label: 'Parity: sample', full: false },
    ablConstructs: ['INPUT PARAMETER', 'FOR EACH Order OF Customer BY ... DESCENDING', 'FOR EACH OrderLine OF Order', 'FIND Item'],
  },
  update_credit: {
    id: 'update_credit',
    source: 'sports/sample-update-credit.p',
    lines: 53,
    tables: ['Customer'],
    route: 'update-credit',
    title: 'Credit management',
    summary: 'Raise credit limits for customers whose balance is close to their limit.',
    rules: [
      'Select customers where Balance > CreditLimit x 0.8 and CreditLimit > 0.',
      'Set the new limit to the old limit x 1.2.',
      'Record each change: Cust#, Name, Balance, Old Limit, New Limit.',
      'Apply the updates as one unit of work (EXCLUSIVE-LOCK in the original).',
      'Show the list of changes and "<n> customer(s) updated."',
    ],
    parity: { label: 'Parity: sample', full: false },
    ablConstructs: ['FOR EACH ... EXCLUSIVE-LOCK WHERE', 'DEFINE TEMP-TABLE', 'CREATE ttCreditChange', 'MESSAGE ... ALERT-BOX'],
  },
};

export const LIFECYCLE = [
  { t: 'Intent', d: 'Goal and scope captured from the ABL program' },
  { t: 'Spec approved', d: 'Business rules extracted and signed off' },
  { t: 'Tests first', d: 'Acceptance tests generated from the rules' },
  { t: 'Multi-agent build', d: 'UI, API and data agents in parallel' },
  { t: 'Harness and self-correction', d: 'Typecheck, lint and tests looped to green' },
  { t: 'Behavioural parity', d: 'Legacy and modern outputs compared' },
  { t: 'Human gate', d: 'Reviewer approval before merge' },
  { t: 'Pull request', d: 'Change delivered with evidence attached' },
];

/** The original ABL programs live in the FlowPilot repo under sports/. */
export const ABL_REPO_BLOB = 'https://github.com/anupsahoo/flowpilot-ai/blob/main/';
export function ablSourceUrl(file: string, lines?: [number, number]) {
  const base = ABL_REPO_BLOB + file;
  if (!lines) return base;
  return lines[0] === lines[1] ? `${base}#L${lines[0]}` : `${base}#L${lines[0]}-L${lines[1]}`;
}
export const APP_SOURCE_BLOB = 'https://github.com/anupsahoo/progress-agent/blob/main/';
