# Model selection and assessment guide

Use this guide when revisiting model/provider choices or preparing `models-YYYY-MM-DD.md`. It owns the reusable method, abstract capability/depth profiles and report requirements. Configuration values and their motivation belong in [settings.md](settings.md) and [pi-subagents.md](pi-subagents.md); dated reports contain model evidence and comparisons. See [CONTEXT.md](CONTEXT.md) for the documentation map.

**Current assessment:** [2026-10-17](models-2026-10-17.md).

## Decision rule

Choose the least resource-intensive evidenced option that meets the task's quality requirements. Consider all work needed for an accepted result, not an isolated inference. Use provider documentation, relevant source code, published articles/studies and critically assessed discussions. Model selection and future refreshes exclude local model experiments, benchmark campaigns and real comparative usage/performance measurements. Ordinary configuration/document checks and functional verification of unrelated software/MCP behavior remain separate.

Ordinary-use observations supplied by the operator can also motivate a local model/thinking decision. Distinguish the observation from its causal interpretation and do not generalize it into a universal model ranking. Record that practical basis, the accepted choice and its trade-offs in [model-decisions.md](model-decisions.md); no local benchmark campaign or comparative measurement program is required. Dated assessments remain reports of published evidence.

Separate model capability, reasoning effort, task scope, context and authority. More capability or effort is not automatically better for every task; lower token weights do not justify weakening a critical role without supporting evidence.

## Task-based model tiers

