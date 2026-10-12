// perf-027-feedback-detail-spike: Feedback: Detail under a spike
// Module: Customer Management · Table: Feedback · Endpoint: /api/customer-management/feedbacks
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.API_URL || 'http://localhost:8000';

export const options = {
  stages: [{ duration: '10s', target: 10 }, { duration: '20s', target: 300 }, { duration: '1m', target: 300 }, { duration: '20s', target: 10 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<300'],
  },
  tags: { module: 'customer-management', table: 'Feedback', case: 'perf-027-feedback-detail-spike' },
};

export default function () {
  const r = http.get(`${BASE}/api/customer-management/feedbacks/`);
  check(r, { 'status 200': (x) => x.status === 200 });
  sleep(1);
}
