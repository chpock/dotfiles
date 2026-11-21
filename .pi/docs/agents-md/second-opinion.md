# Second-opinion consultation policy

## Decision and ownership

**Current policy (2026-11-21):** The operator removed `reviewer` from the mandatory companion list. Launching `reviewer` no longer requires `second-opinion` by itself. The general task-based conditions still apply, and `oracle`, `researcher`, and `evidence-auditor` still require a companion on the same target and question.

The 2026-11-14 decision introduced the three general task-based conditions and the four-role companion list described in the history below. The [2026-11-17 scope clarification](#2026-11-17--critique-scope-not-duplicate-execution) changed briefing and inspection depth, not invocation conditions.

The authoritative instructions are in [`agent/APPEND_SYSTEM.md`, Independent second opinion](../../agent/APPEND_SYSTEM.md#independent-second-opinion). This document records the operator's goals, the alternatives considered, the deliberation with Fable, and the later scope clarification. It is explanatory decision history, not another invocation rule or a required read before every consultation. Historical quotations below are rejected or superseded proposals unless identified as selected.

The [role definition](../../agent/agents/second-opinion.md) owns how the advisor assesses an assignment. The [pi-subagents guide](../pi-subagents.md#independent-second-opinion) owns runtime configuration; the [instruction-layer guide](instruction-layers.md) owns loading and inheritance boundaries. The 2026-11-14 decision changed parent instructions, not the role's model, thinking level, tools, providers, prompt, or inspection-only authority. The 2026-11-17 clarification also updates the role's evidence-inspection step. Earlier model choices remain recorded in the [model decision journal](../model-decisions.md#2026-11-04--independent-second-opinion-on-deepseek-flash).

## Operator goal

Before the 2026-11-14 decision, the operator reported that the existing instruction caused overly frequent `second-opinion` launches, including simple factual questions and trivial, unambiguous decisions. The desired outcome is more selective invocation while retaining independent discovery of overlooked assumptions, alternatives, consequences, and incomplete or incorrect reasoning.

The purpose is not merely to have a second agent recheck risks the primary already recognizes. An independently discovered problem should cause the primary to reconsider its reasoning, including when the primary initially considers its answer complete and sees no risk. Confidence is not evidence of completeness.

The selection combined the operator's explicit constraints with the existing scope retained in the approved text:

- Describe positive conditions for using `second-opinion`, rather than a list of cases in which it should not be used.
- Keep the instructions scoped to this role. A sentence such as “handle simple work directly” could interfere with unrelated delegation, evidence, or workflow obligations.
- Preserve mandatory parallel companions for `reviewer` and `oracle`, and extend that requirement to `researcher` and `evidence-auditor`. The operator explicitly treated these launches as appropriate cases for independent scrutiny.
- Retain the role's existing any-domain scope, which the approved text preserves.
- Write concise, actionable agent instructions using the `writing-for-agents` skill, not explanatory documentation in the always-loaded instruction file.
- Allow a coherent rewrite of the whole section, rather than treating the first paragraph as the only editable part.

The reported excess was practical operator feedback, not a measured attribution of launch counts to individual clauses. The 2026-11-14 expansion was deliberate: the operator wanted to narrow general invocation while keeping mandatory companions for those four roles at the time.

## Starting policy

The former first paragraph required consultation for:

> a complex or ambiguous question, a decision involving material trade-offs, or a choice between several plausible solutions

A separate paragraph required a companion whenever `reviewer` or `oracle` was launched. Later paragraphs required fresh context, an evidence packet, inspection-only scope, parent verification and concern dispositions, operator escalation, no recursive review chain, and explicit handling of an unavailable required opinion.

The difficulty-based categories were broad enough to fit many ordinary questions. The deliberation identified a plausible incentive to over-invoke: an omitted required consultation is an obvious instruction violation, while a redundant consultation is not. That is a reasoning-based explanation of the wording's effect, not a proven cause of every observed launch. The selected policy retains mandatory instructions but narrows what they name.

## Selection history

### 1. Softer obligation versus better conditions

The preliminary advisory comparison considered changing “Use” to “Consider” while keeping the same categories. It was not selected: that weakens the obligation without giving a clearer basis for choosing when the role helps. It also leaves an unconditional companion requirement untouched. The final policy changes the conditions themselves rather than relying on agents to disregard a broad trigger more often.

An opposite option, requiring a known defect or an explicit unresolved factual gap, was also considered and not selected. It would steer the advisor toward defect triage or missing-fact research, rather than challenging a conclusion that currently appears sound. Neither option was an operator-approved intermediate policy.

### 2. One risk threshold for all launches

The first concrete proposal used a material correctness/completeness risk threshold and would have made companions for `reviewer` and `oracle` conditional on the same threshold. It also proposed grouping concerns into one bounded consultation with a separate condition for repeat consultations.

The operator rejected removing automatic companions at the time. The 2026-11-14 decision required a parallel `second-opinion` on the same target and question whenever `reviewer`, `oracle`, `researcher`, or `evidence-auditor` was launched. This branch was independent of the general task-based conditions.

The final text retains bounded assignments and the existing no-recursion rule, rather than introducing a new per-decision consultation-count or repeat-launch policy.

### 3. Exclusion wording and unintended scope

An early draft began:

> Handle straightforward factual questions and routine, unambiguous decisions directly using primary evidence and ordinary checks.

The operator rejected this approach. Apart from describing when not to use the role, “handle ... directly” could be read as permission to bypass other instructions that still apply to a simple task. The request was to regulate `second-opinion`, not to redefine how all simple work is executed.

The final section therefore expresses application conditions only. This does not remove the existing authority and evidence safeguards elsewhere in the section; those safeguards are not an exclusion catalog for invocation.

### 4. Recognized-risk gating

The next proposal required uncertain assumptions, conflicting explanations, or non-obvious interactions to “create a material risk of an incorrect or incomplete conclusion.” It asked the parent to identify the reasoning or potential blind spot to examine.

The operator identified the circularity: the parent would have to recognize a reason to doubt the solution before asking the agent whose purpose includes discovering reasons the parent has missed. A confident but mistaken parent could bypass the consultation precisely when it would help.

This objection does not mean that inspecting a known risk is useless, or that noticing a risk proves it has been fully analyzed. It means that prior recognition of a risk is an unsuitable prerequisite for independent blind-spot discovery. The recognized-risk trigger was withdrawn.

### 5. First task-structure formulation

A subsequent draft moved to observable kinds of work: designing across interdependent requirements, choosing approaches with materially different consequences, or drawing consequential conclusions from indirect evidence. The intended distinction was between the structure of a task and the parent's judgment that its current answer might be wrong.

This was a direction for further discussion, not the final approved wording. The operator asked for consultation with Fable through `pi-intercom`, including the whole discussion and constraints, and explicitly invited a full-section proposal rather than a local edit to that paragraph.

### 6. Fable's constructed-and-load-bearing proposal

Fable reported reading the `writing-for-agents` skill and the actual instructions and role material. Its first full proposal used two concepts:

- **Constructed:** the parent builds a conclusion through inference, synthesis, design, or selection.
- **Load-bearing:** other work or commitments depend on the conclusion, or reversing it is costly.

This changed the axis from perceived difficulty or recognized risk to the structure of the commitment. However, the proposed examples included an answer “the user or later work will act on” and a plan “that further work will rest on.” Those descriptions also fit routine answers and small plans, so the examples did not enforce the intended distinction.

The primary challenged the draft with two illustrative cases: removing a redundant directory-listing tool after comparing documented capabilities, and a short setting-rename plan. Both could satisfy the draft's constructed-and-load-bearing descriptions even though neither description established a need for extensive independent reasoning. Fable accepted that the operative wording, not an explanatory claim outside it, had to carry the boundary. The metaphor was dropped in favor of explicit conditions.

These were reasoning examples used to examine the text, not executed configuration scenarios or behavioral measurements.

### 7. Direct checks as a proposed separator

Fable's next draft described an answer reached by interpretation or chained inference “beyond what direct checks confirm.” This was intended to distinguish analytical conclusions from answers settled by direct inspection while retaining substantial analysis with no downstream implementation plan.

The primary challenged that separator too: verifying the premises does not validate the inference that combines them. A parent with an unnoticed reasoning error could judge its checks sufficient and skip the consultation. Fable withdrew the clause because it could recreate the rejected self-assessment gate in a different form.

The selected wording instead names a substantive explanation, assessment, or recommendation built from **multiple dependent inferences**. The judgment about significance remains, but the condition no longer asks the parent to decide that its verification or confidence is insufficient.

### 8. Full-section refinements

The final discussion also changed the surrounding text so that invocation, briefing, and result handling fit together:

| Wording or option | Disposition and reason |
| --- | --- |
| “of your own construction” | Removed as a restriction. An assessment can concern someone else's proposal or conclusion; independent challenge is not limited to ideas originated by the parent. |
| Explanation or assessment only | `recommendation` was added explicitly so that an actionable verdict based on the same reasoning is clearly covered. |
| A choice costly to reverse “once work builds on it” | Replaced by a costly-to-reverse decision **or action**. Immediate commitments can be costly to reverse without subsequent work. This was presented to the operator as an explicit policy addition, not just a synonym for the old trigger, and approved with the final section. |
| “Use its findings to re-derive your conclusion” | Replaced by reassessment in light of verified findings. Re-derivation could require repeating the entire analysis even when the opinion finds no substantive issue. |
| Reassessment before verification | Reordered: independently verify material findings, then reassess the conclusion. An advisor's assertion does not become a premise merely because it is independent. |
| “These conditions are read from the work itself, not from your assessment of it” | Omitted. Fable initially favored this contrast as protection against confidence-based skipping; the primary favored positive invocation wording and avoiding extra rationale in the rule. Fable accepted the final omission. |
| A positive replacement telling the agent to evaluate reasoning, dependencies, and consequences | Omitted as a restatement of the three conditions rather than an additional useful instruction. |
| “substitutes for neither” in a four-role companion paragraph | Replaced by “complements those roles and replaces none of them,” with an explicit referent. |
| “a verified opinion needs no further opinion” | The original narrower wording was retained: verifying an opinion does not **itself** require another opinion or a recursive review chain. The revision does not impose a new blanket prohibition on later justified consultation. |
| A changed required-consultation failure sentence | The original sentence was retained verbatim, including reporting the exact failure and requesting an operator decision. No discretionary-failure exception or model fallback was introduced. |

An additional independent advisory check challenged the first full draft. Its useful findings—overbroad dependence examples, exclusion of externally originated conclusions, unbounded re-derivation, and the immediate-action gap—were assessed against the actual text and addressed in the deliberation above. Agreement between advisors was not treated as verification.

Two advisory suggestions were not adopted:

- Making the discriminator whether later work would assume the conclusion rather than recheck it. A simple retrieved fact can be assumed later, while an important standalone analysis may have no downstream work. Assumability does not establish inferential depth.
- Treating the failure sentence as a newly broadened escalation rule. Both the old and proposed conditions still concerned a **required** consultation. The final version preserves the original wording.

The possibility that automatic companions account for much of the launch volume remained unmeasured. It did not justify reopening the operator's explicit four-role decision.

### 9. Operator acceptance

The final proposal replaced the broad difficulty categories with three positive branches, kept the four-role companion requirement, and preserved the evidence and authority safeguards. It explicitly disclosed the new costly-to-reverse decision/action branch and the remaining judgment in the threshold words.

The operator accepted that complete wording and authorized its application, together with an English record of the goals, alternatives, rejected formulations, and deliberation with Fable. No intermediate risk-gated or exclusion-based proposal was adopted.

## Why the selected formulation fits the goal

The three branches identify different structures in which independent challenge can help:

| Selected phrase | Reason for the wording |
| --- | --- |
| “a substantive explanation, assessment, or recommendation built from multiple dependent inferences” | Names an important reasoning chain, including assessment of an external proposal and an analytical answer with no implementation plan. A flaw in one inference can affect later conclusions even when each cited fact is correct. |
| “a design or plan with interdependent decisions or substantial downstream dependencies” | Names interactions among decisions and assumptions on which significant later work depends. A missed constraint can invalidate more than the immediate step. |
| “a costly-to-reverse decision or action” | Adds independent challenge before commitments whose reversal is expensive, including immediate actions. Consultation supplements, rather than grants, any required operator authorization. |

These properties can be present when the parent is fully confident. The advisor's own prompt supplies the method for inspecting framing, assumptions, alternatives, and completeness; the parent instruction supplies when to request that inspection and how to use the result.

The companion branch remains distinct. Launching a role on the current list in APPEND is sufficient, regardless of how the parent classifies the general task-based conditions. Original evidence is supplied independently, both outputs are assessed, and the advisor does not replace the specialist.

The whole-section organization follows `writing-for-agents`: a separate condition for each invocation branch; briefing obligations together; verification and reassessment together; failure handling explicit; method and identity left in the role prompt where appropriate. The full operative text is maintained only in APPEND, rather than copied into this decision record or the runtime guide.

## Retained safeguards and boundaries

Fresh context and a bounded inspection-only assignment remain required. The brief retains the question, goal, constraints, prior decisions, original evidence, options, and rationale without presenting another agent's verdict as the desired answer. The parent verifies material claims against primary evidence, the task contract, and operator priorities; records accepted, rejected, or unresolved concerns; preserves evidence gaps; and escalates changed commitments or unsettled compromises.

The change grants no new child delegation authority, no approval authority, and no permission to substitute model agreement for verification. It retains the original anti-recursion and missing-required-opinion rules. It does not change shared AGENTS policy, the task workflow, model selection, or tool permissions.

## Accepted limits and activation

- `substantive`, `substantial downstream dependencies`, and `costly-to-reverse` remain judgment terms. The policy offers a more specific basis for that judgment, not a mechanical classifier or a guarantee against over- or under-invocation.
- A confident agent can still misclassify the structure or significance of a task. Removing a confidence-based prerequisite is not a guarantee that every unknown blind spot will be found. The optional confidence-contrast sentence was not included in the approved text.
- The 2026-11-14 decision made general invocation more selective while expanding the companion list. The 2026-11-21 decision narrows that list. Neither establishes a measured change in total launches, latency, or resource use.
- The counterexamples and wording comparisons establish reasons for the choice, not measured behavioral efficacy. Practical effect is assessed through ordinary use. The [local configuration maintenance policy](../settings.md#configuration-maintenance-policy) prohibits configuration tests and model-backed test scenarios.
- The instruction is prompt policy, not a scheduler hook. Existing primary sessions need `/reload` to load the revised profile. The [project-APPEND replacement and fork boundaries](instruction-layers.md#project-append-replacement) remain; this decision does not change prompt-loading behavior.

## 2026-11-17 — Critique scope, not duplicate execution

**Status: approved and applied.** This clarification addresses repeated execution inside a consultation, not how often the role is invoked. Operational wording remains in the parent profile and role definition; this section records its origin and rationale.

### Evidence and diagnosis

The operator reported that `second-opinion` often appeared to redo the primary's work and caused long waits. Static inspection covered the current instructions and four existing local runs from 2026-11-14–15. Representative observations:

| Existing run | Assigned work and observed activity |
| --- | --- |
| `b7ae5d89` | Explicitly assigned all 11 ck-repowise files plus coordinated settings and guide changes, using the same common brief as the parallel reviewer. It made 161 tool calls in about 14 minutes; the parent later steered it to finish without expanding into a full Repowise audit. |
| `0900dfdd` | Asked whether moving two instructions lost authorization or AFT priority, with a new source survey explicitly out of scope. It made 5 tool calls in about 45 seconds. |
| `c7781346` | Made 54 tool calls in about 8.5 minutes, but received two material proposal updates during the run. Its duration cannot all be attributed to redundant work. |

These are observations from existing logs, not configuration tests or a controlled comparison of task wording, models or thinking levels. The clearest observed source of duplication was assignment breadth: a complete second review was explicitly requested. The role already required critique and stopping at a conclusion or decisive evidence gap; a separate causal contribution from its wording was not established. Independent source rechecking is legitimate; duplicating the full investigation is not its default purpose.

### Meaning of the clarification

- The parent supplies its current reasoning as the object of critique. It may be provisional; a finalized answer from the parent or parallel specialist is not a prerequisite.
- The role checks decisive premises against primary evidence and investigates specific questions that could change the assessment. Such questions can arise from missing premises, omitted requirements, contradictions or alternative explanations; they need not be supplied by the parent.
- The same target and question remain mandatory for companion opinions. They do not require identical exhaustive review checklists. Critique still covers reasoning, framing, omissions and alternatives, not facts alone.
- Existing source-based independence, stopping, evidence-gap reporting, parent verification and operator decision rights remain. Agreement or another agent's verdict is not evidence.

### Wording choices and limits

Following `writing-for-agents`, only the parent briefing paragraph and role method step 2 were replaced. The parent instruction assigns a positive activity—critique of reasoning and material omissions—paired with a guardrail against repeating the underlying task. The role instruction bounds inspection by decisive premises and a specific consequential question, rather than adding another generic request to be concise.

A contradiction-only expansion rule was dropped because an absent premise need not contradict anything. Advisory review also identified the loss of the explicit safeguard against relying on the parent's confidence or another agent's verdict in an early shortened draft. The final text preserves that evidentiary safeguard without adding a separate assessment-ordering clause. Existing critique and stopping rules were retained instead of duplicated.

No invocation trigger, mandatory companion, model, thinking level, tool permission or runtime mechanism changed. A fact-only checker, removal of companions, model changes and arbitrary time/tool quotas were not selected. The clarification does not guarantee latency savings or eliminate the cost of independent inspection. No reload, configuration tests, probes or model-backed test scenarios were performed; the existing activation boundaries above still apply.
