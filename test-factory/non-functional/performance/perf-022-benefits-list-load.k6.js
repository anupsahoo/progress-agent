// perf-022-benefits-list-load: Benefits: List under steady load
// Module: HR & Payroll · Table: Benefits · Endpoint: /api/hr-payroll/benefitses
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '1m', target: 50 }, { duration: '5m', target: 50 }, { duration: '30s', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'hr-payroll', table: 'Benefits', case: 'perf-022-benefits-list-load' },
};

export default function () {
  const r = http.get(`${BASE}/api/hr-payroll/benefitses?limit=50`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
