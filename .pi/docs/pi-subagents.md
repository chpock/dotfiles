# pi-subagents configuration

This guide describes the selected pi-subagents configuration and its rationale: models/thinking, role boundaries, child providers, tools, skills and MCP/REA access. It is a configuration reference, not a change log or deployment audit. Shared Pi defaults and MCP settings belong in [settings.md](settings.md); see [CONTEXT.md](CONTEXT.md) for document boundaries.

Model/thinking semantics are based on **Pi 1.3.0** and **pi-subagents 0.78.0**; skill/MCP contracts retain their earlier Pi 1.2.0 basis unless stated otherwise. The instruction-inheritance and custom second-opinion sections additionally use Pi 1.4.0 and pi-subagents 0.84.0. MCP provider examples specify the official npm `pi-mcp-adapter` setup. These are source-contract versions, not deployment status.

**Shared baseline:** [main model and thinking](settings.md#default-model-and-thinking). **Model evidence:** [2026-10-17 assessment](models-2026-10-17.md). **When reviewing models or preparing another assessment:** use [model-selection.md](model-selection.md), which owns capability profiles, research rules and the report format.

## Configuration ownership and scope

| Location | Responsibility |
| --- | --- |
| [`~/.pi/agent/settings.json`](../agent/settings.json), `packages` | Loads `npm:pi-subagents` in the parent. |
| [`~/.pi/agent/extensions/subagent/config.json`](../agent/extensions/subagent/config.json) | Owns extension display preferences and schedule availability, separately from Pi settings and role overrides. |
| Same file, `subagents.defaultExtensions` | Sets the base child-provider list for roles without their own `extensions`. |
| Same file, `subagents.agentOverrides` | Owns local role differences: models/thinking, context inheritance, tools, extensions, and skills. |
| `~/.pi/agent/npm/node_modules/pi-subagents/agents/` | Upstream builtin prompts and defaults; do not copy them merely to change individual settings. |
| [`~/.pi/agent/agents/second-opinion.md`](../agent/agents/second-opinion.md) | Custom second-opinion prompt, inspection tools, explicit web provider and fresh-context defaults; its model/thinking stays in settings. |
| Each selected skill's `SKILL.md` | Owns that skill's instructions; do not duplicate them here or in role prompts. |

Scope is the seven enabled builtin native roles and the custom native `second-opinion` role listed below. The six external CLI profiles (`codex-exec`, `claude-code`, `cursor-agent`, and their `-writer` variants) have `disabled: true` because the operator does not use the Codex, Claude Code or Cursor agent harnesses. Omitting those overrides would allow their builtin profiles to be discovered, subject to runner availability; disabling a profile does not uninstall its CLI. `advisor` is an alias for `oracle`, not a separate configured role.

These are user-level defaults across projects. Project definitions/settings and supported launch overrides can change the effective selection; inspect the resolved role rather than treating this guide as an immutable policy.

### Shared child configuration

- `subagents.defaultExtensions` loads AFT and Magic Context from their installed package entry points. This explicit list avoids ambient parent-extension discovery; it is not an additive list of every parent package.
- `researcher` and `evidence-auditor` have explicit `extensions` lists containing the same two providers plus `pi-web-access`. Omitting those role lists would fall back to the base list, which does not supply their required web tools.
- All eight roles retain project and global instructions through `inheritProjectContext: true` and `inheritGlobalContext: true`. The builtin global flag is set by local overrides; the custom role declares both flags in its definition. Without global inheritance, global instructions are excluded by default. Skill inheritance is controlled separately below.
- `second-opinion` explicitly loads only `pi-web-access`; its native file-inspection and web tools do not require AFT, Magic Context or the MCP adapter. This role-specific list replaces the base provider list rather than adding to it.
- Role `tools` lists are explicit allowlists. A listed extension tool needs its provider loaded; loading a provider alone does not grant every tool it registers. Preserve existing inspection/execution boundaries when adding a capability. A read-only research task can still return an assigned report; it does not authorize source edits.

MCP is an additional provider only for the selected roles; its wiring is defined in [MCP and REA access](#mcp-and-rea-access). Model/other runtime overrides remain in the same settings file; this guide does not redefine upstream prompts, output defaults, or acceptance behavior. The custom role's prompt is maintained in its own definition.

### Instruction inheritance and primary-only text

The [global `AGENTS.md`](../agent/AGENTS.md) supplies shared policy; the [operator's `APPEND_SYSTEM.md`](../agent/APPEND_SYSTEM.md) supplies the primary workflow trigger, absolute-path handoff instruction and second-opinion consultation policy. The [design guide](agents-md/instruction-layers.md#purpose-and-selected-architecture) explains content ownership, rationale and alternatives. Effective child loading follows the inheritance and fresh/fork rules below.

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

Select roles by the [task-based model tiers](model-selection.md#task-based-model-tiers), then check their capability and reasoning requirements. The [2026-11-04 decision](model-decisions.md#2026-11-04--luna-executors-and-task-based-model-tiers) selects fixed Luna/max executors from practical experience; it supersedes worker/main parity and the former delegate profile. The [2026-10-31 decision](model-decisions.md#2026-10-31--more-reasoning-for-execution-sol-for-routine-review) still owns the [main baseline](settings.md#default-model-and-thinking) and routine reviewer rationale. Abstract requirements are defined in the [selection guide](model-selection.md#capability-and-reasoning-profiles); published model comparisons remain in the [dated assessment](models-2026-10-17.md#capability-profile-mapping).

| Role | Selected model / thinking | Motivation |
| --- | --- | --- |
| `scout` | `openai-codex/gpt-6-luna` / `low` | Focused code/file navigation, not investigative research. |
| `worker` | `openai-codex/gpt-6-luna` / `max` | Standard well-scoped implementation: practical experience supports Luna/max for clearly specified execution without unresolved architecture or codebase-wide design decisions. |
| `delegate` | `openai-codex/gpt-6-luna` / `max` | Standard well-scoped general execution: complete a bounded supporting task with a defined result, not a parent workflow or architectural decision. |
| `reviewer` | Inherited main model / fixed `max` | Frequent routine review needs lower resource weights than Astra; use the main model's maximum reasoning depth without claiming equivalence to Astra. |
| `oracle` | `openai-codex/gpt-6-astra` / `high` | Bounded consequential diagnosis and reconciliation of decisions. |
| `researcher` | Astra/high for consequential or conflicting analysis; Sol 6.1/medium for explicitly bounded routine synthesis | Match assignment scope, not token price alone; retain source verification by the parent. |
| `evidence-auditor` | `openai-codex/gpt-6-astra` / `high` | Independent verification of decision-critical claims. |
| `second-opinion` | `opencode-go/deepseek-v4.1-flash` / `max` | Frequent, bounded additional scrutiny of arguments and choices across any domain; advice requires parent verification and does not replace specialized review. See the [dated decision](model-decisions.md#2026-11-04--independent-second-opinion-on-deepseek-flash). |

For completeness-sensitive critical reviews, use an individually justified `openai-codex/gpt-6-astra:high` launch override. Do not automatically repeat every Sol review with Astra. Reviewer remains fresh and independently reads current evidence; using the same model as the author may leave shared blind spots.

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

Routine research and high-consequence analytical research are different assignments even when they use the same role. Model/depth changes must match the task, not just the role name. Narrow verification after a fix to the affected behavior and its blast radius; do not restart identical full reviews automatically.

### Worker and delegate boundaries

Both roles execute their assignments directly and have the same local tools, explicit skills and MCP provider. Neither has native subagent-spawning permission. The upstream phrase about delegate's orchestration inside a parent workflow does not grant nested delegation; the parent owns routing and follow-up launches.

For a fresh child, worker's `replace` mode supplies its detailed implementation prompt. Delegate's `append` mode adds a short general execution prompt to Pi's normal base prompt; it does not copy the parent's assembled prompt or conversation. Fork context is separate, as described in [instruction inheritance](#instruction-inheritance-and-primary-only-text).

Worker declares `acceptanceRole: writer`, default reads of `context.md` and `plan.md`, and default progress tracking. Its prompt requires code validation, minimal changes, tests and escalation of unapproved decisions. Delegate has no default reads or progress tracking and normally receives lightweight attestation rather than writer acceptance. Prefer worker for implementation and its validation evidence; use delegate for a bounded supporting result. Delegate can edit files when authorized, but its name does not imply a second implementation or orchestration layer. Its local description removes the builtin's now-inapplicable claim that it inherits the parent model; the prompt body remains unchanged.

### Independent second opinion

[`second-opinion`](../agent/agents/second-opinion.md) is a custom advisory inspector, not an additional implementation agent or an automatic replacement for `reviewer`, `oracle` or `evidence-auditor`. Its prompt adapts their evidence and decision discipline to questions outside software as well as technical work. It tests the strongest supported case and material challenge, compares relevant options against the same constraints, and identifies what the parent must verify. Agreement is legitimate; producing objections is not a success metric.

The [primary profile](../agent/APPEND_SYSTEM.md#independent-second-opinion) owns the mandatory invocation and verification instructions. They apply to complex or ambiguous questions, material trade-offs and choices between plausible solutions, and require a companion opinion for every reviewer/oracle launch. The primary supplies original evidence without treating the other agent's verdict as the expected answer, then independently checks consequential claims and records accepted, rejected or unresolved concerns. This is prompt policy, not a scheduler hook or a guarantee of model compliance; [project APPEND replacement and fork limits](agents-md/instruction-layers.md#project-append-replacement) remain.

The role uses fresh context, retained shared instructions and no ambient skills. The parent supplies the question, approved decisions, constraints, evidence anchors and current rationale; fresh context does not reconstruct omitted history. Its explicit tools allow native file inspection, web research/source inspection and supervisor questions, without shell, file-edit, MCP or delegation tools. `acceptanceRole: read-only` declares acceptance behavior; the tool allowlist supplies the capability boundary. Neither is an operating-system sandbox, and framework artifacts or web caches can still be written by the runtime. Return findings in the final response for managed persistence rather than granting a write tool for reports.

Model/effort is owned only by `subagents.agentOverrides.second-opinion`:

```json
{
  "subagents": {
    "agentOverrides": {
      "second-opinion": {
        "model": "opencode-go/deepseek-v4.1-flash",
        "thinking": "max"
      }
    }
  }
}
```

The pin is independent of the active parent provider. Pi 1.4.0's Go catalog supports `max` without clamping. Without this override, the custom definition has no model or thinking pin and follows applicable defaults; a supported explicit launch/project override can also replace it. `advertise: true` adds discoverability after catalog refresh, not automatic routing. No fallback model or recursive consultation chain is configured.

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
- **Reviewer:** inherit the active parent model; set fixed max for routine independent review. Under the selected main baseline this is Sol 6.1/max. Preserve the exceptional Astra/high launch policy above and check effort support when changing the parent provider.
- **Exceptions:** for a task needing stronger analysis, choose an explicit per-launch model/effort such as `openai-codex/gpt-6.1-sol:xhigh`. Native pi-subagents gives that override precedence over the role default. This is deliberate assignment, not automatic retry or model fallback after a failure.
- **Omission behavior:** without the worker model override, the builtin inherits the parent model; without its thinking override, the builtin uses high. Delegate has no builtin model or thinking pin and falls back to the applicable defaults. Removing its description override restores the builtin's inheritance wording. Explicit local pins avoid relying on these fallbacks.

These executor/reviewer settings introduce no dynamic thinking inheritance, automatic downshift, routing plugin or new fresh/fork policy. `thinking: false` removes the role field rather than selecting a fixed effort. When changing task boundaries, models or providers, follow the [refresh workflow](model-selection.md#refresh-workflow) and review affected efforts together.

### Effective thinking support

Pi labels are not always distinct provider efforts. In Pi 1.3.0's OpenAI mapping, `minimal` and `low` both select provider `low`. Sol 6.1/Astra do not support `none`; an unsupported `off` request clamps to `minimal`, so it does not disable reasoning. For Sol 6/Luna/5.6, `off` maps to supported `none`. Pi 1.4.0's Codex catalog supports Luna max and Sol 6.1 high, xhigh and max without clamping; the Sol mappings preserve xhigh and max as distinct provider efforts.

`xhigh` and `max` are distinct. Codex Ultra is a product orchestration mode, not a Pi effort label. Native `fast` requests priority service and is not an effort setting. These are client-setting semantics; provider capabilities are recorded separately in the dated report.

### Delegation and context economy

- Delegate only for a concrete benefit: independent verification, specialization, bounded parallelism, isolation or substantial parent-context compression. Available roles do not imply a pipeline through every role. The explicit second-opinion consultation policy remains controlling.
- Outside mandatory consultation conditions, keep quick targeted work or tightly interdependent phases in the parent when packet reconstruction, handoff and review exceed the benefit. Parallelism can reduce elapsed time without reducing total consumption.
- Supply outcome, authority, exact target/cwd, relevant decisions and evidence anchors, acceptance/checks, output and stop/escalation rules. Do not copy a transcript when a sufficient packet exists. Fresh does not mean dropping operator/project constraints; fork is justified when history is evidence.
- Return conclusions **and navigable evidence**: paths/ranges or URLs/passages, version/date, checks actually performed and limits. Compress bulk logs/search results, not proof. Reuse a scout's map rather than rediscovering everything; independently inspect consequential seams before accepting a change.
- Parallelize independent reads; keep mutation ownership explicit and isolate justified concurrent writers. Children remain leaf roles under this local configuration.
- Avoid redundant watchdog reviews, fast service tiers, provider-wide searches and broad extension/skill loading by default. Maximum effort is selected for the bounded Luna executors, routine reviewer and additional DeepSeek opinion under their recorded decisions, not as a default for every role; other uses need a concrete benefit. Do not disable required global instructions or remove relevant capabilities just to shorten context.

## Skills

### Selection policy

The seven builtin roles have explicit `skills` arrays and `inheritSkills: false`. The custom `second-opinion` definition declares `inheritSkills: false` without selected skills, so its normal catalog is also empty.

- The array selects the role's normal skill catalog; an empty array intentionally selects none.
- Disabling inheritance prevents unrelated current or future ambient skills from entering that catalog. Both fields are explicit so the policy does not depend on future builtin defaults.
- Selection advertises a skill's name, description, and file location. The agent reads its body when the task matches; selection does not preload every body or require using every selected skill on every task.
- Skills provide instructions, not tools or authority. Existing role and task boundaries remain controlling, including read-only review and escalation to the parent.
- The main agent keeps its normal skill discovery. Global/repository instruction inheritance is unchanged.

Newly installed skills need an assignment decision before becoming defaults. Adding instructions to an already selected skill does not require assigning its unchanged name again.

### Selected skill catalog

The personal `ck-testing` and `ck-task-workflow` skills live at `~/.pi/agent/skills/<name>/SKILL.md`, Pi's user-level skill directory. The other user skills live at `~/.agents/skills/<name>/SKILL.md`. The two package skills live at `~/.pi/agent/npm/node_modules/pi-subagents/skills/<name>/SKILL.md`.

| Skill | Source / automatic visibility in the main agent | Purpose |
| --- | --- | --- |
| `agent-browser` | User / visible | Browser and Electron interaction, browser-based testing, exploratory QA. It loads current workflow instructions through the installed CLI. |
| `grill-for-unknowns` | User / visible | Evidence-grounded critique of plans, assumptions, material unknowns, and acceptance criteria. |
| `handoff` | User / manual only | Summarize the current conversation for continuation by another session. |
| `reverse-engineer-anything` | User / visible | REA-based investigation of shipped artifacts and requested runtime evidence; not ordinary source-repository navigation. |
| `ck-task-workflow` | Pi user / visible | Primary-agent coordination of task plans, roadmaps, overall progress and working-file placement. |
| `ck-testing` | Pi user / visible | Design, write, modify, or review tests and validation checks. |
| `ub-mode` | User / visible | Code-change engineering principles and the checks specified by that skill, within existing role/task permissions. |
| `writing-for-agents` | User / visible | Design agent-facing instructions, including skills and `AGENTS.md` / `CLAUDE.md`. |
| `council-mode` | Package / visible | Parent-supervised advisor selection, bounded discussion, and decision synthesis. |
| `pi-subagents` | Package / visible | Parent-side delegation, orchestration, and subagent management. |

`handoff` sets `disable-model-invocation: true`, which hides it from automatic selection. `agent-browser` has a different field, `hidden: true`; Pi's native loader still exposes it to the model. Catalog visibility follows native loader semantics rather than an assumption based on that field name.

### Default assignments by role

Every row below has `inheritSkills: false`. The selected skills are the complete normal catalog, not additive examples.

| Agent | Selected skills | Why these skills fit |
| --- | --- | --- |
| `worker` | `ub-mode`, `agent-browser`, `ck-testing`, `writing-for-agents`, `reverse-engineer-anything` | Implements authorized tasks, including browser/UI verification, tests, and agent-facing documentation. REA provides artifact/runtime evidence when implementation or reconstruction needs it. |
| `delegate` | `ub-mode`, `agent-browser`, `ck-testing`, `writing-for-agents`, `reverse-engineer-anything` | Handles bounded general work and can obtain relevant artifact evidence itself. Broad execution tools and MCP access do not make it an orchestrator. |
| `reviewer` | `ub-mode`, `grill-for-unknowns`, `ck-testing`, `writing-for-agents`, `reverse-engineer-anything` | Reviews plans, tests, and agent-facing instructions, and independently checks artifact claims through REA. Its no-shell/no-repository-edit task contract remains; broad MCP capability is not a mechanical read-only filter. |
| `oracle` | `ub-mode`, `grill-for-unknowns`, `ck-testing`, `writing-for-agents`, `reverse-engineer-anything` | Challenges decisions and assumptions using relevant source and artifact evidence. It remains advisory and read-only rather than taking over execution or the user conversation. |
| `scout` | None | Navigates code and files for a handoff, rather than performing investigative research. Finding tests/instructions is not designing or reviewing them. The operator explicitly excluded this role from REA/MCP. |
| `second-opinion` | None | Uses its self-contained advisory procedure and a supplied decision packet; no execution, browser, orchestration or REA workflow is assigned by default. |
| `researcher` | `reverse-engineer-anything` | Combines web/repository sources with shipped-artifact or requested runtime evidence when the research question needs it. Test construction and instruction design remain task-specific, not defaults. |
| `evidence-auditor` | `reverse-engineer-anything` | Independently verifies claims against primary sources, including artifacts through REA. Its evidence-audit procedure is not automatically a test-design or instruction-review assignment. |

For an exceptional testing-specific research/audit or instruction-design investigation, the parent can select the relevant skill for that launch. A default omission is not a claim that a role can never benefit from that skill.

### Assignment boundaries and exclusions

**`ck-task-workflow` — primary-agent coordination, not a child default.** The [skill](../agent/skills/ck-task-workflow/SKILL.md) owns task/roadmap coordination; bounded child assignments do not transfer that ownership. The parent provides relevant context and working paths, while children return results and blockers through their existing channels. An undefined artifact destination is escalated to the parent; explicit and managed report destinations remain in use. All eight default catalogs omit the skill. Its read trigger is in the primary APPEND, not shared AGENTS; fresh native children bypass that operator profile. Catalog omission does not prevent direct file reads or remove instructions retained in a fork. Explicitly delegated workflow development/review may receive relevant instructions as task input rather than a permanent role default.

**`agent-browser` — execution roles only.** The installed CLI is reachable through `bash` for `worker` and `delegate`. `reviewer`, `researcher`, and `evidence-auditor` have no shell tool. `scout` restricts shell use to non-interactive inspection; `oracle` is an advisory, read-only analyst. They do not receive a default app-interaction workflow merely because browsing could be useful. Research/audit web-fetch tools remain available unchanged. CLI presence does not prove browser installation, authentication, or readiness for a particular target.

**`grill-for-unknowns` — plan/advisory review, not routine task expansion.** It is selected for `reviewer` and `oracle` because exposing consequential assumptions is part of their roles. Apply it when a planning/critique task warrants it, not as a mandatory interview for every diff. Its broader workflow does not authorize these roles to update `CONTEXT.md`, write ADRs, prototype, start children, or contact the human directly: findings and unresolved decisions go to the parent through their existing report/supervisor channel. Those role boundaries already exist in the builtin prompts. Execution roles should escalate gaps in an approved task rather than reopen the whole design process; source-reconnaissance and research/audit roles do not own that planning workflow.

**`ck-testing` and `writing-for-agents` — actors that construct or evaluate the relevant artifacts.** They serve the implementation and review/advisory roles listed above. Ordinary scouting, research, and source-claim auditing do not trigger them merely because the output is a Markdown report or the source mentions tests. `writing-for-agents` supplies useful design criteria for instruction review; its description is authoring-oriented, so catalog availability alone is not evidence that every review will load it automatically.

**`reverse-engineer-anything` — the six selected builtin execution/investigation roles.** Both investigative and execution roles can obtain artifact evidence when their task needs it. The route is the common `mcp` proxy plus this skill, not eager REA tool declarations. Skill availability, tool access, and backend readiness are separate checks. Ordinary source-repository navigation still does not need REA; granting this skill does not make every task a reverse-engineering task.

**`pi-subagents` and `council-mode` — parent orchestration only.** No enabled child role has the `subagent` tool. An oracle can participate in a council without receiving instructions to run the council. Likewise, `delegate` is a leaf executor despite its name. The extension additionally filters the `pi-subagents` orchestration skill out of child discovery/resolution; `council-mode` is excluded here by the local assignment decision.

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

## MCP and REA access

The six selected builtin roles use the common proxy, obtaining tool descriptions on demand; `scout` and `second-opinion` have no MCP grant. The official adapter installation, REA registration, and shared settings are prerequisites described in [settings.md](settings.md#mcp-and-rea); do not duplicate the server command or adapter-policy fragment in each role.

### Grants and provider loading

| Roles | Tool grant | Child provider | REA skill |
| --- | --- | --- | --- |
| `worker`, `delegate`, `reviewer`, `oracle`, `researcher`, `evidence-auditor` | `mcp` | `~/.pi/agent/npm/node_modules/pi-mcp-adapter/index.ts` | Selected |
| `scout`, `second-opinion` | None | Not loaded | Not selected |

Each selected role needs three independent pieces:

| Role setting | Effect | If missing |
| --- | --- | --- |
| `tools` includes `mcp` | Permits the proxy in the child's strict tool allowlist. | A loaded provider does not make the proxy callable by this role. |
| `subagentOnlyExtensions` includes the adapter entry point | Registers the provider in the child, in addition to its existing provider list. | The configured base/research provider lists do not load the adapter; requesting `mcp` then fails tool-availability preflight. Installing the package for the parent alone is insufficient. |
| `skills` includes `reverse-engineer-anything` | Advertises REA methodology for relevant tasks. | With ambient skill inheritance disabled, the role does not receive this skill in its normal catalog; MCP access itself is unaffected. |

Representative **additions** inside `subagents.agentOverrides.<role>`:

```json
{
  "subagentOnlyExtensions": [
    "~/.pi/agent/npm/node_modules/pi-mcp-adapter/index.ts"
  ],
  "tools": ["mcp"],
  "inheritSkills": false,
  "skills": ["reverse-engineer-anything"]
}
```

Merge these additions into existing lists; this is not a complete role definition. Keep the other skills in the assignment matrix and existing AFT, Magic Context, web, and execution/inspection tools. `subagentOnlyExtensions` appends the adapter without replacing `extensions` or `defaultExtensions`; preserve any other child-only providers too. Use the installed package entry point, not a copied extension or a transient cache path.

### Selected file, shell and research tools

`agentOverrides.<role>.tools` is an explicit replacement allowlist, not a list of additions to the builtin role. The custom role declares its own allowlist in its definition. The following groups define the selected sets without repeating identical names for every role. They describe tool permissions, not permission to use every tool on every assignment.

| Group | Tools | Motivation |
| --- | --- | --- |
| Base | `read`, `grep`, `find`, `ls`, `contact_supervisor`, `aft_search`, `aft_outline`, `aft_zoom`, `aft_callgraph`, `aft_inspect`, `aft_conflicts`, `ast_grep_search`, `ctx_search`, `ctx_expand`, `ctx_reduce` | File discovery and exact/structural inspection, retrieval/compression of relevant history, and escalation to the parent. Retain ordinary navigation names for builtin-task compatibility; prefer the indexed/structural AFT route when appropriate. Context compression changes conversation state, not repository files. |
| Shell | `bash`, `bash_status`, `bash_watch`, `bash_write`, `bash_kill` | Run and control necessary commands, background jobs or PTYs. A role/task's read-only inspection limit still applies; a shell is not mechanically read-only. |
| Write | `write` | Create authorized files or an assigned report artifact. Scout/research report permission does not authorize edits to the investigated project. |
| Mutation | `edit`, `aft_import`, `aft_move`, `aft_delete`, `aft_safety`, `ast_grep_replace` | Implementation edits, imports, moves/deletions and structural rewrites, with recovery/checkpoints. Keep these source-mutation tools with execution roles. |
| Web | `web_search`, `fetch_content`, `get_search_content`, `source_check` | Find external sources, inspect originals/stored passages and audit claims. Grant to research/audit roles and the general second-opinion inspector by default. |
| Diff | `watchdog_diff` | Read the review diff supplied by the watchdog integration; granting the inspection helper does not enable automatic watchdog runs. |
| MCP | `mcp` | Lazy configured-server access under the [MCP boundary](#tool-exposure-and-authority), not direct/eager REA schemas. |

| Role | Selected groups | Why this boundary |
| --- | --- | --- |
| `scout` | Base + Shell + Write | Code/file navigation, inspection commands and builtin report output; no source-edit toolkit, web investigation or MCP. |
| `worker` | Base + Shell + Write + Mutation + MCP | Implement and validate authorized changes, including relevant artifact evidence. |
| `delegate` | Base + Shell + Write + Mutation + MCP | Complete bounded execution tasks without an arbitrary tool deficit; lightweight means task/depth scope, not inability to finish the task. |
| `reviewer` | Base + Diff + MCP | Independent source/diff/artifact inspection without shell or file mutation. Parent/worker executes required checks. |
| `oracle` | Base + Shell + MCP | Read-only diagnosis can need inspection commands, but no direct source-write toolkit or autonomous implementation. |
| `researcher` | Base + Write + Web + MCP | Repository/external/artifact research and assigned report output, without shell or source mutation. |
| `evidence-auditor` | Base + Web + MCP | Independently inspect claim evidence; return findings through managed output rather than grant file writing for its own sake. |
| `second-opinion` | Native subset of Base + Web | Only `read`, `grep`, `find`, `ls`, `contact_supervisor` from Base, plus Web. Inspect supplied arguments and relevant sources without AFT/MC providers, shell, file mutation or MCP. |

A missing tool/provider produces a capability gap; a name in an allowlist is not proof of registration. Omitting `tools` would fall back to the role/runtime's selection instead of preserving this explicit boundary. Keep relevant AFT/MC providers in `defaultExtensions`, the web provider in research/audit `extensions`, and the proxy in the six selected `subagentOnlyExtensions` as described above. No child receives `subagent`, `todowrite`, `ctx_memory` or `ctx_note`: orchestration, task ownership and durable project decisions stay with the parent in this configuration.

### Tool exposure and authority

No role receives `codemode`, `mcpScript`, `mcp__rea`, `mcp:rea` selectors, or individual REA tools. The [parent's built-in disable setting](settings.md#pi-package-and-built-ins) does not replace the child allowlists: pi-subagents can register Pi's codemode factory in a child if that tool is explicitly permitted.

The `mcp:rea` selector is intentionally not used: it selects direct MCP tools and can expand the whole server eagerly, regardless of native deferred exposure. The common proxy provides full on-demand discovery without `tool_search` or a script interface. Use its [parameter-discovery contract](settings.md#parameter-discovery-and-large-responses), not skill examples as a substitute for missing parameter information.

The common grant reaches **all enabled, permitted servers** in the adapter's merged configuration, including later additions. There is no per-role server allowlist. Adding a server changes every MCP-enabled role's capabilities and warrants reviewing the grants; this is the accepted shared-access trade-off, not an accidental isolation guarantee. Shared filters and approval behavior are described in [settings.md](settings.md#access-and-approval-boundaries).

Capability is not task authorization. Read-only reviewers/auditors must avoid mutations, but their file-tool restrictions do not mechanically prevent modifying operations behind MCP. Neither the role profile nor skill selection is a filesystem sandbox.

### Session state and handoffs

Each child has its own REA server session, separate from the parent and other children. The shared `lazy-keep-alive` policy preserves state across idle pauses within that session; it does not survive session replacement or revival. A resumed conversation is not proof that the original REA process still exists.

Do not hand another agent a session-local evidence ID as if it were a global reference. Share durable artifacts, or request analysis in the receiving session. The [shared lifecycle policy](settings.md#adapter-policy) explains the memory trade-off and shutdown limits.

## Maintaining and validating the configuration

### Skill and role changes

1. Read the actual skill instructions and effective role prompts/tools. Distinguish a reusable method from a workflow that assumes mutation, interviewing, orchestration, or unavailable tools.
2. Change only the relevant role settings, preserving explicit skill selection and unrelated capabilities. Use project/launch overrides for task-specific exceptions rather than expanding every role's defaults.
3. Update the inventory, affected role rows, and rationale here. Replace competing setup descriptions elsewhere with links.
4. Use the installed loaders/resolver and prompt-building hooks to inspect all affected roles: names, resolved paths, no unresolved or hidden selections, no ambient-skill leakage, and preserved tool/task boundaries. Include project-local discovery/override cases when skill selection changes. Check returned data and generated prompts, not phrases in implementation files.
5. For meaningful skill/provider routing changes, inspect fresh child transcripts for the advertised catalog and actual skill reads. Discovery, correct skill selection, and quality of the work are separate claims. An ordinary unrelated task should not be forced to load a specialized skill.
6. Independently review substantive assignment changes and verify each finding against the current files and approved role boundaries.

### MCP configuration and package changes

- Check provider resolution and actual initial tool declarations for all affected roles, including the custom role when shared loading changes can affect it. The six selected roles need one `mcp` proxy and the REA skill; `scout` needs neither. Confirm `codemode`, `mcpScript`, server-specific wrappers, and eager REA tool declarations are absent.
- Run the [shared MCP validation](settings.md#applying-and-validating-changes) in a fresh relevant child, including complete model-visible parameter discovery, one analysis, and a retained-result read in that same session. A server catalog response or the child's self-report alone is insufficient; inspect actual tool calls and results.
- Check an ordinary source-inspection task separately: access to MCP should not cause irrelevant REA calls or preload its full catalog.
- When updating the adapter, keep the parent package and all six child-provider entry points on the same installed package. If the installation location changes, update every affected path and repeat provider-loading checks.

### Applying changes and document boundaries

Reload or restart each affected Pi instance after important active/background work has finished. `/reload` replaces extension runtimes; already-running children do not retroactively adopt new settings. Verify changes with newly launched children, not only resumed conversations.

## Sources

Installed files used for this configuration:

- Skill/MCP contracts: Pi 1.2.0 `docs/skills.md` and `docs/settings.md`, under that release's `@earendil-works/pi-coding-agent/` directory.
- Model/effort semantics: Pi 1.3.0 `README.md`, `docs/models.md`, `docs/settings.md`, and `dist/core/{model-resolver,sdk,agent-session}.js` under `~/.pi/agent/install/releases/1.3.0/node_modules/@earendil-works/pi-coding-agent/`; bundled `@earendil-works/pi-ai/dist/{models.js,providers/openai-codex.js,providers/data/openai-codex.json}`. These sources establish configuration semantics; the [dated assessment's source ledger](models-2026-10-17.md#sources) covers model evidence only.
- pi-subagents: `docs/{agents,configuration,models,observability}.md`, `agents/*.md`, and `skills/pi-subagents/references/prompting-and-roles.md` under `~/.pi/agent/npm/node_modules/pi-subagents/` (role overrides, model/effort policy, extension loading, prompt assembly, and skills). The upstream task-based tiers supply the selected routing framework; concrete role models and exceptions follow the operator-approved decisions, not the example IDs alone.
- Current profile resolution: Pi 1.4.0 `docs/settings.md`, `dist/core/settings-manager.js`, and bundled `@earendil-works/pi-ai/dist/{models.js,providers/data/openai-codex.json,providers/data/opencode-go.json}`; pi-subagents 0.84.0 `docs/models.md`, `src/agents/agents.js`, `src/shared/model-info.js`, and `src/runs/shared/model-resolution.js`. These establish fixed executor pins, inherited reviewer selection, per-launch exceptions, supported Luna and DeepSeek max, and distinct Sol xhigh/max mappings.
- pi-subagents implementation: `src/agents/agents.js`, `src/agents/skills.js`, `src/runs/shared/child-tool-plan.js`, `src/runs/shared/child-launch-plan.js`, `src/runs/shared/effective-system-prompt.js`, and `src/runs/shared/subagent-prompt-runtime.js`, relative to that package root.
- Skill contents at the inventory locations above; [testing rationale](../agent/skills/ck-testing/README.md) and [task-workflow rationale](../agent/skills/ck-task-workflow/README.md).
- Shared adapter behavior and upstream references: [settings.md](settings.md#references).

Recheck relevant installed behavior after an extension/Pi update rather than assuming this version's private helper APIs remain stable.
