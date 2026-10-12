// perf-056-supplier-search-stress: Supplier: Search under stress
// Module: Supplier Management · Table: Supplier · Endpoint: /api/supplier-management/suppliers
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '2m', target: 100 }, { duration: '2m', target: 200 }, { duration: '2m', target: 400 }, { duration: '1m', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'supplier-management', table: 'Supplier', case: 'perf-056-supplier-search-stress' },
};

export default function () {
  const q = "Go";
  const r = http.get(`${BASE}/api/supplier-management/suppliers?q=${encodeURIComponent(q)}`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
