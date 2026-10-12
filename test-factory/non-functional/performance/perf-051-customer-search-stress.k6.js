// perf-051-customer-search-stress: Customer: Search under stress
// Module: Customer Management · Table: Customer · Endpoint: /api/customer-management/customers
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '2m', target: 100 }, { duration: '2m', target: 200 }, { duration: '2m', target: 400 }, { duration: '1m', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'customer-management', table: 'Customer', case: 'perf-051-customer-search-stress' },
};

export default function () {
  const q = "US";
  const r = http.get(`${BASE}/api/customer-management/customers?q=${encodeURIComponent(q)}`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
