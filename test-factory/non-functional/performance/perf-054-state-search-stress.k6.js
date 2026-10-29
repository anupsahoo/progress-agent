// perf-054-state-search-stress: State: Search under stress
// Module: Sales & Territories · Table: State · Endpoint: /api/sales-territories/states
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '2m', target: 100 }, { duration: '2m', target: 200 }, { duration: '2m', target: 400 }, { duration: '1m', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'sales-territories', table: 'State', case: 'perf-054-state-search-stress' },
};

export default function () {
  const q = "AK";
  const r = http.get(`${BASE}/api/sales-territories/states?q=${encodeURIComponent(q)}`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
