import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: 'test/ui',
  retries: 1,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:5173',
  },
  webServer: {
    command: 'npm run dev',
    port: 5173,
    timeout: 120 * 1000,
    reuseExistingServer: !process.env.CI,
  },
});