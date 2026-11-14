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

## Tool-output handoffs

### Authoritative instruction

The tool-output handoff bullet in [`AGENTS.md`, Delegation](../../agent/AGENTS.md#delegation) owns the standing rule. It supplies an action at delegation time, not a blanket claim about subagent file permissions. The rule applies to authorized delegation to subagents; it grants neither delegation authority nor new tools.

### Problem and motivation

A tool result available to one session is not automatically an input to another. A path returned by the tool can identify session-private storage rather than a file the receiving agent can read. A shared working directory and a parent-child relationship do not themselves transfer access.

AFT's protected bash-task store illustrates this boundary: its ordinary output-read exception is tied to the native session that owns the task. A fresh AFT-backed child can therefore be refused the parent's stdout even when both sessions use the same project directory. Ordinary task reports can remain readable, and a child using native Pi readers has a different access path. The restriction is not evidence that every subagent is unable to read every tool result or external file.

### Rationale and scope

Short output needs no file. An existing readable report needs no duplicate; a dedicated handoff artifact is useful when required evidence otherwise exists only in session-private output. Keep the underlying tool-managed records in their established location rather than mirroring the tool store.

The assignment determines the evidence boundary. A summary or excerpt can be sufficient for a bounded question, but it does not satisfy a request to inspect the complete original output. In that case the handoff preserves the full output unchanged; selecting only favorable lines would prevent the reviewer from looking for omitted contradictions. A recorded digest does not replace access to the bytes needed to verify it, nor does an exported file itself prove that it is identical to the origin.

Existing destination, disclosure and copying constraints still apply. If they prevent a required handoff, surface that conflict rather than silently weakening the review or bypassing the access policy. A child missing required evidence reports the gap to its parent within its existing authority; a read-only role does not acquire permission to create the artifact, rerun commands or change tools.

### Failure cases without the rule

| Handoff assumption | Possible consequence |
| --- | --- |
| A private stdout path is sufficient because parent and child share a project. | The child reaches an access refusal instead of the evidence; escalation and re-export interrupt the review. |
| A path readable by one role is readable by every role. | Different tool implementations are mistaken for a universal access contract; a reported limitation may go untested. |
| A parent's selected observations replace requested full output. | Omitted failures or contradictions cannot be inspected independently, while the review may appear more complete than it is. |
| A blocked read is an instruction to retry through other readers or widen permissions. | An evidence-transfer problem becomes an unauthorized change to the protection boundary. |

### Evidence and limits

Native tool-managed output retains its own expiry rules. A handoff artifact in task storage follows the [task-storage lifetime](task-workspaces.md#storage-lifetime-and-durable-artifacts); accessibility during the task is not a post-completion retention guarantee.

A motivating incident recorded one AFT-backed `grep` refusal. The paired native-reader child did not attempt stdout, so its asserted inability was not a second demonstrated denial. The exact historical AFT build was not pinned.

The mechanism is source-confirmed in [AFT v0.64.0's private-store floor](https://github.com/cortexkit/aft/blob/v0.64.0/crates/aft/src/access_policy.rs#L647-L815) and [session-owned artifact checks](https://github.com/cortexkit/aft/blob/v0.64.0/crates/aft/src/bash_background/registry.rs#L2202-L2309), with the same relevant ownership boundary inspected in v0.63.5. This is a workflow rule, not an AFT permission grant or a promise that every chosen artifact path is readable. Tool/backend changes require separate authorization.
