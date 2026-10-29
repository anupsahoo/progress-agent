// perf-060-warehouse-search-stress: Warehouse: Search under stress
// Module: Warehousing · Table: Warehouse · Endpoint: /api/warehousing/warehouses
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '2m', target: 100 }, { duration: '2m', target: 200 }, { duration: '2m', target: 400 }, { duration: '1m', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'warehousing', table: 'Warehouse', case: 'perf-060-warehouse-search-stress' },
};

export default function () {
  const q = "No";
  const r = http.get(`${BASE}/api/warehousing/warehouses?q=${encodeURIComponent(q)}`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
