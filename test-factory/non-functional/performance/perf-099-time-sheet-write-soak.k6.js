// perf-099-time-sheet-write-soak: TimeSheet: Writes over a soak period
// Module: HR & Payroll · Table: TimeSheet · Endpoint: /api/hr-payroll/time-sheets
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '2m', target: 20 }, { duration: '30m', target: 20 }, { duration: '1m', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<500'],
  },
  tags: { module: 'hr-payroll', table: 'TimeSheet', case: 'perf-099-time-sheet-write-soak' },
};

export default function () {
  const cur = http.get(`${BASE}/api/hr-payroll/time-sheets/1/1998-01-05`).json();
  const r = http.put(`${BASE}/api/hr-payroll/time-sheets/1/1998-01-05`, JSON.stringify(cur), { headers: { 'Content-Type': 'application/json', 'If-Match': String(cur.version || 0) } });
  check(r, { 'saved or conflict': (x) => x.status === 200 || x.status === 409 });
  sleep(1);
}
