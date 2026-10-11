// perf-026-customer-detail-spike: Customer: Detail under a spike
// Module: Customer Management · Table: Customer · Endpoint: /api/customer-management/customers
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '10s', target: 10 }, { duration: '20s', target: 300 }, { duration: '1m', target: 300 }, { duration: '20s', target: 10 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'customer-management', table: 'Customer', case: 'perf-026-customer-detail-spike' },
};

export default function () {
  const r = http.get(`${BASE}/api/customer-management/customers/1`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
