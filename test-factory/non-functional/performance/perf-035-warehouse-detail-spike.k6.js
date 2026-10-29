// perf-035-warehouse-detail-spike: Warehouse: Detail under a spike
// Module: Warehousing · Table: Warehouse · Endpoint: /api/warehousing/warehouses
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '10s', target: 10 }, { duration: '20s', target: 300 }, { duration: '1m', target: 300 }, { duration: '20s', target: 10 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'warehousing', table: 'Warehouse', case: 'perf-035-warehouse-detail-spike' },
};

export default function () {
  const r = http.get(`${BASE}/api/warehousing/warehouses/1`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
