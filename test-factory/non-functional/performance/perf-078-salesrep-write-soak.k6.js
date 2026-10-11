// perf-078-salesrep-write-soak: Salesrep: Writes over a soak period
// Module: Sales & Territories · Table: Salesrep · Endpoint: /api/sales-territories/salesreps
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '2m', target: 20 }, { duration: '30m', target: 20 }, { duration: '1m', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<500'],
  },
  tags: { module: 'sales-territories', table: 'Salesrep', case: 'perf-078-salesrep-write-soak' },
};

export default function () {
  const cur = http.get(`${BASE}/api/sales-territories/salesreps/BBB`).json();
  const r = http.put(`${BASE}/api/sales-territories/salesreps/BBB`, JSON.stringify(cur), { headers: { 'Content-Type': 'application/json', 'If-Match': String(cur.version || 0) } });
  check(r, { 'saved or conflict': (x) => x.status === 200 || x.status === 409 });
  sleep(1);
}
