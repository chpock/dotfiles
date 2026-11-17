# Run the selected Repowise operation

## Bind and discover the operation

1. Reuse the session-CWD Git proof and known target root. Resolve a missing root once with Git; a child without the required tools requests CWD-specific verification from the primary.
2. Reuse the selected operation's current schema. Otherwise search for that operation through the `mcp` gateway on server `repowise`, then describe its returned name. Recover the saved full schema/result if a preview omits needed details. Use the discovered arguments rather than a remembered output shape.
3. For a selected CLI method or a suitable CLI fallback, read only that command's help and establish its side effects and required inputs. Apply the CLI startup prefix from `SKILL.md`. An unavailable service/tool does not authorize installation, changing permissions or enabling an opt-in surface.
4. Bind the operation to the intended repository, not an enclosing store or workspace. Use an explicit supported selector when needed; otherwise request a session at the target root. Changing a shell command's CWD does not retarget the MCP server. Establish binding before a mutating or model-using operation; leave global MCP registration unchanged.
5. Apply the authorization checks below before invocation. For otherwise-unknown readiness, use the selected analysis itself rather than a preliminary status survey. Only a known missing index or relevant stale fact calls for `references/index-lifecycle.md`.

## Check model and mutation authority

Credentials and provider configuration are not usage permission. Establish the relevant backend and task authorization before a model/embedding call:

- `get_answer` may autodetect credentials and synthesize with a model.
- Concept/hybrid `search_codebase` can embed its query when real semantic vectors are present. Structured symbol/path lookup or AFT can avoid that route when sufficient.
- Natural-language `get_why` can embed the query even with `targets` supplied. Targets-only and recognized-path lookup avoid this query-embedding route; prefer them for a named area when sufficient.
- Generated prose/patches and decision-record creation may also use models. Mock indexing does not supply model-based semantic retrieval.

Use structural/history evidence when it answers the question without unapproved model use. Before invoking a mutating service, check that both the assignment and role permit it; an inspection-only role cannot acquire write authority through `mcp`. The grant in `references/index-lifecycle.md` covers only its guarded local preparation operations.

## Read the result and decide the next step

1. Confirm repository identity, targets/range, ignored arguments, returned scope, omissions/completeness and freshness/provenance. Source-backed, stored-analysis and generated-prose blocks can have different ages. No stale warning is not proof that the working tree is represented.
2. Match the result to the intended change. In particular, `get_change_risk` without a revspec uses uncommitted work, or HEAD when the tree is clean; do not silently substitute that for the assigned branch/range or narrower diff.
3. Verify consequential conclusions against current source and the task contract. Recover omitted material only when needed for that conclusion. Confidence, deletion flags and scores are not proof or approval.
4. Distinguish an unsupported relation, unresolved/excluded target, missing/stale index, unavailable stored analysis and failed service. Use the corresponding source inspection, corrected target or reported gap; only a genuine index dependency selects index preparation. A query/update does not guarantee current health, coverage, prose or decisions.
5. Continue only for an unresolved task-relevant check, not merely because `next_actions` suggests more work. Stop when the check is answered or its evidence gap is established; continue with ordinary evidence where the task can still be completed honestly.

For requested structured deliverables, select the relevant stored `report`/`export` output and its authorized destination. Inspect build/write behavior before use; in particular, `report changes --no-build` avoids creating missing change records during a read-only report.
