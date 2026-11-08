# Delegation and subagent use

This document explains delegation and subagent-use policies, the problems they address, and their rationale. The authoritative instructions are in the global [`AGENTS.md`, Delegation](../../agent/AGENTS.md#delegation); this document is not an additional mandatory instruction source. Runtime configuration belongs in the [pi-subagents configuration guide](../pi-subagents.md).

## Run timeouts and continuation

### Problem and motivation

A delegated task can outlast its assigned runtime while still making useful progress. If the parent interprets that timeout as evidence that the subagent mechanism is broken, it may abandon delegation, take over unfinished work unnecessarily, or restart without using the child's accumulated context.

This confuses an exhausted time budget with a technical failure. Increasing the default timeout can reduce interruptions, but it does not correct the inference: the same mistake remains possible when the longer deadline expires.

### Rationale for the rule

A run deadline establishes how much time that run was allowed, not why the task remained unfinished. It is distinct from a model/network timeout, a tool timeout, or a launch/setup failure. Even a run deadline does not prove that the only problem was an underestimated workload: the child may have been blocked or making no useful progress.

Checking progress and partial results grounds the continuation decision in evidence. When the budget was underestimated, resuming the latest eligible child preserves available context and lets the remaining work continue within the approved scope. An explicit revised `timeoutMs` gives that continuation an intentional time budget rather than relying on the earlier run's deadline or implicit defaults.

Eligibility and the appropriate resume API remain the responsibility of the native runtime and its guide. A lack of progress calls for diagnosis, not blind retries or indefinite budget increases.

### Scope

The rule concerns interpretation and recovery after a run timeout. It neither prescribes a fixed duration nor changes timeout configuration. Existing delegation authority and task boundaries still apply; a timeout alone does not invalidate the chosen delegation approach.
