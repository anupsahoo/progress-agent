// perf-021-department-list-load: Department: List under steady load
// Module: HR & Payroll · Table: Department · Endpoint: /api/hr-payroll/departments
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '1m', target: 50 }, { duration: '5m', target: 50 }, { duration: '30s', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'hr-payroll', table: 'Department', case: 'perf-021-department-list-load' },
};

export default function () {
  const r = http.get(`${BASE}/api/hr-payroll/departments?limit=50`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
