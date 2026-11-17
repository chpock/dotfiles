# Review a change

## Establish the reviewed change

Obtain the intended behavior, approved constraints and exact diff: base/head for a committed change, or the assigned staged/unstaged/untracked work. Read the affected current code. If the role cannot obtain the required diff, request it from the primary; another working-tree snapshot is not a substitute.

## Assess the whole change

1. For overall risk, prioritizing a broad review or identifying introduced/resolved health findings, use `get_change_risk` for the reviewed scope. Skip this whole-change query when the assignment is already bounded and needs no such assessment.
2. Read `directive` and `health_delta` first. Follow the concrete reasons into the diff, separating newly introduced problems from pre-existing findings merely touched by the change. Use `risk_percentile` only to describe the change's relative size/spread, not its probability of containing bugs.
3. Resolve a warning, unknown status or empty filtered change before treating the result as usable. A zero score from an unmatched scope is not a clean review.

## Drill into the affected files

1. For changes to shared contracts, imports/exports, file placement or behavior across components, establish consumers outside the diff. If the needed evidence is missing, use `get_risk` in `changed_files` mode; add `graph` when the consumer lists are needed. Reuse equivalent evidence from the whole-change assessment.
2. Inspect its relevant directive leads against the actual change:
   - `may_break`: check what the consumer uses and whether that contract changed. Reachability is not demonstrated breakage.
   - `missing_cochanges`: inspect the untouched partner for a genuinely required coordinated update.
   - `missing_tests`: determine which changed behavior lacks verification, rather than treating a filename heuristic as measured coverage.
   - `tests_to_run` or `impacted_tests`: apply `references/validation.md` before claiming the selection is sufficient.
3. Resolve remaining rename/signature/return/error/shared-state compatibility questions at actual symbol use sites using `get_context` references/callers and current source. Check dynamic registration and public entry points the static list may miss. For cross-repository effects, follow `references/workspace-analysis.md`.

## Investigate what the change puts in question

- For changed architectural choices or relevant decision markers, follow `cases/history-and-decisions.md`; check the governing decision and any approved departure. For recurring regressions, compare the correction with the relevant previous fixes.
- For a quality regression or claimed improvement, follow `cases/quality-and-cleanup.md`. Use targeted health findings only for evidence the change-level delta did not provide. A deletion justified as unused code needs that case's removal checks.
- For moved paths, headings or documented names, follow `cases/literal-references.md`. Read the prose itself when the review also concerns semantic agreement.
- For a required quality/security/coverage gate, follow `references/validation.md`. Do not invent a new gate or approval threshold from a risk score.

## Conclude from verified findings

Resolve each material task-relevant lead as a confirmed defect, a rejected hypothesis or an explicit evidence gap. Tie defects to the reviewed change and affected behavior; distinguish pre-existing problems and optional improvements. Report the analyzed scope and material coverage/freshness limits. Tool scores and recommendations do not establish that a change is safe to merge.
