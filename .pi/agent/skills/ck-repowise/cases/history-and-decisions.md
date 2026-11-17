# Recover history and governing decisions

## Explain why an area was built this way

1. Identify the subject, paths and relevant period. Read already-supplied decisions and source spans. For a WHY/DECISION/TRADEOFF/ADR marker, request the file's `get_context` `decisions` view to find the record and its affected scope.
2. Use `get_why` for the remaining rationale question. Prefer targets-only or recognized-path lookup for a named area; use a focused natural-language query only when needed, under the embedding checks in `references/querying.md`. Skip another lookup when the applicable record is already available.
3. Open the original ADR, comment, PR/commit text or historical source. Check scope, date and source-span provenance (`exact`, `fuzzy`, `unverified`). Archaeology and an alignment score are leads, not authoritative design decisions.
4. Reconcile the records: accepted decisions govern their recorded scope; candidates are proposals; historical records describe withdrawn or superseded choices. Follow conflict/supersession links and compare them with the approved task and current implementation.
5. Explain observed behavior separately from recorded rationale and inference. If no applicable decision is found, state the coverage of that search rather than claiming no decision was ever made. Before contradicting a governing choice, surface the concrete conflict; reuse an already-informed operator decision unless new evidence changes it.

## Investigate a regression or reconstruct change history

1. Anchor the investigation to the affected path and symptom. Use `get_context` `changes` for its recent change records; for a recent regression, `suspects` with the symptom ranks candidate changes from the last 14 days. Use `get_risk` for repeated-fix and co-change patterns when the question spans earlier fixes, not just recent candidates.
2. Inspect candidate commits and historical source. Establish what each fix changed, which assumptions it made, and whether a missing coordinated update could explain recurrence. Compare that behavior with the current failure. Counts, bug-fix labels and co-change correlation do not establish causation.
3. When the question concerns maintainers or review ownership, use targeted `get_context` ownership/last-change evidence, or `get_risk` with `owners` for aggregated ownership. Add `churn` only for a change-pattern question. Verify consequential ownership claims against Git or declared ownership.
4. For a question about agent/human authorship, request `get_context` provenance and retain its unknown share and attribution limits. Unknown authorship is not human authorship.

Finish the investigation with a source-supported sequence or explanation, the relevant candidate changes accepted/rejected, and any missing history or causal evidence named.

## Audit or maintain decisions when assigned

1. For a repository-wide decision audit, use `get_why` without a subject. Investigate stale records, unresolved candidates and ungoverned hotspots in the requested scope; the dashboard is not ordinary pre-edit preparation.
2. When assigned to record an approved choice, use the project's maintained decision location. If the task also authorizes Repowise records, use `decision add` with the decision, rationale, affected scope and supporting evidence. Mark agent-proposed choices as the agent's; a candidate is not a governing acceptance. Record creation may embed text, so check model permission as well as mutation authority.
3. When assigned to review stored candidates or existing decisions, inspect their blockers and original evidence before using confirm/dismiss/merge/deprecate/reaffirm. Record the actual authorized disposition; never change record status merely to remove a conflict from the analysis.

For a requested historical report, use stored change/event views or `report changes` under the read-only reporting guidance in `references/querying.md`. Keep unavailable records explicit rather than creating them during the investigation.
