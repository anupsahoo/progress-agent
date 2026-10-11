// perf-014-order-list-load: Order: List under steady load
// Module: Order Entry · Table: Order · Endpoint: /api/order-entry/orders
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '1m', target: 50 }, { duration: '5m', target: 50 }, { duration: '30s', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'order-entry', table: 'Order', case: 'perf-014-order-list-load' },
};

export default function () {
  const r = http.get(`${BASE}/api/order-entry/orders?limit=50`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
