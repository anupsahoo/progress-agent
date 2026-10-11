// perf-009-inventory-trans-list-load: InventoryTrans: List under steady load
// Module: Inventory · Table: InventoryTrans · Endpoint: /api/inventory/inventory-transes
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '1m', target: 50 }, { duration: '5m', target: 50 }, { duration: '30s', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'inventory', table: 'InventoryTrans', case: 'perf-009-inventory-trans-list-load' },
};

export default function () {
  const r = http.get(`${BASE}/api/inventory/inventory-transes?limit=50`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
