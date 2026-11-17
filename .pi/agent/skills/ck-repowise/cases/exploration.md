# Understand code or diagnose a failure

## Find the implementation

1. Start from the supplied identifier, path, symptom or question. Use AFT to find definitions and read the relevant source. If a known file or symbol answers the question, finish from that evidence.
2. For orientation in an unfamiliar repository or a requested system map, use `get_overview` once. Identify the relevant components and entry points, then narrow to those targets with `get_context`. Skip orientation when the map is already established.
3. When the implementation is still unidentified and indexed documentation can locate the concept, use `search_codebase` with a focused query. Follow relevant hits into batched `get_context` targets. Treat lexical (`bm25`) matches as leads to inspect, not semantic confirmation. Use AFT for source bodies; `get_symbol` can resolve an already-returned symbol ID or source pointer without another search.

## Answer the concrete question

1. For a cross-component explanation, use `get_answer` when indexed context would consolidate the answer, subject to the model checks in `references/querying.md`. Ask one focused question. If synthesis is unavailable or unauthorized, follow targeted structural context and current source instead.
2. Read cited implementations before relying on an explanation. For medium/low confidence, ambiguity or an empty answer, follow `best_guesses` or `fallback_targets` into `get_context` and the relevant source. An empty answer from template-only documentation does not establish that an implementation is absent.
3. Trace the relationship needed for the answer: callers for entry paths, callees for downstream behavior, references for use sites. Use the symbol-target views and path/flow methods in `references/source-analysis.md`; stop at the boundary the question asks about. For behavior crossing repositories/services, continue with `references/workspace-analysis.md` rather than treating one repository's graph as the whole system.
4. If the question is about the consequences of changing a file, use targeted `get_risk` with its `graph` view and inspect the relevant consumers. Reachability alone does not establish a behavioral consequence.

## Follow the failure or historical question

- For a recent regression, request the target's `get_context` `suspects` view with the symptom. Inspect the proposed changes and their actual diffs; the ranked recent-change list is not a root-cause finding.
- For recurring failures, earlier unsuccessful fixes, design rationale or ownership, follow `cases/history-and-decisions.md` before adopting the same explanation again.
- If the task becomes choosing improvements or finding unused code, follow `cases/quality-and-cleanup.md`. For unresolved literal references, follow `cases/literal-references.md`.

## Finish

Explain the requested behavior or failure using the relevant source path and checked relationships. Separate observed implementation, recorded rationale and hypotheses. Resolve each material lead needed for the answer or name the remaining evidence gap; do not fill a missing edge with a generated explanation.
