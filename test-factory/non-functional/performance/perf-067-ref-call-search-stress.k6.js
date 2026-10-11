// perf-067-ref-call-search-stress: RefCall: Search under stress
// Module: Credit Management · Table: RefCall · Endpoint: /api/credit-management/ref-calls
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '2m', target: 100 }, { duration: '2m', target: 200 }, { duration: '2m', target: 400 }, { duration: '1m', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'credit-management', table: 'RefCall', case: 'perf-067-ref-call-search-stress' },
};

export default function () {
  const q = "00";
  const r = http.get(`${BASE}/api/credit-management/ref-calls?q=${encodeURIComponent(q)}`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
