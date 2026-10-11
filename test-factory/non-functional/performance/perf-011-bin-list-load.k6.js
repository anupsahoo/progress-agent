// perf-011-bin-list-load: Bin: List under steady load
// Module: Warehousing · Table: Bin · Endpoint: /api/warehousing/bins
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '1m', target: 50 }, { duration: '5m', target: 50 }, { duration: '30s', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'warehousing', table: 'Bin', case: 'perf-011-bin-list-load' },
};

export default function () {
  const r = http.get(`${BASE}/api/warehousing/bins?limit=50`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
