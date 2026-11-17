# Assess quality and remove unused code

Use the health procedure for quality/refactoring questions. For unused code, start with the removal procedure. Before relying on either analysis, apply the input-support limits in `references/source-analysis.md`.

## Choose worthwhile improvements

1. For "what should we improve?", start with the `get_health` dashboard and `fix_first`. For a named file/module, use targeted health findings instead of a repository-wide read. Request `biomarkers` to inspect the specific problems; add refactoring, coverage or trend evidence only for the corresponding question.
2. Check unresolved targets, language exclusions, withheld/provisional findings and data freshness before ranking results. A target that matched nothing is not clean; absent coverage is not proof of no tests. Resolve the target or report the unavailable analysis rather than treating every gap as an index problem.
3. Open the relevant `fix_id` and inspect its evidence, proposed steps and suggested tests. For a concrete finding, expand its `finding_id`; for a stored refactoring plan, request its `recipe` by `plan_id` to obtain preconditions, steps and postconditions. Check those preconditions in current source before recommending the transformation.
4. Explain the practical problem and benefit. Use `weighted_deficit` to compare the size-weighted gap, not the score alone. At the score floor of 1, inspect `total_deduction` and the findings for losses the score hides; weighting by file size does not recover those differences.
5. Before recommending an edit, check consumer/fix-history risk with targeted `get_risk` where it could change the choice or scope. Present concrete work, its affected behavior and verification needs. When implementation is authorized, follow `cases/changes.md`; a tool's recipe is not authorization.

## Investigate performance or test gaps

- For a performance question, request the `performance` health view and open the relevant `opportunity_id`. Inspect its evidence, boundary and preconditions in source. Treat it as an optimization hypothesis; a static opportunity is not a measured bottleneck or speedup.
- For untested complexity or coverage questions, request the relevant `coverage`/`untested_complexity` evidence. Follow `references/validation.md` to distinguish measurements from inference and to establish what the existing tests actually cover.
- If required coverage or health data is missing, report the gap. Coverage ingestion and health recomputation require their own task authority; the index-preparation grant does not include them. Use an existing report or a suitable change-level check when that can answer the question without mutating the store.

## Verify a claimed improvement

1. Before editing, record the target/revision, relevant findings and analysis provenance as the baseline. Choose the same behavior, metric and scope for the comparison.
2. After editing, use distinct applicable health snapshots or a valid `get_change_risk` health delta for the actual change. For an assigned Git-based health gate, follow `references/validation.md`.
3. Check that the intended problem improved without invalidating its consumers or verification obligations. `get_health` reads stored analysis: another query or an index-only update does not establish recomputed health. If a comparison is unavailable, report the source-level change without claiming measured improvement.

## Investigate and remove unused code

1. Use scoped `get_dead_code` to find candidates. Distinguish unreachable files, unused exports and packages without consumers. For a named removal, obtain only the missing candidate/consumer evidence rather than auditing the whole repository.
2. Investigate the high-confidence candidates first, but verify every proposed removal in current source. Check public/package entry points, dynamic imports, framework/plugin registration, reflection and relevant generated/runtime consumers. `safe_to_delete` and zero static callers are not proof of unused code.
3. Check file-level impact with `get_risk` and its `graph` view, or resolve remaining symbol use sites with `get_context` references. Reuse sufficient consumer evidence. Inspect recent activity and any rationale that could explain an apparently unused entry point.
4. Present confirmed removals separately from candidates still needing investigation. Remove only within the authorized cleanup scope; resolve new compatibility/design trade-offs before proceeding. Already-authorized, verified deletions do not need per-file reapproval.
5. Unless dependency constraints require another order, remove unreachable files first, then unused internal symbols, then unused exports. Verify imports/exports and affected behavior after removal through `cases/changes.md`; repair remaining literal references through `cases/literal-references.md`.

Finish with each selected finding resulting in justified work, a rejected hypothesis or an explicit unresolved candidate, and with any claimed improvement supported by the relevant comparison.

## Use optional plan operations only when assigned

For an authorized model-assisted patch of a selected refactoring plan, the opt-in `generate_refactoring_code` can produce a patch to inspect before application. Otherwise implement the approved recipe with AFT. When assigned to save a plan's disposition, the opt-in `set_finding_status` updates a stored refactoring suggestion and can suppress future re-emission; it is not a generic annotation for arbitrary findings. Apply the model/mutation checks in `references/querying.md` before either operation, and keep existing role permissions unchanged.
