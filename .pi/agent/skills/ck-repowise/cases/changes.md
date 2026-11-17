# Prepare and make a source change

## Establish the change

Read the affected source with AFT. Identify the intended behavior and the contracts, names or paths that will change. Preserve old identities before moving, renaming or deleting them so their consumers can still be found.

## Assess impact before editing

1. For shared behavior, module wiring or changes whose effects extend beyond the edit sites, batch the planned files in `get_risk`. Use `targets` for this prospective assessment; request `graph` when identifying consumers. Skip this analysis for an already-bounded local edit with no unresolved impact question.
2. Work through the relevant evidence:
   - Inspect consumers against the specific contract being changed. Resolve outstanding symbol use sites with `get_context` references/callers; inspect actual uses, exports and framework registration before deciding which must change.
   - Check co-change partners for an omitted coordinated update. Historical co-change is a lead, not an instruction to edit the partner.
   - Examine repeated-fix evidence before repeating an earlier correction. Follow `cases/history-and-decisions.md` for recurring regressions or a failed previous fix; approximate per-symbol fix counts only identify where to investigate.
   - Identify test gaps and security-sensitive behavior that the edit could invalidate. Use `references/validation.md` when selecting checks or evaluating their coverage.
3. Before changing an architectural boundary or established pattern, or contradicting a relevant WHY/DECISION/TRADEOFF/ADR marker, follow `cases/history-and-decisions.md`. For a structural refactor, use targeted `get_context` with the relevant relationship and `decisions` views rather than relying on the file body alone.
4. If the change is intended to improve measured quality, establish the baseline through `cases/quality-and-cleanup.md`. Use its unused-code procedure before a deletion justified as cleanup. For moved paths or changed documented identifiers, inspect reverse references through `cases/literal-references.md` while the old target still exists.
5. Turn the findings into the required edit sites, compatibility obligations and affected checks. Surface material consumer, prior-fix or governing-decision risks before proceeding; resolve any resulting scope or design decision under the existing approval rules.

## Reconcile the actual change

1. Inspect the actual diff after editing. Account for added/removed files and any contract changes not present in the plan. Reuse pre-edit evidence only where it still describes the changed identities and behavior.
2. If related updates or affected tests remain uncertain, use `get_risk` with the actual `changed_files` set. Investigate its outside-diff consumers, missing co-changes and test leads; do not label all reachable consumers broken.
3. When an overall risk assessment, review prioritization or health delta is needed, use `get_change_risk` for the actual range or working tree. Reuse sufficient per-file/test evidence already returned rather than making a second risk query for the same question.
4. Verify the identified behavior and compatibility obligations with the project checks. For a quality claim, compare valid before/after evidence through `cases/quality-and-cleanup.md`; for changed literal references, verify both old and new identities through `cases/literal-references.md`.

Finish with the actual edit set and its relevant consumers accounted for, required checks completed or explicitly unresolved, and no unsupported claim that an index refresh proves correctness. When entering review, follow `cases/review.md`.
