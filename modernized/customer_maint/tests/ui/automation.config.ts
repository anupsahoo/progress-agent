import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: '.',
  retries: 1,
  use: { baseURL: process.env.BASE_URL ?? 'https://anupsahoo.github.io/progress-agent/', trace: 'retain-on-failure' },
});
