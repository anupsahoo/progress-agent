// perf-074-time-sheet-search-stress: TimeSheet: Search under stress
// Module: HR & Payroll · Table: TimeSheet · Endpoint: /api/hr-payroll/time-sheets
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '2m', target: 100 }, { duration: '2m', target: 200 }, { duration: '2m', target: 400 }, { duration: '1m', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'hr-payroll', table: 'TimeSheet', case: 'perf-074-time-sheet-search-stress' },
};

export default function () {
  const q = "pa";
  const r = http.get(`${BASE}/api/hr-payroll/time-sheets?q=${encodeURIComponent(q)}`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
