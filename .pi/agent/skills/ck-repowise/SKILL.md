---
name: ck-repowise
description: Use when the AGENTS.md Repowise loading rule applies.
---

# Repowise in Pi

## Choose the procedure

Read the case for the assigned task **before doing that work**. Follow another case when the work enters its activity, not as a checklist of all cases.

| Task | Read |
| --- | --- |
| Understand code, find an implementation or diagnose a failure | [Exploration](cases/exploration.md) |
| Prepare or make a source change | [Changes](cases/changes.md) |
| Review a proposed, committed or working-tree change | [Review](cases/review.md) |
| Recover history, rationale, ownership or governing decisions | [History and decisions](cases/history-and-decisions.md) |
| Assess quality, choose refactoring work or remove unused code | [Quality and cleanup](cases/quality-and-cleanup.md) |
| Audit or update literal links, anchors, imports or paths | [Literal references](cases/literal-references.md) |

Use AFT for current-source lookup, reading and editing. Apply the procedure to the actual task and evidence discovered during it. Use Repowise when an applicable supported analysis supplies missing evidence or materially simplifies obtaining it; reuse sufficient evidence with matching scope, coverage and freshness. Skip irrelevant or already-answered checks. A self-contained task can finish without a Repowise query.

## Load support at the point of use

- Before selecting Repowise source/risk/health analysis, read [Source analysis](references/source-analysis.md) for input support and evidence limits.
- Before the first selected Repowise operation, read [Querying](references/querying.md) for repository binding, discovery and authorization.
- When that analysis needs a missing or stale index, read [Index lifecycle](references/index-lifecycle.md).
- To interpret Repowise test-selection/coverage evidence or evaluate an assigned quality/security/coverage gate, read [Validation](references/validation.md).
- When tracing code relationships or change impact across repositories/services, read [Workspace analysis](references/workspace-analysis.md).

Resolve `cases/...` and `references/...` paths relative to this skill directory. Prefix **every Repowise CLI invocation**, including help, with `REPOWISE_SKIP_EDITOR_SETUP=1`.

For maintaining this skill, read [README.md](README.md).
