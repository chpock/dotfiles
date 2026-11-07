# Model-selection decisions

This journal records why model and reasoning choices change over time. Each dated decision separates practical observations, interpretation, the accepted choice and its trade-offs. Later decisions supersede earlier ones explicitly rather than rewriting their rationale.

The [selection guide](model-selection.md) owns the reusable method; [dated assessments](models-2026-10-17.md) own published model evidence. [Shared settings](settings.md) and [subagent configuration](pi-subagents.md) own configuration details. A decision's approval does not mean its runtime settings have been applied.

## 2026-10-31 — More reasoning for execution; Sol for routine review

**Status:** Applied to `agent/settings.json` and the configuration guides on 2026-10-31. This sets the baseline for new sessions and launches; it does not switch existing sessions or running children.

**Supersession:** The [2026-11-04 decision](#2026-11-04--luna-executors-and-task-based-model-tiers) replaces the worker/delegate assignments and worker/main parity requirement. The main-session and reviewer decisions below remain in force.

### Practical basis

The operator reports repeated gross errors during ordinary work with **GPT-6.1 Sol / high** and considers that profile insufficiently thorough for the main session. This is practical experience with the existing workflow, not a controlled model comparison.

The operator also reports that reviewer is used frequently enough that **GPT-6 Astra** makes routine review too expensive. The goal is to retain a substantial independent review step without paying Astra's resource cost on every review.

### Accepted choices

| Assignment | Previous baseline | Accepted baseline | Motivation |
| --- | --- | --- | --- |
| Main session | `openai-codex/gpt-6.1-sol` / `high` | `openai-codex/gpt-6.1-sol` / `xhigh` | Increase reasoning depth in response to unacceptable errors in normal work, without changing the model. |
| `worker` | Main model / `high` | Same model and thinking as the main baseline: currently Sol 6.1 / `xhigh` | Implementation must have the same model capability and reasoning depth as the main session; delegating work must not weaken its execution profile. |
| `delegate` | Main model / `medium` | Main model / `high` | Use a more thorough profile for small, fully specified tasks while retaining a lower depth than the main session. This is a deliberate depth choice, not an automatic decrement rule. |
| `reviewer` | Astra / `high` | Main model / `max`: currently Sol 6.1 / `max` | Reduce the recurring resource burden of frequent reviews while allocating the selected model's maximum reasoning depth to checking. `max` is distinct from `xhigh`. |

Worker parity concerns model capability and reasoning depth, not identical tools, context or authority. Delegate remains a bounded leaf executor; additional thinking does not expand its task scope.

Astra / `high` remains available for individually justified, completeness-sensitive reviews, such as difficult cross-component contracts, disputed architecture or changes with hard-to-reverse consequences. It is not an automatic second review after Sol. The other role assignments are unchanged.

### Interpretation and accepted trade-offs

- **More thinking is a response to insufficient quality, not a proven diagnosis of every error.** Additional reasoning may help with superficial analysis; it does not by itself repair missing context, misunderstood requirements or omitted validation. No claim is made that `xhigh` eliminates the reported failures.
- **Sol / max is not established as equivalent to Astra.** The [published capability evidence](models-2026-10-17.md#task-specific-capabilities) includes consequential omissions by Sol and does not establish that maximum thinking removes that gap. The routine-review choice accepts this possible loss of completeness in exchange for lower resource weights.
- **Independent review still requires an independent read.** A fresh reviewer context avoids inheriting the author's conclusions, but using the same model for implementation and review may leave shared blind spots. Different models would not guarantee defect detection either.
- **Token weights are not whole-review consumption.** The [dated comparison](models-2026-10-17.md#relative-economic-weights) gives Astra weights of 5× Sol 6.1 for uncached input/output and 10× for cached input. These are Codex credit-rate ratios, not included-subscription depletion ratios or guaranteed savings per accepted review. More reasoning can increase Sol's output consumption; no fixed effort multiplier is assumed.
- **Delegate high is a policy choice, not a separately observed failure threshold.** The reported main-session errors motivate a more careful execution baseline, but do not establish that delegate's bounded tasks were failing at medium. Keeping delegate below the main depth preserves the intended task/depth distinction without claiming that a one-level gap is intrinsically optimal.
- **Worker must not be left on its old thinking value.** Matching the model alone is insufficient: the preceding configuration uses the builtin worker `high`. Applying this decision requires aligning worker thinking with the new main baseline as well.

### Application boundary and reconsideration

The configuration uses native `model: "inherit"` for worker, delegate and reviewer, with fixed role thinking xhigh, high and max respectively. This selects the active parent model, not the `defaultModel` setting; role thinking does not automatically follow a session-level thinking change. Worker matches the selected main baseline. If the parent is temporarily switched to another model or thinking level, launch choices must preserve the intended worker parity and respect the selected model's supported levels.

Before marking the decision applied, update the affected configuration-guide values and runtime settings together and verify the effective model/thinking of newly launched roles. Existing sessions and children do not retroactively adopt new defaults.

Revisit these choices when ordinary use reveals continued gross execution errors, consequential review omissions or unacceptable resource consumption, or when new published evidence materially changes the model comparison. Reconsideration does not require a local benchmark campaign or comparative measurement program.

## 2026-11-04 — Luna executors and task-based model tiers

**Status:** Applied to `agent/settings.json` and the configuration guides on 2026-11-04. The pins apply to new launches; existing children retain their launch-time profiles.

### Practical basis and framework

The operator reports that **GPT-6 Luna / max** performs very well in real use on clearly specified tasks that do not require architectural decisions or codebase-wide design analysis. This is qualitative ordinary-use experience, not a controlled comparison or evidence that Luna/max is equivalent to Sol on every task.

The selected framework is the [pi-subagents task-based model tiering](https://github.com/nicobailon/pi-subagents/blob/main/docs/models.md#recommended-model-tiering-optional): fast workhorse, standard well-scoped, deep but bounded, and taste/intent. Its well-scoped tier explicitly includes implementation and general delegation. Earlier-generation Luna/max examples support the routing principle, not a measured capability claim for Luna 6. The [selection guide](model-selection.md#task-based-model-tiers) owns the reusable framework and transfer limits.

### Accepted choices and supersession

| Assignment | Previous baseline | Accepted baseline | Motivation |
| --- | --- | --- | --- |
| `worker` | Active parent model / fixed `xhigh` | `openai-codex/gpt-6-luna` / `max` | Use the practically successful executor for implementation inside an agreed contract, rather than requiring the same model as the decision-making parent. |
| `delegate` | Active parent model / fixed `high` | `openai-codex/gpt-6-luna` / `max` | Use the same evidenced execution profile for bounded supporting tasks with a defined result. |

This replaces the 2026-10-31 worker-parity requirement and delegate profile. The main remains **Sol 6.1/xhigh**; routine reviewer remains the active parent model/max, normally **Sol 6.1/max**. Scout, oracle, researcher, evidence-auditor and exceptional Astra/high review policy are unchanged. Adopting the tiering framework does not authorize importing every upstream example assignment.

### Role boundary and accepted trade-offs

- **Worker implements; delegate completes a supporting assignment.** Worker retains its implementation/escalation prompt, writer acceptance declaration, default plan/context reads and validation obligations. Delegate executes directly with its short append-mode prompt; it is neither a passive relay nor a nested orchestrator. Its local description no longer claims parent-model inheritance. Prompts, tools, skills, providers and authority are otherwise unchanged.
- **A formal brief does not eliminate hidden decisions.** Both roles must respect the approved scope; worker must inspect actual code and escalate newly exposed product, architecture or scope decisions. An assignment that already needs substantial unresolved analysis should be resolved by the parent/advisor or explicitly launched on a stronger suitable model.
- **The executor pins are independent of the parent.** Switching the main session to Astra or Claude no longer switches worker/delegate. An explicit per-launch exception can select another approved model/effort; no automatic fallback or retry on another model is introduced.
- **Effort does not equal capability.** Luna/max is selected for this task boundary from practical evidence, not because max makes Luna equivalent to Sol or Astra. Escalation, testing and independent review remain necessary; this decision does not establish the rate at which Luna detects hidden gaps.
- **No universal savings or quality claim is made.** The practical reason is task fit. Token weights and effort labels do not establish total consumption per accepted task, and there is no new benchmark or comparative measurement program.

Revisit the executor choice if ordinary use reveals missed consequential gaps, repeated rework or unacceptable validation failures, or if task boundaries or relevant provider capabilities change. Configuration verification establishes the selected model/effort and preserved contracts, not a general model-performance result.

## 2026-11-04 — DeepSeek Flash only for OpenCode Go

**Status:** Applied to `agent/settings.json` and the model-selection scope in [settings.md](settings.md#model-selection-scope) on 2026-11-04.

### Basis and accepted choice

The operator intends to use **only DeepSeek V4.1 Flash** through `opencode-go`, motivated by its **$100 monthly included-usage allowance**. The [official usage-limits table](https://opencode.ai/v2/docs/console/go/#usage-limits), checked 2026-11-04, confirms that it is the only model with a $100 Monthly limit in the **Go** plan, with the same limit for Peak and Off-Peak usage. Go Plus and Go Teams have different allowances and are not the basis of this choice.

Retain only **`opencode-go/deepseek-v4.1-flash`** in `enabledModels`; remove the other ten Go entries. Flash was already selected, so the preceding working scope contained eleven Go models. This explicitly replaces the former policy of retaining a selected set of Go models with a $60 Monthly limit. It is a named-model choice, not an instruction to add other models if their allowance later reaches $100.

### Boundaries and reconsideration

- Other providers' selections, main defaults and subagent profiles remain unchanged. This decision does not assign DeepSeek to a role or claim superior model quality.
- `$100` is the provider's included-usage allowance unit, not a subscription charge, an independent guarantee of request capacity or a local spending cap. Shorter-window limits and provider accounting still apply.
- `enabledModels` narrows normal startup/cycling scope. It does not delete other models from the provider catalog or forbid explicit selection. No hide rules, credentials, authentication paths or provider-console options are changed.
- The provider's separate **Extra Usage** option can permit pay-as-you-go fallback after included usage is exhausted; this configuration does not control it.

Reconsider the choice if the operator's intended use or the relevant Go allowance changes. Current settings semantics and the complete selected-model fragment remain owned by [settings.md](settings.md#model-selection-scope).

## 2026-11-04 — Claude 5.5 for Anthropic and Copilot

**Status:** Accepted rationale for the existing `anthropic` and `github-copilot` selections. The six model/provider entries are already configured; main defaults and subagent profiles are unchanged.

### Basis and accepted choice

Retain **Claude Opus 5.5, Sonnet 5.5 and Haiku 5.5** through both providers. The operator selects them as the latest generation within each of these three classes and for their favorable cost relative to preceding versions of the same class: Opus against Opus, Sonnet against Sonnet and Haiku against Haiku, not against every model in the provider catalog.

The [Anthropic model overview](https://platform.claude.com/docs/en/about-claude/models/overview) and [Copilot supported-model list](https://docs.github.com/en/copilot/reference/ai-models/supported-models), checked **2026-11-04**, identify all three 5.5 versions in their current lineups. The [Anthropic pricing table](https://platform.claude.com/docs/en/about-claude/pricing) and [Copilot token-pricing table](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing), checked on the same date, support these specific comparisons in USD per million tokens:

| Class and preceding version | Pricing basis for selecting 5.5 |
| --- | --- |
| Opus 5 | Input/output rates fall from $5/$25 to $4/$20; cache reads fall from $0.50 to $0.20. |
| Sonnet 5 | Input/output remain $2/$10; cache reads fall from $0.20 to $0.10. Sonnet 5.5 is cheaper on reused context, not on every token category. |
| Haiku 4.5 | Input/output fall from $1/$5 to $0.10/$0.50 for prompts up to 100,000 tokens, or $0.50/$2.50 above that threshold; both 5.5 tiers have lower rates than Haiku 4.5. |

### Boundaries and reconsideration

- “Latest and cheapest” is a same-class selection rationale at this date, not a claim that Opus, Sonnet and Haiku cost the same, beat every historical offer, or are the cheapest models across either provider. Other Claude classes, such as Fable, are outside this selection.
- Published token rates support the preference but do not measure whole-task consumption, Anthropic subscription-quota depletion or the exact cost under the operator's Copilot plan. Copilot's token/AI-credit pricing and legacy annual request-based billing are distinct; do not transfer rates between accounting paths without checking the plan.
- The selected provider-qualified IDs remain owned by [settings.md](settings.md#model-selection-scope). This decision neither assigns Claude to a subagent role nor changes authentication, thinking levels or provider-console spending controls.

Revisit the choice when newer same-class models, relevant prices or account terms change; do not retain the “latest” label indefinitely or automatically import a new generation without a selection decision.

## 2026-11-04 — Independent second opinion on DeepSeek Flash

**Status:** Approved and applied to the custom user agent definition, `agent/settings.json` and the primary `agent/APPEND_SYSTEM.md` profile on 2026-11-04. Existing sessions need the updated profile/catalog loaded; already-running children retain their launch configuration.

### Basis and accepted choice

The operator wants frequent additional scrutiny of arguments, reasoning, decisions, alternatives and compromises in any domain, not only architecture or code review. Select **`second-opinion`** on **`opencode-go/deepseek-v4.1-flash` / `max`** as a bounded, inspection-only advisor. The existing [OpenCode Go choice](#2026-11-04--deepseek-flash-only-for-opencode-go) provides the named model and its $100 Go-plan monthly allowance as the resource rationale; this decision assigns that model to the new role without changing the selected-model scope.

The role adapts the upstream oracle's decision discipline, reviewer's evidence requirements and evidence-auditor's source inspection. It may agree when the argument is sound, must distinguish evidence from inference and preferences, and returns material challenges, relevant trade-offs, a recommendation and concrete parent-verification targets. A cheap independent model is an additional viewpoint, not evidence of equivalence to the specialist models or a measured improvement in decision quality.

### Authority, invocation and trade-offs

- The primary profile owns mandatory use for complex or ambiguous questions, material trade-offs and choices between plausible solutions, plus a companion opinion whenever reviewer or oracle is launched. Independent scrutiny supplements those roles rather than replacing them. Their existing profiles remain unchanged.
- The parent must verify material claims and recommendations against primary evidence, the task contract and operator priorities, and account for accepted, rejected and unresolved concerns. Agreement between agents is not proof. New commitments or unsettled operator compromises still require the operator's decision.
- Fresh context avoids importing another agent's verdict as authority, but requires a sufficient question/decision/evidence packet. The role retains shared instructions, inspects files and web sources, and has no shell, edit, MCP or nested-delegation tools. It returns findings for managed persistence; read-only tool selection is not an operating-system sandbox or a ban on framework/cache writes.
- The model and effort are explicit role overrides, independent of the parent provider. Pi 1.4.0's installed Go catalog supports `max` without clamping. This client-side support is not a claim of equal reasoning capability across models or independent measurement of server-side computation.
- Mandatory consultation is an instruction policy, not automatic scheduling or a universal compliance guarantee. Existing project-APPEND replacement and fork-inheritance limitations of the [instruction architecture](agents-md/instruction-layers.md) remain; no loader patch or routing extension is introduced. Missing required opinions are reported for an operator decision, not silently waived or retried on another model.
- Extra consultations, parent verification and optional web research consume resources. The Go allowance is not a per-question cost guarantee or a cap on other configured web-service usage. Maximum thinking does not establish total consumption or recommendation accuracy.

The [role guide](pi-subagents.md#independent-second-opinion) owns current wiring and behavior. Reconsider the profile if practical use reveals too many unsupported objections, missed material issues, excessive parent rework or unacceptable consumption; no comparative benchmark claim is made by installing the role.
