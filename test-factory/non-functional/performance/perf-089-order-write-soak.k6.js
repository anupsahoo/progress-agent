// perf-089-order-write-soak: Order: Writes over a soak period
// Module: Order Entry · Table: Order · Endpoint: /api/order-entry/orders
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '2m', target: 20 }, { duration: '30m', target: 20 }, { duration: '1m', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<500'],
  },
  tags: { module: 'order-entry', table: 'Order', case: 'perf-089-order-write-soak' },
};

export default function () {
  const cur = http.get(`${BASE}/api/order-entry/orders/1`).json();
  const r = http.put(`${BASE}/api/order-entry/orders/1`, JSON.stringify(cur), { headers: { 'Content-Type': 'application/json', 'If-Match': String(cur.version || 0) } });
  check(r, { 'saved or conflict': (x) => x.status === 200 || x.status === 409 });
  sleep(1);
}