Use the [pi-subagents model tiers](https://github.com/nicobailon/pi-subagents/blob/main/docs/models.md#recommended-model-tiering-optional) as the starting framework: classify the work by the decisions and analysis it still requires, then select an evidenced model and supported reasoning effort. The upstream tiers are author recommendations, not shipped role defaults or comparative model measurements.

| Tier | Task shape | Selection boundary |
| --- | --- | --- |
| **Fast workhorse** | Reconnaissance, lookups and mechanical transformations. | A fast capable model with light reasoning for narrow work whose result can be checked directly. |
| **Standard well-scoped** | Straightforward implementation, routine multi-file changes, focused checks and bounded general delegation. | A capable executor for agreed requirements; substantial reasoning effort may be appropriate without selecting the strongest model. |
| **Deep but bounded** | Difficult diagnosis, consequential contradictions and hard reasoning with explicit goals and completion criteria. | A stronger reasoning model for the named hard problem, not an autonomous open-ended assignment. |
| **Taste and intent** | Interpreting unclear goals, UX/design judgment, product trade-offs and writing quality. | Select for interpretation and judgment; this is a different task dimension, not a universally higher intelligence tier. |

A precisely worded task is not necessarily Standard well-scoped: it can still leave architecture, cross-component behavior or difficult causal analysis unresolved. Settle those questions in the parent or an authorized advisory step, or explicitly select a stronger model for that assignment. Executors must still inspect the real code, recognize gaps and escalate unapproved decisions.

Read the actual role prompt, context, tools and acceptance behavior before assigning a tier. A role name does not guarantee task complexity; a generic delegate is not automatically an orchestrator. Keep local role assignments and exceptions in [pi-subagents.md](pi-subagents.md#role-scope-and-launch-policy), rather than treating upstream example model IDs as current settings. Validate those IDs against current evidence and operator experience; examples for an earlier model generation do not establish the next generation's capability.

The profiles below express the capabilities and reasoning needed within a tier; they do not form a competing role-routing ladder. Model, effort, task shape and authority remain separate choices.

## Capability and reasoning profiles

The abstract models express requirements, not vendor tiers or a universal intelligence score:

| Profile | Required capabilities and suitable task boundary | Not established merely by |
| --- | --- | --- |
| **Focused** | Accurate retrieval, exact extraction, clear transformations and concise evidence-preserving handoff; narrow, repeatable tasks. | Being fast/cheap, a large context window, or a high effort setting. |
| **General** | Reliable tools, coherent multi-step execution, dependency reasoning, validation and follow-through on an authorized deliverable. | A strong short-answer or coding benchmark alone. |
| **Deep** | Difficult causal analysis, consequential counterexamples, conflicting evidence and completeness-sensitive judgment across boundaries. | Highest token price, longest reasoning, or more reported findings. |

A model may qualify for several profiles and have different strengths in implementation, review, factual synthesis, intent interpretation and source verification. Establish product/client eligibility before comparing quality: authentication, tools, usable context/output and effective reasoning support.

Reasoning depth is an independent axis:

| Abstract depth | Use |
| --- | --- |
| **Light** | Clear lookup/transformation or bounded navigation. |
| **Normal** | Scoped execution or synthesis whose result will be checked/revised. |
| **Deep** | Substantive logic/contract review, causal diagnosis or consequential evidence checking. |
| **Exceptional** | A named hard subproblem with published evidence supporting extra depth; not a routine default. |

Map these depths to each model's supported provider efforts, then verify the client's effective mapping when preparing settings. Native names such as `low`, `high`, `xhigh` and `max` are not calibrated across models/providers; client aliases may collapse labels. Effort, answer length, speed, retrieval breadth and agent count are different controls. Never invent a fixed consumption multiplier for effort.

Role-specific quality requirements and usage boundaries are owned by the [subagent configuration](pi-subagents.md#role-scope-and-launch-policy). Model choice does not expand a role's authority.

## Relative-consumption evidence

Keep three categories separate rather than combining them into a synthetic score:

| Category | Valid interpretation | Invalid inference |
| --- | --- | --- |
| **Included subscription usage** | Documented quota rules/multipliers and plan-specific estimates. | Exact cross-model depletion from overlapping message ranges or purchased-credit rates. |
| **Relative economic weights** | Prefer the same product's credit/token rates, normalized to a named reference (=1); separate uncached input, cached input and output. | Calling them included-quota ratios or assuming identical tokens per accepted task. |
| **Accepted-task efficiency** | Published evidence and qualitative reasoning about context/schema input, reasoning/output, tool/model calls, handoff, attempts, checking and repairs needed for an accepted result. | Comparing only one inference, visible answer length or child wall time. |

If subscription conversion is undocumented, record that unknown. Relative weights still inform capability-first choices. API-rate ratios are a weaker labelled proxy when relevant product evidence is absent; absolute-dollar tables are unnecessary.

Record reference model, product, plan applicability, speed, date and token categories. Normalize only comparable categories. For an illustrative token vector `(U,C,O)` and raw rates `(I,K,Y)`, the credit-weight ratio against reference `r` is:

```text
R(model; U,C,O) = (U*I_model + C*K_model + O*Y_model)
                 / (U*I_r + C*K_r + O*Y_r)
```

Cached tokens are not also counted as uncached input. Aggregate only for an explicitly stated workload mix. A changed reference/provider requires recomputing comparable ratios or marking the comparison discontinuity. Published latency, token rates and allowance are distinct evidence.

## Sources and stopping rule

Classify consequential claims as executable behavior, documented contract, author recommendation, reported measurement, anecdote or our inference. Retain exact support, version/access date, applicability limits and confidence. A coding score does not establish review recall or source-audit quality; compare methodology, task set, effort, tools and sample limitations before transferring conclusions.

Start with varied searches, inspect the strongest originals, then make one focused pass for material gaps. Report unresolved evidence after that pass. For role/method changes, inspect up to 3–5 relevant harnesses selected for distinct concrete practices, not popularity or a coverage quota. A new model alone does not require repeating the harness survey. Keep source disagreements instead of counting posts into a consensus.

## Refresh workflow

Refresh after model additions/retirements, provider/auth/product/plan changes, relevant client effort/context changes or credible published capability/consumption findings.

1. Read selected requirements and choices in [settings.md](settings.md) and [pi-subagents.md](pi-subagents.md). Classify the affected work with the [task-based tiers](#task-based-model-tiers), inspect actual role prompts and preserve operator constraints and role authority. Revisit the selected model and fixed effort when the task boundary or relevant baseline changes. Inspect implementation only where needed to establish setting semantics, not to produce a deployment inventory.
2. Check compatibility: exact model/product identity, lifecycle, authentication path, tools, context/output and effort support. Registry visibility, configured enablement and product/account access are different facts. Keep client-specific setting implications in the configuration guides. Preserve each role's selected fixed or inherited model semantics when changing runners; an explicit pin must name the approved role model, not automatically the main default. This is a configuration choice, not automatic fallback after failure.
3. Revisit prior primary sources and targeted new evidence under the stopping rule. Assess task fit and relative resource weights separately; retain concrete unknowns and source conflicts.
4. Produce the dated report using the contract below. Compare candidates with the abstract requirements; retain stronger choices where sources do not justify weakening them. The report ends at model/profile conclusions, not role overrides or merge fragments.
5. Obtain independent review of material evidence and scope boundaries; verify findings against originals and resolve or explicitly disposition them. Check links, source IDs and numerical calculations with ordinary static checks.
6. Propose affected configuration choices and rationale in their owning guides; record dated changes of choice in [model-decisions.md](model-decisions.md). Separate proposed choices, operator approval and applying runtime files. No automatic fallback after quota exhaustion/errors is implied.
7. Update current-assessment links in CONTEXT.md and the three guides consistently; retain older dated reports as evidence. Apply runtime changes only when separately authorized.

## Writing a dated assessment

Use the actual research date in `docs/models-YYYY-MM-DD.md`. A report is a dated result, not a copy of this guide.

Required content:

1. **Scope and findings:** provider/product/access path, evidence date, covered model set and concise model-level conclusions.
2. **Lifecycle:** exact public IDs, release/retirement and product restrictions. Public API availability is not subscription entitlement.
3. **Model interface:** provider-declared modality, context/output and reasoning support/defaults; distinguish unknowns and product modes.
4. **Relative resource comparison:** subscription evidence, normalized economic weights with raw provenance and illustrative assumptions, and source-backed total-work implications. Keep the categories separate.
5. **Task-specific capability:** published results/recommendations, comparability limits and contradictory evidence. No universal intelligence score.
6. **Capability-profile mapping:** which models fit Focused/General/Deep requirements, reasoning examples, confidence and specific evidential gaps.
7. **Source ledger:** URL, exact supporting passage/table, publication/version where known, access date and transfer limits. References must resolve within the report or link to their actual owner.

Keep local configuration inventories, role assignments, JSON settings proposals, client-loader audits, research instructions, tool failures and review/process histories outside the report. Configuration choices belong in the configuration guides; reusable instructions and cross-harness practice evidence belong here. Source-specific limitations on the model comparison remain in the report.

## Practice evidence and transfer limits

The following sources informed the method and role/context policy; they are not model-comparison results. Unless another date is stated, they were accessed **2026-10-17**. Revisit them when their relevant contract changes.

| Source / version | Supporting passage or executable evidence | Lesson and transfer limit |
| --- | --- | --- |
| [Codex subagents](https://developers.openai.com/codex/subagents/), mutable official docs | “If you don’t configure a subagent model or `model_reasoning_effort`, the subagent inherits the parent agent’s model and reasoning effort.” | Model and effort are independent requirements. This is Codex behavior, not proof Pi does the same. Read-heavy parallelism and custom instructions do not establish a separate sandbox. |
| [Codex role.rs](https://github.com/openai/codex/blob/7ac954ea24116700632906d89715f7755cd3523e/codex-rs/core/src/agent/role.rs), commit `7ac954ea24116700632906d89715f7755cd3523e` | `let mut next_config = config.clone();`; independent model/effort overrides; worker: “Explicitly assign **ownership** of the task”. | Supports parent-derived configuration/ownership in that file, not a complete launch proof. Explorer's “typically … trust” advice does not override verification of material claims. |
| [Claude Code subagents](https://code.claude.com/docs/en/sub-agents#what-loads-at-startup), mutable docs | “Each subagent starts with a fresh, isolated context window”; forks inherit conversation. Main conversation advised when “Multiple phases share significant context” or for a quick change. | Fresh for bounded independent work; fork when history is evidence; sometimes do not delegate. Its instruction-file omissions do not transfer to Pi's global-context policy. |
| [Claude effort/skills](https://code.claude.com/docs/en/sub-agents#choose-an-effort-level) | Explicit effort; per-invocation effort from v2.1.292. Selected skill “full content … is injected … at startup”. | Separate effort from model and inspect loader/context cost. Version floor is documented, not an installed version. Pi metadata-first skills differ. |
| [OpenCode agents](https://opencode.ai/docs/agents/), mutable docs | Explore: “A fast, read-only agent for exploring codebases”; reasoning options “are model and provider-specific”. | Bounded navigation and provider-specific effort. Its permissions/Scout role do not establish Pi grants or effort inheritance. |
| [Anthropic production research system](https://www.anthropic.com/engineering/multi-agent-research-system), 2025-06-13 | “agents continuing when they already had sufficient results”; insufficiently detailed tasks “duplicate work, leave gaps”. | Task/stop contracts and evidence-preserving summaries; not a prescription for every coding task. |
| Same production report | Historical observations: agents about **4× chat tokens**, multi-agent systems about **15× chat tokens**; shared-context/dependency-heavy work can be a poor fit. | Both denominators are chats, not 15× one coding agent. These are not transferable Pi overhead ratios. |
| [Codex discussion #39808](https://github.com/openai/codex/issues/39808), 2026-08-20 | “This is not a controlled benchmark and does not isolate which component is responsible”; “The window is capacity, not necessarily actual input size.” | Anecdotal support for considering context/coordination overhead, not proof of a quota regression or accepted cause. |
| [OpenCode discussion #29067](https://github.com/anomalyco/opencode/issues/29067), 2026-05-24 | Alleged loss of parent variant; bot explains closure by unmet guidelines. | Anecdote motivating scrutiny of effort/resume semantics; procedural NOT_PLANNED closure is neither a root cause nor a design contract. |

The [pi-subagents model tiers](https://github.com/nicobailon/pi-subagents/blob/main/docs/models.md#recommended-model-tiering-optional), accessed **2026-11-04** and also present in installed pi-subagents **0.84.0**, supply the [task-based framework](#task-based-model-tiers). The accompanying `skills/pi-subagents/references/prompting-and-roles.md` distinguishes fast capable execution, strong review and bounded advisory reasoning. These are author recommendations, not model-quality measurements or role authority. Upstream example model generations and effort names require a fresh fit check; the selected review profile and no-edit boundary remain owned by the local role policy.
