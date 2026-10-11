// perf-029-state-detail-spike: State: Detail under a spike
// Module: Sales & Territories · Table: State · Endpoint: /api/sales-territories/states
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '10s', target: 10 }, { duration: '20s', target: 300 }, { duration: '1m', target: 300 }, { duration: '20s', target: 10 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'sales-territories', table: 'State', case: 'perf-029-state-detail-spike' },
};

export default function () {
  const r = http.get(`${BASE}/api/sales-territories/states/AK`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
