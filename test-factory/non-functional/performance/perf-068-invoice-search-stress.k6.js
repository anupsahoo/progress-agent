// perf-068-invoice-search-stress: Invoice: Search under stress
// Module: Billing & Invoicing · Table: Invoice · Endpoint: /api/billing-invoicing/invoices
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '2m', target: 100 }, { duration: '2m', target: 200 }, { duration: '2m', target: 400 }, { duration: '1m', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'billing-invoicing', table: 'Invoice', case: 'perf-068-invoice-search-stress' },
};

export default function () {
  const q = "a";
  const r = http.get(`${BASE}/api/billing-invoicing/invoices?q=${encodeURIComponent(q)}`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
