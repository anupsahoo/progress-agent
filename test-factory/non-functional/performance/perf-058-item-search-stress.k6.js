// perf-058-item-search-stress: Item: Search under stress
// Module: Inventory · Table: Item · Endpoint: /api/inventory/items
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '2m', target: 100 }, { duration: '2m', target: 200 }, { duration: '2m', target: 400 }, { duration: '1m', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'inventory', table: 'Item', case: 'perf-058-item-search-stress' },
};

export default function () {
  const q = "Fi";
  const r = http.get(`${BASE}/api/inventory/items?q=${encodeURIComponent(q)}`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
