// perf-001-customer-list-load: Customer: List under steady load
// Module: Customer Management · Table: Customer · Endpoint: /api/customer-management/customers
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '1m', target: 50 }, { duration: '5m', target: 50 }, { duration: '30s', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'customer-management', table: 'Customer', case: 'perf-001-customer-list-load' },
};

export default function () {
  const r = http.get(`${BASE}/api/customer-management/customers?limit=50`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
