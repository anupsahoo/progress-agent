// perf-007-supplier-item-xref-list-load: SupplierItemXref: List under steady load
// Module: Supplier Management · Table: SupplierItemXref · Endpoint: /api/supplier-management/supplier-item-xrefs
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '1m', target: 50 }, { duration: '5m', target: 50 }, { duration: '30s', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'supplier-management', table: 'SupplierItemXref', case: 'perf-007-supplier-item-xref-list-load' },
};

export default function () {
  const r = http.get(`${BASE}/api/supplier-management/supplier-item-xrefs?limit=50`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
