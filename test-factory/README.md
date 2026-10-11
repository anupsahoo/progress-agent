# Test Factory

Test assets produced by the **FlowPilot AI Test Factory** (CogenSight). Every case was written by AI from
the acceptance criteria and approved by a person before it was added here.

## Layout

```
test-factory/
  functional/
    web-ui/          <id>.spec.ts       automated UI tests            (3 in this PR)
    backend/         test_<id>.py       service and database tests    (2)
    api/             <id>.api.spec.ts   API tests                     (3)
    manual/          <id>.md            manual functional test cases  (4)
  non-functional/
    performance/     <id>.k6.js         load and stress scenarios     (2)
    security/        <id>.yaml          OWASP-mapped security cases   (3)
    accessibility/   <id>.md            WCAG 2.1 AA cases             (2)
    visual/          <id>.md            visual regression cases       (2)
  suites/            smoke, sanity, regression and uat manifests
  test-data/         synthetic data only, never real customer data
  reports/           execution reports land here
```

## Suites

| Suite | Purpose | Runs | Cases |
|---|---|---|---|
| smoke | Is the build alive? Critical paths only. | Every commit | 3 |
| sanity | Does the changed feature basically work? | Every build | 4 |
| regression | Did anything that used to work break? All automated tests. | Nightly | 17 |
| uat | Business scenarios for user acceptance, in plain language. | Before release sign-off | 4 |

## Running

- UI and API tests: `npx playwright test test-factory/functional`
- Backend tests: `pytest test-factory/functional/backend`
- Performance: `k6 run test-factory/non-functional/performance/<id>.k6.js`
- Manual, security, accessibility and visual cases are checklists for the QA team and CI gates.
