// perf-045-employee-detail-spike: Employee: Detail under a spike
// Module: HR & Payroll · Table: Employee · Endpoint: /api/hr-payroll/employees
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '10s', target: 10 }, { duration: '20s', target: 300 }, { duration: '1m', target: 300 }, { duration: '20s', target: 10 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'hr-payroll', table: 'Employee', case: 'perf-045-employee-detail-spike' },
};

export default function () {
  const r = http.get(`${BASE}/api/hr-payroll/employees/1`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
