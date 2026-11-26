# pi-subagents configuration

This guide describes the selected pi-subagents configuration and its rationale: models/thinking, role boundaries, child providers, tools, skills and MCP access. It is a configuration reference, not a change log or deployment audit. Shared Pi defaults and MCP settings belong in [settings.md](settings.md); see [CONTEXT.md](CONTEXT.md) for document boundaries.

Model/thinking semantics are based on **Pi 1.3.0** and **pi-subagents 0.78.0**; MCP contracts retain their earlier Pi 1.2.0 basis unless stated otherwise. Instruction inheritance additionally uses Pi 1.4.0 and pi-subagents 0.84.0. Skill selection, resource exclusion and custom-role settings ownership use **Pi 1.5.0** and **pi-subagents 0.87.0**. MCP provider examples specify the official npm `pi-mcp-adapter` setup. Web permission/activation semantics use **Pi 1.5.2**, **pi-subagents 0.88.1** and **pi-web-access 0.47.0**. Consultant continuation uses the same Pi/pi-subagents versions; its provider entry point is from **pi-anthropic-auth 2.4.10**. These are source-contract versions, not deployment status.

**Shared baseline:** [main model and thinking](settings.md#default-model-and-thinking). **Model evidence:** [2026-11-18 assessment](models-2026-11-18.md). **When reviewing models or preparing another assessment:** use [model-selection.md](model-selection.md), which owns capability profiles, research rules and the report format.

## Configuration ownership and scope

| Location | Responsibility |
| --- | --- |
| [`~/.pi/agent/settings.json`](../agent/settings.json), `packages` | Loads `npm:pi-subagents` in the parent. |
| [`~/.pi/agent/extensions/subagent/config.json`](../agent/extensions/subagent/config.json) | Owns extension display preferences and schedule availability, separately from Pi settings and role overrides. |
| [`~/.pi/agent/settings.json`](../agent/settings.json), `subagents.defaultExtensions` | Sets the base child-provider list for roles without their own `extensions`. |
| [`~/.pi/agent/settings.json`](../agent/settings.json), `subagents.defaultSubagentOnlyExtensions` | Supplies the common child-only MCP adapter for roles without their own child-only list. |
| [`~/.pi/agent/settings.json`](../agent/settings.json), `subagents.agentOverrides` | Owns local role differences: models/thinking, context inheritance, tools, extensions, and skills. |
| `~/.pi/agent/npm/node_modules/pi-subagents/agents/` | Upstream builtin prompts and defaults; do not copy them merely to change individual settings. |
| [`~/.pi/agent/agents/second-opinion.md`](../agent/agents/second-opinion.md) | Custom role identity and advisory prompt. Its role-specific model, context, tools, base provider and skills are owned by `subagents.agentOverrides.second-opinion` in settings; common child-provider defaults are inherited. |
| [`~/.pi/agent/agents/consultant.md`](../agent/agents/consultant.md) | Custom consultation identity and advisory prompt. Operational settings belong to `subagents.agentOverrides.consultant`; authorization and continuation policy belong to the primary APPEND. |
| Each selected skill's `SKILL.md` | Owns that skill's instructions; do not duplicate them here or in role prompts. |

Scope is the seven enabled builtin native roles and the custom native `second-opinion` and `consultant` roles listed below. The six external CLI profiles (`codex-exec`, `claude-code`, `cursor-agent`, and their `-writer` variants) have `disabled: true` because the operator does not use the Codex, Claude Code or Cursor agent harnesses. Omitting those overrides would allow their builtin profiles to be discovered, subject to runner availability; disabling a profile does not uninstall its CLI. `advisor` is an alias for `oracle`, not a separate configured role.

These are user-level settings across projects. Project definitions/settings and supported launch overrides can replace the effective selection. Such replacements must preserve the mandatory inspection baseline below; native override support is not permission to remove required capabilities. Inspect the resolved role rather than assuming lists merge.

### Shared child configuration

**AFT and Magic Context are required for every enabled native subagent, including new and custom roles.** Each role must load both providers and permit the inspection/context tools in [Base](#selected-file-shell-and-research-tools). This shared baseline provides indexed source inspection and project/history retrieval without a role-specific capability gap. Read-only roles gain inspection and own-session context management, not source-edit or shared-memory-writing authority.

- `subagents.defaultExtensions` loads AFT and Magic Context from their installed package entry points. This explicit list avoids ambient parent-extension discovery; it is not an additive list of every parent package.
- `subagents.defaultSubagentOnlyExtensions` supplies the MCP adapter as a common child-only addition to the selected base providers. A role's own `subagentOnlyExtensions` replaces this default rather than merging with it; it does not replace the separate `extensions` list.
- `oracle`, `researcher`, `evidence-auditor`, `second-opinion` and `consultant` have explicit `extensions` lists containing the same two providers plus `pi-web-access`; consultant also loads its Anthropic provider. Omitting those role lists would fall back to the base list, which does not supply their required web tools or consultant's authentication provider. All five roles permit the four operational Web tools. `second-opinion` and `consultant` omit the activation helper under their [DeepSeek](#deepseek-exception-for-second-opinion) and [Sonnet/CortexKit](#sonnetcortexkit-exception-for-consultant) exceptions.
- All configured native roles retain project and global instructions through `inheritProjectContext: true` and `inheritGlobalContext: true`. Builtin project-context defaults are retained; local settings select global inheritance and explicitly configure both flags for the custom roles. Without global inheritance, global instructions are excluded by default. Skill inheritance is controlled separately below.
- A role-specific `extensions` list replaces the base provider list; it must retain AFT and Magic Context when adding other providers. The child-only MCP adapter is additive to that selected list. Likewise, replacement `tools` lists must retain Base, including for inspection-only roles.
- Role `tools` lists are explicit allowlists. A listed extension tool needs its provider loaded; loading a provider alone does not grant every tool it registers. Preserve existing inspection/execution boundaries when adding a capability. A read-only research task can still return an assigned report; it does not authorize source edits.

The native child diagnoses missing declared tools at startup. Treat a missing provider/tool or failed inspection call as a setup failure, not a successful native-tool fallback; report it rather than accepting degraded capability. Verify registration and successful calls, not just allowlists. These settings do not introduce unconditional provider injection or remove native override mechanisms.

Magic Context also supplies its normal context guidance and session handling. `ctx_reduce` queues reduction of the child's own context; `ctx_memory` and `ctx_note` remain excluded. AFT-backed reads follow AFT's access policy: loading AFT does not grant access to another session's private output. Apply the [evidence-handoff rule](agents-md/delegation.md#tool-output-handoffs) rather than substituting another reader.

MCP is an additional provider for all active native roles; its wiring is defined in [MCP access](#mcp-access). Model/other runtime overrides remain in the same settings file; this guide does not redefine upstream prompts, output defaults, or acceptance behavior. Each custom role's prompt is maintained in its own definition.

### Instruction inheritance and primary-only text

The [global `AGENTS.md`](../agent/AGENTS.md) supplies shared policy; the [operator's `APPEND_SYSTEM.md`](../agent/APPEND_SYSTEM.md) supplies the primary workflow trigger, absolute-path handoff instruction, consultation/reporting policies and scoped consultant authorization. The [design guide](agents-md/instruction-layers.md#purpose-and-selected-architecture) explains content ownership, rationale and alternatives. Effective child loading follows the inheritance and fresh/fork rules below.

- For fresh native children, `inheritProjectContext: true` permits context-file loading and `inheritGlobalContext: true` retains the global file. Disabling project-context inheritance also removes that common-file route; skill inheritance is separate.
- The native loader explicitly supplies child append input, preventing automatic discovery of the operator's APPEND file. An append-mode child's own role prompt is not that operator file.
- A fork retains the parent's effective system prompt/history, including primary instructions even when the child's inheritance flags are false. These settings therefore do not guarantee primary-text exclusion from every child.
- Child decisions go through the supervisor within existing authority; preserving common rules does not grant tools or overall task/roadmap ownership. See the [decision-routing contract](agents-md/instruction-layers.md#decisions-and-delegated-authority).

The [fresh/fork and override limits](agents-md/instruction-layers.md#how-the-selected-mechanism-works) and [observable contract](agents-md/instruction-layers.md#observable-contract-and-verification-limits) distinguish source-supported loading from runtime verification. Retain the native roles and existing context preferences unless an explicit decision changes them.

## Display and schedules

The user-level extension file `~/.pi/agent/extensions/subagent/config.json` contains:

```json
{
  "fleetViewPlacement": "aboveEditor",
  "scheduledRuns": { "enabled": false }
}
```

The following behavior is based on pi-subagents 0.79.0:

| Setting | Effect | Motivation | If omitted |
| --- | --- | --- | --- |
| `fleetViewPlacement: "aboveEditor"` | Places the persistent FleetView above the input editor. | The operator prefers this location for the fleet display. | Defaults to `"belowEditor"`. |
| `scheduledRuns.enabled: false` | Disables schedule actions and removes scheduling parameters from the model-facing `subagent` tool schema. | The operator does not use schedules; excluding their controls reduces the tool-definition content in the model's context window. | Schedules are enabled by default. |

Fleet placement changes only the UI, not model context. Disabling schedules does not disable ordinary immediate or background subagent runs; saved schedules are retained but unavailable while the feature is disabled.

## Model and thinking choices

Select roles by the [task-based model tiers](model-selection.md#task-based-model-tiers), then check their capability and reasoning requirements. The [2026-11-04 decision](model-decisions.md#2026-11-04--luna-executors-and-task-based-model-tiers) selects fixed Luna/max executors from practical experience; it supersedes worker/main parity and the former delegate profile. The [2026-11-18 decision](model-decisions.md#2026-11-18--astra-and-sol-62-successors) moves the [main baseline](settings.md#default-model-and-thinking) and deep-analysis defaults to Sol 6.2 and Astra 6.2 without changing their selected efforts or authority. The [2026-10-31 decision](model-decisions.md#2026-10-31--more-reasoning-for-execution-sol-for-routine-review) retains the practical depth and routine-review rationale. Abstract requirements are defined in the [selection guide](model-selection.md#capability-and-reasoning-profiles); published model comparisons remain in the [dated assessment](models-2026-11-18.md#capability-profile-mapping).

| Role | Selected model / thinking | Motivation |
| --- | --- | --- |
| `scout` | `openai-codex/gpt-6-luna` / `low` | Focused code/file navigation, not investigative research. |
| `worker` | `openai-codex/gpt-6-luna` / `max` | Standard well-scoped implementation: practical experience supports Luna/max for clearly specified execution without unresolved architecture or codebase-wide design decisions. |
| `delegate` | `openai-codex/gpt-6-luna` / `max` | Standard well-scoped general execution: complete a bounded supporting task with a defined result, not a parent workflow or architectural decision. |
| `reviewer` | Inherited main model / fixed `max` | Frequent routine review needs lower resource weights than Astra; use the main model's maximum reasoning depth without claiming equivalence to Astra. |
| `oracle` | `openai-codex/gpt-6.2-astra` / `high` | Bounded consequential diagnosis and reconciliation of decisions. |
| `researcher` | Astra 6.2/high for consequential or conflicting analysis; Sol 6.2/medium for explicitly bounded routine synthesis | Match assignment scope, not token price alone; retain source verification by the parent. |
| `evidence-auditor` | `openai-codex/gpt-6.2-astra` / `high` | Independent verification of decision-critical claims. |
| `second-opinion` | `opencode-go/deepseek-v4.1-flash` or `github-copilot/mai-code-2-flash` / `high` | Additional scrutiny across any domain, with parent verification. Select the model manually based on provider limits. See the [thinking decision](model-decisions.md#2026-11-13--high-thinking-for-second-opinions). |
| `consultant` | `anthropic/claude-sonnet-5-5` / `medium` | Operator-authorized expert perspective using a limited subscription resource, with continuing consultation on related questions. The [model decision](model-decisions.md#2026-11-14--operator-authorized-sonnet-consultant) records the choice without claiming measured superiority or savings. |

For completeness-sensitive critical reviews, use an individually justified `openai-codex/gpt-6.2-astra:high` launch override. Do not automatically repeat every Sol review with Astra. Reviewer remains fresh and independently reads current evidence; using the same model as the author may leave shared blind spots.

For researcher, use an explicit Sol/medium launch only when bounded revisable work is identifiable in advance; otherwise keep the stronger Astra/high default. This keeps the scope distinction without treating every research task as lightweight.

### Role scope and launch policy

The table is parent launch policy, not a claim that every row is a shipped default. Preserve the [tool](#tool-exposure-and-authority), [skill](#skills) and provider boundaries below. A model assignment never grants new authority.

| Role | Scope, capability/depth and deliverable | Quality and context policy | Do not use / escalate when |
| --- | --- | --- | --- |
| `scout` | Focused/Light: navigate code/files; return exact paths/ranges, relevant seams/instructions and the first useful place to inspect. | Fresh, narrow question. Verify consequential paths/claims; assess useful coverage, missing seams and inaccurate handoffs, not citation count. | Files are already known; task requires investigative research, architecture or causal analysis. Hand off that question rather than expand scout's scope. |
| `worker` | Authorized implementation/validation on **fixed Luna/max**. Execute an agreed contract; inspect actual code and return changed files, real checks, failures and residual risks. | Fresh by default with sufficient approved decisions/evidence; one writer per coupled slice. Acceptance, contract compliance, escaped defects and rework determine quality. | The assignment still requires architecture, codebase-wide design or substantial unresolved analysis. Resolve that in the parent/advisor or explicitly choose a stronger model for the launch. Escalate newly discovered decisions instead of guessing. |
| `delegate` | Bounded general supporting task on **fixed Luna/max**, such as a specified comparison, transformation or check. Return the requested artifact/result and evidence. | Fresh sufficient packet. Judge acceptance without parent redo, omitted constraints, correction rounds and total overhead. | Project implementation is better owned by worker; the task requires orchestration or unresolved design/analysis. Keep workflow ownership in the parent; use an explicit stronger-model exception when warranted. |
| `reviewer` | Substantive behavior/contract review with the routine Sol/max profile; use Astra/high for individually justified completeness-sensitive checks. Independently read current targets and affected dependencies/tests; return located, evidenced defects and limits. | Fresh to avoid inheriting the author's conclusion. Track confirmed defects, false claims, severity and triage/rework. Recall requires a known defect set; finding count is not recall. | Trivial observation can be checked directly; another reviewer would repeat the same question. No shell/source edits: ask parent to run needed checks, never claim fictional execution. |
| `oracle` | Deep/Deep: resolve a bounded hard diagnosis, architectural contradiction or decision drift. Return reconstructed decisions, evidence, alternatives, recommendation and unknowns. | Fork when decision history is essential; otherwise provide an explicit decision packet. Judge consequential contradictions and useful advice, not consultation length. | Routine implementation/review; a second decision-maker is not needed. Escalate unresolved operator trade-offs to parent. |
| `researcher` | General/Normal for bounded retrieval and source-grounded synthesis; Deep/Deep for consequential conflicting evidence. Return material claims, exact sources/passages, dates, uncertainty and transfer limits. | Fresh question and stop criteria. Judge supported material claims, decisive gaps and contradictions, not search/citation volume. | One known source answers the question; originals are inaccessible or a material ambiguity remains after the bounded search—report the gap or request a focused escalation. |
| `evidence-auditor` | Deep/Deep for independent verification of a decision-critical claim set. Return supported/contradicted/unclear/missing classifications and evidence. | Fresh, supplied claims/citations but independently inspected originals. Track critical-claim coverage, classification errors and unaudited claims. | Routine research needs no separate formal audit; do not repeat the entire search or treat supplied citations as proof. |
| `second-opinion` | Bounded inspection of arguments, assumptions, conclusions, alternatives and trade-offs in any domain. Return a supported assessment, recommendation, evidence and parent-verification targets. | Fresh decision packet; justified agreement is valid. Mandatory consultation conditions are owned by the primary profile. | No implementation, shell, mutating services, nested delegation or approval authority. Report missing evidence or reserved decisions rather than guessing. |
| `consultant` | Independent expert critique, blind-spot detection and alternative solutions in any domain, including revised advice as evidence changes. | Explicit session/task authorization; fresh first consultation, retained continuation for related follow-ups. Selective use and reporting are owned by the primary profile. | No automatic invitation, routine fanout, implementation, shell, mutating services, nested delegation or approval authority. Resolve missing evidence and reserved decisions with the parent. |

Routine research and high-consequence analytical research are different assignments even when they use the same role. Model/depth changes must match the task, not just the role name. Narrow verification after a fix to the affected behavior and its blast radius; do not restart identical full reviews automatically.

The primary profile owns [operator-facing subagent contribution reporting](../agent/APPEND_SYSTEM.md#subagent-contribution-reporting). Its [explanatory guide](agents-md/subagent-contribution-reporting.md) covers preservation of alternatives, contribution attribution and reporting outcomes without changing role configuration.

### Worker and delegate boundaries

Both roles execute their assignments directly and have the same local tools, explicit skills and MCP provider. Neither has native subagent-spawning permission. The upstream phrase about delegate's orchestration inside a parent workflow does not grant nested delegation; the parent owns routing and follow-up launches.

For a fresh child, worker's `replace` mode supplies its detailed implementation prompt. Delegate's `append` mode adds a short general execution prompt to Pi's normal base prompt; it does not copy the parent's assembled prompt or conversation. Fork context is separate, as described in [instruction inheritance](#instruction-inheritance-and-primary-only-text).

Worker declares `acceptanceRole: writer`, default reads of `context.md` and `plan.md`, and default progress tracking. Its prompt requires code validation, minimal changes, tests and escalation of unapproved decisions. Delegate has no default reads or progress tracking and normally receives lightweight attestation rather than writer acceptance. Prefer worker for implementation and its validation evidence; use delegate for a bounded supporting result. Delegate can edit files when authorized, but its name does not imply a second implementation or orchestration layer. Its local description removes the builtin's now-inapplicable claim that it inherits the parent model; the prompt body remains unchanged.

### Independent second opinion

[`second-opinion`](../agent/agents/second-opinion.md) is a custom advisory inspector, not an additional implementation agent or an automatic replacement for another specialist role. Its prompt applies evidence and decision discipline to questions outside software as well as technical work. It tests the strongest supported case and material challenge, compares relevant options against the same constraints, and identifies what the parent must verify. Agreement is legitimate; producing objections is not a success metric.

The [primary profile](../agent/APPEND_SYSTEM.md#independent-second-opinion) owns invocation conditions, required companion launches and parent verification. The [consultation policy decision](agents-md/second-opinion.md) records the operator's goal of more selective use, the positive task-based conditions, changes to the companion list, and the alternatives examined with Fable. Keep the operative rules in the primary profile rather than duplicating them here. This is prompt policy, not a scheduler hook or a guarantee of model compliance; [project APPEND replacement and fork limits](agents-md/instruction-layers.md#project-append-replacement) remain.

The role uses fresh context, retained shared instructions and no ambient skill inheritance. Its selected catalog contains `codebase-design` and `ck-repowise`. The latter supplies activity-selected cases rather than separately assigned vendor workflows. Bodies load only for matching tasks; unrelated questions continue to use its general advisory method. The parent supplies the question, approved decisions, constraints, evidence anchors and current rationale; fresh context does not reconstruct omitted history. Its explicit tools allow AFT-backed file/structural inspection, Magic Context retrieval and own-session reduction, web research/source inspection, the common MCP gateway and supervisor questions, without shell, file-edit or delegation tools. MCP access does not authorize mutating services or index creation/updates. `acceptanceRole: read-only` declares acceptance behavior; the tool allowlist supplies the capability boundary. Neither is an operating-system sandbox, and framework artifacts or web caches can still be written by the runtime. Return findings in the final response for managed persistence rather than granting a write tool for reports.

The role-specific operational configuration is owned by `subagents.agentOverrides.second-opinion` in [`agent/settings.json`](../agent/settings.json): model/thinking, advertisement, acceptance role, prompt mode, project/global/skill inheritance, default context, selected skills, base provider and tools. The common MCP provider is inherited from `subagents.defaultSubagentOnlyExtensions`. These fields are not duplicated in the Markdown definition; that file supplies only its name, description and prompt body. The custom role uses the same native settings-override mechanism as the builtin roles.

`github-copilot/mai-code-2-flash` is an alternative to `opencode-go/deepseek-v4.1-flash` when provider limits make switching useful. To switch, change `subagents.agentOverrides.second-opinion.model` in `agent/settings.json` and keep `thinking: "high"`. Both choices keep the same role and [Web tool permissions](#deepseek-exception-for-second-opinion).

Ordinary launches use the role's configured model and effort, independent of the active parent provider. The primary consultation instructions specify neither. The [2026-11-13 decision](model-decisions.md#2026-11-13--high-thinking-for-second-opinions) records why the role uses `high` rather than `max`. Without the model/thinking override, the custom definition follows applicable defaults; a supported explicit launch or project override can also change the selection. No automatic fallback or recursive consultation chain is configured.

`advertise: false` avoids an extra parent-prompt name/description entry because the primary APPEND already explicitly names the role and governs its use. This affects only automatic prompt discovery: native catalog lookup and explicit launches, the role's instructions/tools, and the primary's consultation duties are unchanged. Sessions whose project APPEND omits the policy also lack this automatic reminder of the role; advertisement itself would not restore the missing rules.

### Operator-authorized consultant

[`consultant`](../agent/agents/consultant.md) is a custom native advisory role for difficult questions and continuing discussion, not an external Claude Code process. The [primary policy](../agent/APPEND_SYSTEM.md#consultant) owns authorization and selective use; the [policy guide](agents-md/consultant.md) explains session/task grants, revocation, rationale and alternatives. Configuration approval alone does not authorize an invocation.

`subagents.agentOverrides.consultant` owns all operational fields. The Markdown definition supplies only name, description and advisory prompt, as with `second-opinion`.

| Selection | Effect, rationale and omission behavior |
| --- | --- |
| `model: "anthropic/claude-sonnet-5-5"`, `thinking: "medium"` | Pins the operator-selected provider/model and default effort independently of the parent. Without these fields the custom definition has no pin and follows native defaults. Supported launch/project overrides remain possible, not independently authorized. |
| `defaultContext: "fresh"`, `systemPromptMode: "replace"` | Starts a new consultation from the supplied evidence and role prompt rather than copying the parent's conversation. Replace is also the native default. Fresh is an initial-context preference, not an instruction to erase a resumed transcript. |
| Project/global inheritance enabled; ambient skill inheritance disabled | Retains shared rules and the selected advisory skill catalog without importing every parent skill. Both context flags are explicit for this custom role. |
| `acceptanceRole: "read-only"` and Base + Diff + Web + MCP | Matches second-opinion's tool permissions. The four Web tools are active from the first request under the [Sonnet/CortexKit exception](#sonnetcortexkit-exception-for-consultant). Neither role receives shell, file-writing, shared-memory-writing or nested-delegation tools. The acceptance label alone does not restrict tools. Findings return through the response for runtime persistence. |
| `advertise: false` | Keeps this opt-in resource out of the extra parent-prompt agent catalog; the primary instruction names it and native discovery can still find it. False is also the native default. Advertisement is not a launch guard. |
| AFT, Magic Context, Web and Anthropic provider in `extensions` | Preserves the mandatory baseline while explicitly loading the installed subscription provider in isolated background children. The MCP adapter remains inherited through the separate shared child-only default. |

The additional provider entry point is `~/.pi/agent/npm/node_modules/@cortexkit/pi-anthropic-auth/dist/index.js`. Its installed implementation registers `anthropic`, its model catalog, native account access and streaming path. A role's explicit extension list disables ambient discovery; the parent's package declaration or a qualified model name alone does not load this provider into an isolated background child. This selection reuses the existing provider and account configuration; it does not install another authentication mechanism or prove that an account can currently serve a request. Revisit the [Web loader exception](#sonnetcortexkit-exception-for-consultant) if the effective model or provider changes.

No role-specific `interactive`, `memory`, timeout, keepalive or permanent enable/disable mechanism is configured. `interactive` is compatibility metadata, not an enforced mode; role `memory` is a separate notes feature. Native timeouts bound each execution rather than idle time between consultations. The parent's existing async-by-default launch policy is sufficient.

#### Continuing a consultation

Native `resume` opens the retained child `.jsonl` and appends a new exchange. It starts a new execution, not a permanently live process, while retaining the recorded agent/model/thinking/tool contract. Initial `defaultContext: "fresh"` does not reset it. A resumed child does not silently adopt newly edited role settings; a different model/thinking selection requires a fresh consultation.

```javascript
// Initial call, only inside an operator-authorized scope.
subagent({ agent: "consultant", task: "<bounded question and evidence>", async: true })

// After completion, continue the same consultation.
subagent({
  action: "resume",
  id: "<latest returned run ID>",
  message: "<new facts, superseded premises, and follow-up question>"
})
```

Each resume returns a new run ID; it becomes the continuation target. For a still-running child, use `steer` instead. A direct run may be absent from `children.list`, which lists retained workflow children rather than every direct launch. Known direct IDs can be inspected with `status`; `resume` performs the authoritative eligibility check. Report missing history or refused continuation rather than presenting a fresh fallback as the same conversation.

Normal completion leaves the conversation available for later continuation without consuming a live execution timeout during the pause. `stop` is terminal, not a way to park the consultant; stopped runs are not resumable. Revoking permission for an active run can therefore end its future resumability, while retained completed history does not itself grant permission for another call.

Continuation depends on the owning parent-session identity, retained transcript, recovery metadata and eligible run state. Reopening the same saved parent session preserves its identity; a process restart alone is not an ownership change. The native cleanup policy has a 90-day retention window for resumable records; other protection rules can keep them longer, while supporting files under the default temporary root can disappear sooner. Neither a transcript alone nor a saved report guarantees revival, and this configuration does not relocate storage or change cleanup policy.

The restored model context remains subject to normal context/compaction behavior. Reuse preserves conversational continuity, not guaranteed cache hits, smaller requests or reduced subscription consumption. The parent supplies changes since the last exchange; the consultant's prompt requires current evidence where file/source state matters.

### Worker, delegate and reviewer settings

Worker and delegate use explicit model pins independently of the [shared main defaults](settings.md#default-model-and-thinking). Reviewer retains inherited model selection and fixed max thinking. Effort is chosen in settings, not recalculated relative to the parent at every launch.

Merge-only fragment for `subagents.agentOverrides` in `~/.pi/agent/settings.json`; preserve all other role fields and lists:

```json
{
  "subagents": {
    "agentOverrides": {
      "worker": { "model": "openai-codex/gpt-6-luna", "thinking": "max" },
      "delegate": {
        "description": "Lightweight general executor for bounded tasks with no default reads",
        "model": "openai-codex/gpt-6-luna",
        "thinking": "max"
      },
      "reviewer": { "model": "inherit", "thinking": "max" }
    }
  }
}
```

- **Worker and delegate:** pin Luna/max. They remain on that model and effort when the parent switches to Astra or Claude; they do not inherit either the parent's model or its thinking.
- **Reviewer:** inherit the active parent model; set fixed max for routine independent review. Under the selected main baseline this is Sol 6.2/max. Existing parents still using Sol 6.1 continue to pass that active model to reviewer until explicitly switched. Preserve the exceptional Astra/high launch policy above and check effort support when changing the parent provider.
- **Exceptions:** for a task needing stronger analysis, choose an explicit per-launch model/effort such as `openai-codex/gpt-6.2-sol:xhigh`. Native pi-subagents gives that override precedence over the role default. This is deliberate assignment, not automatic retry or model fallback after a failure.
- **Omission behavior:** without the worker model override, the builtin inherits the parent model; without its thinking override, the builtin uses high. Delegate has no builtin model or thinking pin and falls back to the applicable defaults. Removing its description override restores the builtin's inheritance wording. Explicit local pins avoid relying on these fallbacks.

These executor/reviewer settings introduce no dynamic thinking inheritance, automatic downshift, routing plugin or new fresh/fork policy. `thinking: false` removes the role field rather than selecting a fixed effort. When changing task boundaries, models or providers, follow the [refresh workflow](model-selection.md#refresh-workflow) and review affected efforts together.

### Effective thinking support

Pi labels are not always distinct provider efforts. In the Pi 1.5.2 cached Codex metadata inspected 2026-11-18, Sol 6.2 and Astra 6.2 map `minimal` and `low` to provider `low`, while `off` is unsupported. The native clamp chooses the first supported level for such an off request, so it does not disable reasoning. Their `high`, `xhigh` and `max` mappings are distinct and retain the selected efforts without clamping. Luna 6 still supports its selected low/max profiles. This establishes client mapping, not measured server-side computation or equal depth across model generations.

`xhigh` and `max` are distinct. Codex Ultra is a product orchestration mode, not a Pi effort label. Native `fast` requests priority service and is not an effort setting. These are client-setting semantics; provider capabilities are recorded separately in the dated report.

### Delegation and context economy

- Delegate only for a concrete benefit: independent verification, specialization, bounded parallelism, isolation or substantial parent-context compression. Available roles do not imply a pipeline through every role. The explicit second-opinion consultation policy remains controlling.
- Outside mandatory consultation conditions, keep quick targeted work or tightly interdependent phases in the parent when packet reconstruction, handoff and review exceed the benefit. Parallelism can reduce elapsed time without reducing total consumption.
- Supply outcome, authority, exact target/cwd, relevant decisions and evidence anchors, acceptance/checks, output and stop/escalation rules. Do not copy a transcript when a sufficient packet exists. Fresh does not mean dropping operator/project constraints; fork is justified when history is evidence.
- Return conclusions **and navigable evidence**: paths/ranges or URLs/passages, version/date, checks actually performed and limits. Compress bulk logs/search results, not proof. Reuse a scout's map rather than rediscovering everything; independently inspect consequential seams before accepting a change.
- Parallelize independent reads; keep mutation ownership explicit and isolate justified concurrent writers. Children remain leaf roles under this local configuration.
- Avoid redundant watchdog reviews, fast service tiers, provider-wide searches and broad extension/skill loading by default. Maximum effort is selected for the bounded Luna executors and routine reviewer under their recorded decisions, not as a default for every role; other uses need a concrete benefit. The additional DeepSeek opinion uses high under its separate thinking decision. Do not disable required global instructions or remove relevant capabilities just to shorten context.

## Skills

### Selection policy

All configured native roles have explicit `skills` arrays and `inheritSkills: false` in `subagents.agentOverrides` in [`agent/settings.json`](../agent/settings.json), including the custom `second-opinion` and `consultant` roles.

- The array selects the role's normal skill catalog; an empty array intentionally selects none.
- Disabling inheritance prevents unrelated current or future ambient skills from entering that catalog. Both fields are explicit so the policy does not depend on future builtin defaults.
- Selection advertises a skill's name, description, and file location. The agent reads its body when the task matches; selection does not preload every body or require using every selected skill on every task.
- Skills provide instructions, not tools or authority. Existing role and task boundaries remain controlling, including read-only review and escalation to the parent.
- The main agent uses [native skill discovery](settings.md#main-skill-discovery). Global/repository instruction inheritance is unchanged.

Newly installed skills need an assignment decision before becoming defaults. Adding instructions to an already selected skill does not require assigning its unchanged name again.

### Selected skill catalog

The personal `ck-testing`, `ck-task-workflow` and `ck-repowise` skills live at `~/.pi/agent/skills/<name>/SKILL.md`, Pi's user-level skill directory. The other user skills live at `~/.agents/skills/<name>/SKILL.md`. Package skills live at `~/.pi/agent/npm/node_modules/<package>/skills/<name>/SKILL.md`: `pi-subagents` supplies delegation and council skills; `pi-intercom` supplies its coordination skill.

| Skill | Source / automatic visibility in the main agent | Purpose |
| --- | --- | --- |
| `agent-browser` | User / visible | Browser and Electron interaction, browser-based testing, exploratory QA. It loads current workflow instructions through the installed CLI. |
| `grill-for-unknowns` | User / visible | Evidence-grounded critique of plans, assumptions, material unknowns, and acceptance criteria. |
| `handoff` | User / manual only | Summarize the current conversation for continuation by another session. |
| `codebase-design` | User / visible | Module/interface design, responsibility placement, testability and comparison of alternative interfaces. |
| `ck-task-workflow` | Pi user / visible | Primary-agent coordination of task plans, roadmaps, overall progress and working-file placement. |
| `ck-testing` | Pi user / visible | Design, write, modify, or review tests and validation checks. |
| `ck-repowise` | Pi user / visible | Sole Repowise procedure owner: activity-selected cases, supported selective analysis, gateway/target handling and conditional safe index preparation; [skill instructions](../agent/skills/ck-repowise/SKILL.md) own the procedures. |
| `writing-for-agents` | User / visible | Design agent-facing instructions, including skills and `AGENTS.md` / `CLAUDE.md`. |
| `council-mode` | Package / visible | Parent-supervised advisor selection, bounded discussion, and decision synthesis. |
| `pi-subagents` | Package / visible | Parent-side delegation, orchestration, and subagent management. |
| `pi-intercom` | Package / visible | Coordinate with other local Pi sessions on the same or related codebases. |

`handoff` sets `disable-model-invocation: true`, which hides it from automatic selection. `agent-browser` has a different field, `hidden: true`; Pi's native loader still exposes it to the model. Catalog visibility follows native loader semantics rather than an assumption based on that field name.

### Upstream Repowise skills

`codebase-exploration`, `architectural-decisions`, `pre-modification-check`, `change-review`, `code-health` and `dead-code-cleanup` remain installed unchanged from `repowise-dev/repowise`, `plugins/codex/skills/<name>/SKILL.md`, into `~/.agents/skills/<name>/SKILL.md`. They are standard Pi-compatible files, not an installed Codex plugin. The existing skills manager records their source, `main` ref, paths and folder hashes in `~/.local/state/skills/.skill-lock.json`; this tracks a branch, not an immutable commit pin.

They are excluded from [normal main discovery](settings.md#main-skill-discovery) and omitted from all default native role catalogs. They remain maintenance references, not competing runtime instructions or fallback workflows. The [ck-repowise README](../agent/skills/ck-repowise/README.md#upstream-methods-retained-control-flow-replaced) maps retained methods and explains the replaced control flow. Use the existing manager for vendor updates, then reconcile relevant local methods/support against changed sources; do not edit vendor files or automatically reimport their query chains.

### Default assignments by role

Every row below has `inheritSkills: false` and gives the role's **complete** normal catalog. The shared ck-repowise cases are reached through that one selected skill; they do not need separate role assignments and do not expand the assignment or role authority.

| Agent | Selected skills | Why these skills fit |
| --- | --- | --- |
| `worker` | `agent-browser`, `ck-testing`, `writing-for-agents`, `codebase-design`, `ck-repowise` | Implements authorized tasks, including local module/interface choices, browser/UI verification, tests and agent-facing documentation. Unapproved architecture or public-contract decisions still go to the parent. |
| `delegate` | `agent-browser`, `ck-testing`, `writing-for-agents`, `codebase-design`, `ck-repowise` | Handles bounded work, including relevant local design choices. Catalog availability does not make it an architect or orchestrator. |
| `reviewer` | `grill-for-unknowns`, `ck-testing`, `writing-for-agents`, `codebase-design`, `ck-repowise` | Evaluates proposed interfaces, responsibility placement, plans, tests and agent-facing instructions within the named review target. Its no-shell/no-repository-edit contract remains. |
| `oracle` | `grill-for-unknowns`, `ck-testing`, `writing-for-agents`, `codebase-design`, `ck-repowise` | Challenges decisions and compares module/interface alternatives. Explicit selection supplies the skill in fresh launches as well as the normal fork-based context. It remains advisory and read-only. |
| `scout` | `ck-repowise` | Finds entry points, types, flow and constraints within its assignment; the exploration case selects any useful indexed evidence without making index readiness a prerequisite to basic navigation. |
| `second-opinion` | `codebase-design`, `ck-repowise` | Tests arguments and alternatives; design guidance and task-selected Repowise cases support technical questions without narrowing its general advisory remit. |
| `consultant` | `codebase-design`, `ck-repowise` | Uses the same advisory analysis catalog for difficult technical questions and follow-ups, without narrowing its general remit or granting execution authority. |
| `researcher` | `ck-repowise` | Researches questions using web/repository primary evidence; exploration and decision history help find implementations and explain their provenance. |
| `evidence-auditor` | `ck-repowise` | Checks consequential claims against primary sources; indexed context and rationale records help verify repository-specific assertions. |

The role's actual task/current action selects a case before the corresponding analysis. All cases are available through ck-repowise, but an inspection-only role still cannot execute edits, index preparation, finding mutations or decision acceptance. Implementation, review and investigation are not forced through the same sequence of queries.

For an exceptional testing-specific research/audit or instruction-design investigation, the parent can select `ck-testing` or `writing-for-agents` for that launch. A default omission is not a claim that a role can never benefit from that skill.

### Assignment boundaries and exclusions

**`ck-task-workflow` — primary-agent coordination, not a child default.** The [skill](../agent/skills/ck-task-workflow/SKILL.md) owns task/roadmap coordination; bounded child assignments do not transfer that ownership. The parent provides relevant context and working paths, while children return results and blockers through their existing channels. An undefined artifact destination is escalated to the parent; explicit and managed report destinations remain in use. All default catalogs omit the skill. Its read trigger is in the primary APPEND, not shared AGENTS; fresh native children bypass that operator profile. Catalog omission does not prevent direct file reads or remove instructions retained in a fork. Explicitly delegated workflow development/review may receive relevant instructions as task input rather than a permanent role default.

**`agent-browser` — execution roles only.** The installed CLI is reachable through `bash` for `worker` and `delegate`. `reviewer`, `researcher`, and `evidence-auditor` have no shell tool. `scout` restricts shell use to non-interactive inspection; `oracle` is an advisory, read-only analyst. They do not receive a default app-interaction workflow merely because browsing could be useful. Research/audit web-fetch tools remain available unchanged. CLI presence does not prove browser installation, authentication, or readiness for a particular target.

**`grill-for-unknowns` — plan/advisory review, not routine task expansion.** It is selected for `reviewer` and `oracle` because exposing consequential assumptions is part of their roles. Apply it when a planning/critique task warrants it, not as a mandatory interview for every diff. Its broader workflow does not authorize these roles to update `CONTEXT.md`, write ADRs, prototype, start children, or contact the human directly: findings and unresolved decisions go to the parent through their existing report/supervisor channel. Those role boundaries already exist in the builtin prompts. Execution roles should escalate gaps in an approved task rather than reopen the whole design process; source-reconnaissance and research/audit roles do not own that planning workflow.

**`ck-testing` and `writing-for-agents` — actors that construct or evaluate the relevant artifacts.** They serve the implementation and review/advisory roles listed above. Ordinary scouting, research, and source-claim auditing do not trigger them merely because the output is a Markdown report or the source mentions tests. `writing-for-agents` supplies useful design criteria for instruction review; its description is authoring-oriented, so catalog availability alone is not evidence that every review will load it automatically.

**`codebase-design` — implementation, review and advisory roles.** The main agent and the selected implementation/advisory children decide autonomously when actual work requires module/interface design, responsibility placement or testability analysis. The operator supplies the task, not a required skill invocation. Availability does not mandate redesign, merging modules, or applying every heuristic to every change. Existing architecture, testing and approval requirements remain controlling. The optional parallel alternative-design branch stays with the parent: selected children have no subagent-spawning permission.

**`ck-repowise` — shared scenario-first procedures.** All active native roles receive its metadata. The shared AGENTS.md loading rule controls entry; the current activity selects a case before deriving its analytical checks. Supported useful analysis is mandatory when the required evidence is missing, while a case can correctly require no query. AFT remains primary for current source. The primary prepares an index only for selected analysis that actually needs it, not before all analysis/delegation. A child requests missing CWD-specific verification or that preparation prerequisite through its supervisor channel, without gaining shell/write permission or asking the operator to approve index presence. Handoffs carry relevant evidence and freshness/coverage limits, not instructions to repeat the parent's query sequence. Each child's actual CWD controls eligibility. The [skill](../agent/skills/ck-repowise/SKILL.md) owns operation/support, model-call and safety details; its availability does not filter MCP tools, grant model use or require project MCP/editor setup. The six disabled external CLI profiles are unchanged.

**`pi-subagents`, `council-mode` and `pi-intercom` — parent coordination only.** No enabled child role has the `subagent` tool. An oracle can participate in a council without receiving instructions to run the council. Likewise, `delegate` is a leaf executor despite its name. The extension additionally filters the `pi-subagents` orchestration skill out of child discovery/resolution; `council-mode` is excluded here by the local assignment decision. `pi-intercom` coordinates related local sessions through the parent's intercom tool; none of these child allowlists grant that tool.

**`handoff` — manual session operation, not a child default.** It is deliberately hidden from automatic invocation. pi-subagents also omits such hidden skills from injected metadata even when explicitly resolved by name. It does not replace `scout`'s normal report or the extension's managed task-result handoff.

### How selection works and what it does not enforce

For these local native roles:

1. Agent discovery applies builtin definitions and settings overrides.
2. With no launch override, the role's `skills` array supplies the selected names.
3. Skill resolution finds their files; the effective child prompt includes their metadata and an instruction to read matching skills.
4. `inheritSkills: false` removes the ambient catalog, while the explicitly configured metadata remains.

A launch-level `skill` selection replaces the role's list for that launch; include the existing defaults when adding one temporarily. `skill: false` or an empty launch list disables the explicit selection for that launch. Do not confuse those launch options with a permanent settings edit. With ambient inheritance enabled, disabling the explicit selection alone would not hide the ambient catalog.

Names are not file pins: a project-local skill with the same selected name can take precedence. Inspect the resolved location when the intended policy matters. Missing named skills produce warnings rather than reliably stopping a run; validate resolution instead of treating the settings array as proof of availability.

These settings are not a filesystem sandbox or a history scrubber. An agent may still read a known file, and a fork can contain skill text from the parent's earlier conversation. Explicit launch/project overrides can change selection. Automatic skill reads and correct application remain model behavior, not mechanical enforcement.

The extension's agent-list output can also suggest specialized reviewer passes for frequently configured skills. Its default limit of three recommendations applies only to that advisory text: it neither limits the available skill catalogs nor automatically starts subagents.

## MCP access

All active native roles use the common proxy, obtaining tool descriptions on demand. The gateway reaches the enabled servers in the shared configuration; selected skills and MCP access are independent. The official adapter installation, Repowise registration, and shared settings are prerequisites described in [settings.md](settings.md#mcp-access); do not duplicate the server command or adapter-policy fragment in each role.

### Grants and provider loading

| Roles | Tool grant | Child provider |
| --- | --- | --- |
| `worker`, `delegate`, `reviewer`, `oracle`, `researcher`, `evidence-auditor`, `scout`, `second-opinion`, `consultant` | `mcp` | `~/.pi/agent/npm/node_modules/pi-mcp-adapter/index.ts` |

Each MCP-enabled role needs two independent pieces. Skill selection is separate and does not enable or disable the server:

| Setting | Effect | If missing |
| --- | --- | --- |
| Role `tools` includes `mcp` | Permits the proxy in the child's strict tool allowlist. | A loaded provider does not make the proxy callable by this role. |
| Shared `defaultSubagentOnlyExtensions` includes the adapter entry point | Supplies the provider to each child whose role has no explicit child-only list, in addition to its selected base providers. | The configured base/research provider lists do not load the adapter; requesting `mcp` then fails tool-availability preflight unless another explicit child provider supplies it. Installing the package for the parent alone is insufficient. |

Shared **addition** inside `subagents` in `~/.pi/agent/settings.json`:

```json
{
  "defaultSubagentOnlyExtensions": [
    "~/.pi/agent/npm/node_modules/pi-mcp-adapter/index.ts"
  ]
}
```

All active native roles inherit this list; the adapter path is not repeated in their overrides. Keep `mcp` in each role's existing `tools` allowlist alongside its AFT, Magic Context, web, and execution/inspection tools. This fragment is not a replacement for the complete `subagents` object. Use the installed package entry point, not a copied extension or a transient cache path.

The default also applies to newly discovered native roles without their own child-only list, but does not add names to an explicit `tools` allowlist. An explicit role `subagentOnlyExtensions` list replaces the shared list, including when empty; include the adapter there if the role still needs `mcp`. A project-level `defaultSubagentOnlyExtensions` replaces the user-level default, not individual entries. These are overridable loading defaults, not unconditional injection or task authorization.

### Selected file, shell and research tools

`agentOverrides.<role>.tools` is an explicit replacement allowlist, not a list of additions to the builtin role. All configured native roles, including the custom second-opinion and consultant roles, select their allowlists in settings. The following groups define the selected sets without repeating identical names for every role. They describe tool permissions, not permission to use every tool on every assignment.

| Group | Tools | Motivation |
| --- | --- | --- |
| Base | `read`, `grep`, `find`, `contact_supervisor`, `aft_search`, `aft_outline`, `aft_zoom`, `aft_callgraph`, `aft_inspect`, `aft_conflicts`, `ast_grep_search`, `ctx_search`, `ctx_expand`, `ctx_reduce` | File discovery and exact/structural inspection, retrieval/compression of relevant history, and escalation to the parent. Keep `grep` and `find` for their distinct capabilities; omit the redundant `ls` tool as explained in [file navigation choices](#file-navigation-choices). Context compression changes conversation state, not repository files. |
| Shell | `bash`, `bash_status`, `bash_watch`, `bash_write`, `bash_kill` | Run and control necessary commands, background jobs or PTYs. A role/task's read-only inspection limit still applies; a shell is not mechanically read-only. |
| Write | `write` | Create authorized files or an assigned report artifact. Scout/research report permission does not authorize edits to the investigated project. |
| Mutation | `edit`, `aft_import`, `aft_move`, `aft_delete`, `aft_safety`, `ast_grep_replace` | Implementation edits, imports, moves/deletions and structural rewrites, with recovery/checkpoints. Keep these source-mutation tools with execution roles. |
| Web | `web_search`, `fetch_content`, `get_search_content`, `source_check` | Find external sources, inspect originals/stored passages and audit claims. Available to oracle, research/audit roles and the general second-opinion/consultant advisors. |
| Web loader | `web_enable` | Permit deferred Web activation so unused Web definitions can stay out of the initial model context. Use alongside all four Web tools where deferred activation is supported. See the exceptions for [`second-opinion`](#deepseek-exception-for-second-opinion) and [`consultant`](#sonnetcortexkit-exception-for-consultant). The helper does not search or fetch. |
| Diff | `watchdog_diff` | Read staged/unstaged changes against HEAD captured at child launch, plus untracked file paths, without shell access. Committed ranges are unsupported. The native child runtime supplies this helper; it needs neither the full pi-subagents extension in the child nor automatic watchdog runs. |
| MCP | `mcp` | Lazy configured-server access under the [MCP boundary](#tool-exposure-and-authority), not direct/eager server schemas. |

| Role | Selected groups | Why this boundary |
| --- | --- | --- |
| `scout` | Base + Shell + Write + MCP | Code/file navigation, inspection commands, indexed context and builtin report output; no source-edit toolkit or web investigation. |
| `worker` | Base + Shell + Write + Mutation + MCP | Implement and validate authorized changes, including relevant artifact evidence. |
| `delegate` | Base + Shell + Write + Mutation + MCP | Complete bounded execution tasks without an arbitrary tool deficit; lightweight means task/depth scope, not inability to finish the task. |
| `reviewer` | Base + Diff + MCP | Independent source/diff/artifact inspection without shell or file mutation. Parent/worker executes required checks. |
| `oracle` | Base + Shell + Web + Web loader + MCP | Read-only diagnosis can need inspection commands and external primary evidence, but no direct source-write toolkit or autonomous implementation. |
| `researcher` | Base + Write + Web + Web loader + MCP | Repository/external/artifact research and assigned report output, without shell or source mutation. |
| `evidence-auditor` | Base + Web + Web loader + MCP | Independently inspect claim evidence; return findings through managed output rather than grant file writing for its own sake. |
| `second-opinion` | Base + Diff + Web + MCP | The same source/context and Git-diff inspection as reviewer, plus web and the common gateway. Web tools are active from the first request under the [DeepSeek exception](#deepseek-exception-for-second-opinion). No shell, file mutation, shared-memory writing or mutating services. |
| `consultant` | Base + Diff + Web + MCP | The same inspection boundary as second-opinion for operator-authorized expert advice and follow-ups, with its separate model/provider and grant policy. |

A missing tool/provider produces a capability gap; a name in an allowlist is not proof of registration. Omitting `tools` would fall back to the role/runtime's selection instead of preserving this explicit boundary. Keep AFT/MC in `defaultExtensions` and every explicit role `extensions` list; retain Base in every role's tools. The web-enabled roles add their web provider to that baseline. Keep the adapter in the shared `defaultSubagentOnlyExtensions` with `mcp` in each role's tool allowlist, as described above. No child receives `subagent`, `todowrite`, `ctx_memory` or `ctx_note`: orchestration, task ownership and durable project decisions stay with the parent in this configuration.

### File navigation choices

All configured native roles deliberately retain `grep` and `find` but omit `ls` from their explicit tool allowlists:

1. **Keep `grep` for capabilities beyond `aft_search`.** With the selected AFT overrides, the tool named `grep` is AFT-backed, not Pi's original implementation. Its file/directory scope and `include` glob filter provide controls absent from `aft_search`; removing the name would also remove AFT's replacement. The unprefixed name does not imply a non-AFT backend.
2. **Keep `find` for file discovery without `bash`.** It provides a dedicated file-path glob search, including to roles without shell access. The stock scout prompt explicitly says to use `find` for path discovery. Retaining the tool keeps that instruction usable without copying or changing the upstream prompt; removing it could encourage a fallback to shell `find` instead of the intended tool.
3. **Omit `ls` because AFT `read` already lists directories.** AFT is required for every native role. Its `read` provides the same basic directory information as Pi's `ls`: entry names and directory markers. Pi's tool does not add file sizes or modification dates. Limits and pagination differ, so the outputs need not be byte-identical, but a separate `ls` definition adds no distinct metadata capability here.

These choices depend on retaining the selected AFT `read` and `grep` overrides, not merely installing the extension. They change tool availability, not the operating-system commands available to roles that have `bash`.

### Web permissions and deferred activation

All five Web-enabled roles allow `web_search`, `fetch_content`, `get_search_content` and `source_check`. `oracle`, `researcher` and `evidence-auditor` also allow `web_enable`. The [`second-opinion`](#deepseek-exception-for-second-opinion) and [Sonnet/CortexKit-backed `consultant`](#sonnetcortexkit-exception-for-consultant) omit it. These are entries in each role's complete `tools` list, not a replacement for Base or its other grants. The `pi-web-access` provider must also be loaded.

Two separate mechanisms explain the apparently redundant list:

1. **The four operational names grant permission.** Pi filters tools against the role's explicit allowlist before the activation helper can see them. `web_enable` only activates already registered tools: it cannot restore names omitted from `tools`, load a missing provider or enable a disabled capability. Allowing only `web_enable` therefore fails with `Cannot enable unavailable tools`, rather than granting Web access.
2. **The helper permits context savings through deferred activation.** When that activation mode is selected, a fresh session initially exposes only the compact `web_enable` definition, not the four operational definitions and parameter schemas. A task that never needs Web can avoid carrying those definitions. Calling the helper adds the four tools on the next model request; their definitions then enter the context. The full permission list does not itself force every permitted tool to remain model-visible.

With the four Web capabilities configured and direct tool exposure, `pi-web-access` selects tools as follows in a fresh session when it would otherwise use deferred activation. This table describes the extension's selection, not whether the child runner accepts that selection:

| Web-related names allowed in `tools` | Result |
| --- | --- |
| All four operational names **plus** `web_enable` | Initially only the helper is model-visible; calling it activates the four tools. |
| Only `web_enable` | The four tools are filtered out; the helper cannot activate them and returns an error. |
| All four operational names **without** `web_enable` | The four tools are available immediately. The extension skips deferred setup when the helper is absent, so even unused Web definitions occupy initial context. |

**The helper is necessary for this deferred path, but allowing it does not force every model into that path.** In the extension's `web-search.json`, `toolActivation` controls selection:

- `"auto"` (the extension default) defers on a fresh session only when Pi's model metadata says tools can be added without replacing the cached conversation prefix. Otherwise the four tools are exposed immediately to avoid that cache disruption.
- `"dynamic"` forces deferred activation on fresh sessions, including models where subsequent activation may invalidate the prompt cache.
- `"eager"` keeps the operational tools available immediately and does not register the helper. Roles that list `web_enable` require it to be registered, so changing only the global mode creates a missing-tool diagnostic for those roles. This differs from `"auto"` choosing immediate exposure for a model without the required compatibility: when allowed, the helper remains registered but inactive.

In the Pi 1.5.2 cached model catalog inspected 2026-11-18, `openai-codex/gpt-6.2-astra` retains `supportsAdditionalTools`, `supportsToolSearch` and `supportsMidConvoSystemMessages`, so `pi-web-access` can select deferred exposure in `"auto"` for `oracle`, `researcher` and `evidence-auditor`. Recheck effective model metadata after catalog or provider updates. If Web is needed immediately, deferred activation adds a tool call and then the four definitions anyway; reduced total usage or cost is not guaranteed.

#### DeepSeek exception for second-opinion

`subagents.agentOverrides.second-opinion.tools` deliberately omits `web_enable` for both DeepSeek V4.1 Flash and the MAI Code 2 Flash alternative. The Pi 1.5.2 catalog does not advertise the capabilities that `pi-web-access` 0.48.0 needs to defer tool activation in `"auto"` for either model. Without the helper in the allowlist, the extension skips its activation setup and keeps all four Web tools active from the first request. The Web provider and the other roles' grants stay unchanged; this is not a global switch to `"eager"`.

This also avoids the failure in pi-subagents 0.89.0: its request check treats an allowed, registered but inactive `web_enable` as if it had been removed by another extension and aborts the child before the first model request ([upstream issue #3296](https://github.com/nicobailon/pi-subagents/issues/3296)). The role exception does not fix the check itself.

#### Sonnet/CortexKit exception for consultant

`subagents.agentOverrides.consultant.tools` deliberately omits `web_enable` for `anthropic/claude-sonnet-5-5` through `@cortexkit/pi-anthropic-auth` 2.4.10. The provider registers this model with the API ID `cortexkit-anthropic-messages`. In `pi-web-access` 0.48.0, the `"auto"` compatibility check recognizes the standard `anthropic-messages` API but not this custom ID, so it exposes all four operational tools immediately and leaves the registered loader inactive when allowed. This is a limitation of activation detection for the configured provider, not a claim that Claude Sonnet or Anthropic in general cannot add tools mid-conversation.

The same pi-subagents 0.89.0 check ([#3296](https://github.com/nicobailon/pi-subagents/issues/3296)) rejected `consultant` before the first model request: the transcript listed all four Web operations but not `web_enable`. Omitting just the loader keeps those tools active from the first request under direct exposure. The Anthropic and Web providers, consultation authorization, other tool grants, and global activation mode are unchanged.

#### Restoring the Web loader after a model or provider change

**Restore `web_enable` alongside all four operational names when moving either role to a model/provider combination that `pi-web-access` supports for deferred activation.** Check the effective API ID and compatibility metadata, and confirm that the installed pi-subagents version accepts intentionally inactive tools before restoring it. On 0.89.0 the same check can reject the four operational tools while they are hidden until activation. If the replacement still does not qualify, explicitly decide whether to keep immediate exposure; do not carry either exception forward by default.

Recorded selections in warm, resumed or forked conversations can preserve previously exposed tools. Apply role changes to newly launched children and use fresh-session checks when verifying initial exposure; already-running children do not adopt new grants retroactively. Tool registration, model-visible activation and successful Internet search/download are separate checks.

### Tool exposure and authority

No role receives `codemode`, script tools, server-specific proxies or direct MCP tool selectors. The [parent's built-in disable setting](settings.md#pi-package-and-built-ins) does not replace the child allowlists: pi-subagents can register Pi's codemode factory in a child if that tool is explicitly permitted.

Server-specific `mcp:<server>` selectors are intentionally not used: they select direct MCP tools and can expand a whole server eagerly, regardless of native deferred exposure. The common proxy provides full on-demand discovery without `tool_search` or a script interface. Use its [parameter-discovery contract](settings.md#parameter-discovery-and-large-responses), not skill examples as a substitute for missing parameter information.

The common grant reaches **all enabled, permitted servers** in the adapter's merged configuration, including later additions. There is no per-role server allowlist. Adding a server changes every MCP-enabled role's capabilities and warrants reviewing the grants; this is the accepted shared-access trade-off, not an accidental isolation guarantee. Shared filters and approval behavior are described in [settings.md](settings.md#access-and-approval-boundaries).

Capability is not task authorization. Read-only reviewers/auditors must avoid mutations, but their file-tool restrictions do not mechanically prevent modifying operations behind MCP. Neither the role profile nor skill selection is a filesystem sandbox.

### Session state and handoffs

Each child has its own MCP connections, separate from the parent and other children. The Repowise index is repository-local data, not a shared live connection. Index preparation in a child does not refresh the parent's connection; the [skill](../agent/skills/ck-repowise/SKILL.md) owns the preparation and reconnect procedure. A resumed conversation is not proof that an earlier server process still exists.

## Maintaining and validating the configuration

The [Pi configuration maintenance policy](settings.md#configuration-maintenance-policy) applies to these role settings as well: do not create or run configuration tests.

### Skill and role changes

1. Read the actual skill instructions and effective role prompts/tools. Distinguish a reusable method from a workflow that assumes mutation, interviewing, orchestration, or unavailable tools.
2. Change only the relevant role settings, preserving explicit skill selection, the mandatory AFT/MC inspection baseline and unrelated capabilities. Use project/launch overrides for task-specific additions rather than expanding every role's defaults.
3. Update the inventory, affected role rows, and rationale here. Replace competing setup descriptions elsewhere with links.
4. Inspect the affected settings, provider entry points and relevant source contracts directly. Distinguish configured permissions from runtime registration and exposure; report unknown runtime behavior rather than creating test scenarios.
5. Independently review substantive assignment changes and verify each finding against the current files and approved role boundaries.

### MCP configuration and package changes

- Inspect the selected provider paths and tool allowlists for affected roles, including the custom roles when shared loading changes affect them. All active native roles need the `mcp` proxy and its adapter provider; skill selection does not revoke this grant. Preserve the exclusions for `codemode`, script tools and direct server-specific selectors.
- Keep the parent package and all child-provider entry points on the same installed adapter package. If its installation location changes, update every affected path.
- Follow the [shared MCP maintenance guidance](settings.md#applying-and-validating-changes) without adding test scenarios.

### Applying changes and document boundaries

Reload or restart each affected Pi instance after important active/background work has finished. `/reload` replaces extension runtimes; already-running children do not retroactively adopt new settings.

## Sources

Installed files used for this configuration:

- Skill/MCP contracts: Pi 1.2.0 `docs/skills.md` and `docs/settings.md`, under that release's `@earendil-works/pi-coding-agent/` directory.
- Model/effort semantics: Pi 1.3.0 `README.md`, `docs/models.md`, `docs/settings.md`, and `dist/core/{model-resolver,sdk,agent-session}.js` under `~/.pi/agent/install/releases/1.3.0/node_modules/@earendil-works/pi-coding-agent/`; bundled `@earendil-works/pi-ai/dist/{models.js,providers/openai-codex.js,providers/data/openai-codex.json}`. These sources establish configuration semantics; the [dated assessment's source ledger](models-2026-11-18.md#sources) covers model evidence only.
- pi-subagents: `docs/{agents,configuration,models,observability}.md`, `agents/*.md`, and `skills/pi-subagents/references/prompting-and-roles.md` under `~/.pi/agent/npm/node_modules/pi-subagents/` (role overrides, model/effort policy, extension loading, prompt assembly, and skills). The upstream task-based tiers supply the selected routing framework; concrete role models and exceptions follow the operator-approved decisions, not the example IDs alone.
- Current profile resolution: Pi 1.4.0 `docs/settings.md`, `dist/core/settings-manager.js`, and bundled `@earendil-works/pi-ai/dist/{models.js,providers/data/openai-codex.json,providers/data/opencode-go.json}`; pi-subagents 0.84.0 `docs/models.md`, `src/agents/agents.js`, `src/shared/model-info.js`, and `src/runs/shared/model-resolution.js`. These establish fixed executor pins, inherited reviewer selection, per-launch exceptions, supported Luna and DeepSeek max, and distinct Sol xhigh/max mappings.
- Skill/ownership contracts: Pi 1.5.0 `docs/{settings,skills}.md` and `dist/core/{package-manager,skills}.js` under `~/.pi/agent/install/releases/1.5.0/node_modules/@earendil-works/pi-coding-agent/`; pi-subagents 0.87.0 `src/agents/{agents,skills,proactive-skills}.js`, `src/runs/shared/{child-tool-plan,child-launch-plan,effective-system-prompt,subagent-prompt-runtime}.js`, relative to its installed package root. These establish custom-role overrides and advisory recommendations. The Repowise replacement's exact main exclusions, independent child-name resolution and metadata injection additionally use Pi 1.5.2 `docs/{skills,settings,packages}.md`, `dist/core/{package-manager,resource-loader,skills}.js` and pi-subagents 0.88.1 `src/agents/skills.js`; see the [skill maintenance guide](../agent/skills/ck-repowise/README.md).
- File navigation choices: AFT 0.64.0 `README.md` (Hoisted built-in overrides) and `dist/index.js` (read/grep registrations and search parameters), plus Pi 1.5.2 `dist/core/tools/{find,ls}.js`. These establish the AFT-backed unprefixed names, separate search controls, glob discovery and directory-listing output.
- Web allowlist and activation semantics: Pi 1.5.2 `dist/core/{sdk,agent-session}.js`; pi-subagents 0.88.1 `src/runs/shared/child-session.js`; pi-web-access 0.47.0 `README.md` (Tool activation), `index.ts` and `tool-activation.ts`, under their installed package roots. These establish strict permission filtering, the no-loader eager path, model-dependent auto activation and recorded-session selection. For the two role exceptions, see pi-web-access 0.48.0 `tool-activation.ts` (`addsToolsWithoutCheckpoint`, `selectFromSession`) and pi-subagents 0.89.0 `src/runs/shared/subagent-prompt-runtime.js` (`registerDeclaredToolCheck`). The CortexKit API ID is set by the provider entry point below.
- Consultant continuation: pi-subagents 0.88.1 `docs/tool-reference.md` (Retained children, resume, steer, stop), `src/runs/shared/child-session.js`, `src/runs/foreground/subagent-executor.js` and `src/runs/background/async-retention.js`; Pi 1.5.2 `dist/core/session-manager.js`. Provider selection: `@cortexkit/pi-anthropic-auth` 2.4.10 `package.json` and `dist/index.js` (Anthropic registration and model metadata). Paths are relative to the installed package roots; source contracts do not prove successful authentication, model requests or future retention.
- Skill contents at the inventory locations above; [testing rationale](../agent/skills/ck-testing/README.md) and [task-workflow rationale](../agent/skills/ck-task-workflow/README.md).
- Shared adapter behavior and upstream references: [settings.md](settings.md#references).

Recheck relevant installed behavior after an extension/Pi update rather than assuming this version's private helper APIs remain stable.
