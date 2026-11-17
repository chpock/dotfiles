# Select checks and evaluate validation evidence

## Choose affected tests

1. Use test-selection evidence already returned by the relevant analysis: `get_risk` provides `tests_to_run` and its status/reasons/basis; `get_change_risk` provides `impacted_tests`. If only test selection is needed, use CLI `impacted-tests` for the actual change rather than obtaining unrelated risk analysis. Selection does not execute tests.
2. Read status and fallback indicators before treating the list as sufficient. In `get_risk`, check `tests_run_all`, its reasons and any `tests_status`; in `impacted_tests`, check `status`, `run_all` and reasons. Timeout, invalid configuration, unknown/new code or `run_all` means the selector cannot justify a smaller set. The listed tests can still be useful first checks.
3. Distinguish `measured` per-test coverage from `inferred` graph/rule/filename evidence. Check that stored coverage represents the relevant revision and paths; neither label proves a test was run for the current change.
4. Establish the required verification scope from affected behavior/contracts and project requirements. Record any independently justified narrower set separately from an incomplete Repowise selection. Report unresolved selection or coverage gaps rather than turning an empty list into "no tests needed".

## Check coverage or quality/security requirements

1. Identify the actual requirement, change scope and existing project policy. Use `repowise check` for assigned `.repowise/policies.yaml` rules. For a specific assigned gate, use the corresponding `health check`, `security check` or `coverage check`, not a newly invented threshold.
2. Supply the intended revision/range explicitly when command defaults could select another change. Follow the selected command's help for its scope and inputs. Health/security change checks can use Git directly; coverage checks can use Git plus existing reports. Prepare an index only if the selected path actually requires one.
3. For coverage, verify report paths, revision and available executable-line/branch data. An old report or inferred filename match cannot establish patch coverage. Reading a report is separate from ingesting it into Repowise; ingestion, recomputation, history scans, baseline writes and policy changes require their own task authority.
4. Inspect both the result and what was evaluated. A missing policy, empty matching change or skipped measurement is not a substantive pass. For the shared CI gates, exit 1 means a failed gate; exit 2 means the check could not evaluate. Keep those outcomes distinct and report any uncovered requirement.

Use the project's actual test/build checks to verify behavior. Repowise selection, scores, static findings and gate reports provide evidence for their stated scope, not a replacement for those checks.
