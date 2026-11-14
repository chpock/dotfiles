# Operator-authorized consultant

## Purpose

`consultant` provides an additional independent expert perspective on difficult questions: criticism of the problem framing and proposed solution, missing constraints, plausible alternatives, and revision as evidence changes. Its provider has a limited subscription allowance that the operator wants to allocate deliberately.

The distinction from `second-opinion` is resource governance, not a claim that the two roles must have unrelated intellectual jobs. Second opinions support frequent additional scrutiny under their existing invocation policy. The consultant is an invited resource for selected work, not a mandatory third reviewer or a final authority. A different model can add useful perspective without guaranteeing better or more independent conclusions.

## Ownership

| Location | Responsibility |
| --- | --- |
| [Primary APPEND: Consultant](../../agent/APPEND_SYSTEM.md#consultant) | Operative authorization, selective use, revocation, and consultation-continuation rules. |
| [Consultant role](../../agent/agents/consultant.md) | Advisory method, treatment of follow-up evidence, response shape, and inspection-only authority. |
| [Subagent configuration](../pi-subagents.md#operator-authorized-consultant) and [`agent/settings.json`](../../agent/settings.json) | Selected model/thinking, providers, permissions, context, and native continuation mechanics. |
| [Shared AGENTS](../../agent/AGENTS.md#review-handling) and [consultation reporting](subagent-contribution-reporting.md) | Verification, finding dispositions, operator decisions, and attribution of advisory contributions. |

This guide explains the policy and its rationale; it is not a second operative instruction body. Parent coordination belongs in APPEND, following the [instruction-layer design](instruction-layers.md#primary-append_systemmd), rather than in every child's shared AGENTS context.

## Authorization scope

Natural-language instructions express the permission; there is no command phrase or persistent enable/disable switch to memorize. The examples below illustrate the APPEND rule.

| Operator instruction | Meaning |
| --- | --- |
| “Use consultant in your work.” | Session-scoped authorization until revoked. |
| “Use consultant for task X.” | Authorization for needed consultations during X, not neighboring tasks; exhausted when X ends. |
| “Do not use consultant for this task.” | A task-specific exclusion, including within a broader session grant. |
| “Stop using consultant.” | Revocation of the applicable permission, including further follow-ups and affected active runs. |
| “Create/configure the consultant profile.” | Configuration work only, not permission to consume its model allowance. |

The parent's brief scope confirmation lets the operator correct a misunderstanding before resource use. Within a clear grant, the parent selects useful consultations without seeking approval for each call. A retained conversation is not a standing permission, and routing the same model through another role does not bypass the grant boundary. An unclear grant must be resolved from the original instruction or with the operator; the profile does not create a blanket authorization for future sessions or tasks.

Revocation stops resource use, not the existence of past advice. It does not require deleting history or permanently retiring a completed conversation. A later valid grant may permit continuation when the runtime still supports it; an actively stopped run has the separate native limitation described in the [runtime guide](../pi-subagents.md#continuing-a-consultation).

## Selective use without losing blind-spot detection

Authorization and invocation are separate decisions. A session grant makes the resource available; it does not establish that every question merits consultation. Bounded consequential choices, competing approaches, uncertain framing, and material new evidence are useful occasions. Repeating an unchanged review until advisors agree spends the allowance without establishing correctness.

The parent need not first identify a specific blind spot. Requiring a suspected defect would make the consultant least useful when the parent's confidence hides a flawed premise. The assignment can ask whether the question itself, its constraints, or the proposed direction are right.

Continuity serves a different purpose from fresh independent review. Reusing a related consultation preserves the facts and arguments behind earlier advice; explicitly identifying superseded premises avoids carrying old conclusions forward as facts. Unrelated work and an expressly requested independent reassessment call for a fresh consultation. The [native resume contract](../pi-subagents.md#continuing-a-consultation) owns the mechanics and retention limits, not a permanently running process.

The consultant can serve an oracle-like advisory need within an active grant. It neither replaces mandatory `second-opinion` consultations nor adds itself to their companion-role trigger list. Existing [consultation reporting](subagent-contribution-reporting.md) applies generically: preserve the parent's baseline, distinguish the consultant's actual additions from confirmations, retain alternatives not adopted, and explain the resulting position after independent verification.

## Selected mechanism and alternatives

| Option | Assessment |
| --- | --- |
| **Separate native role plus parent instructions** | **Selected:** a stable name, explicit model/resource identity, scoped permission, and native retained-session continuation without a new execution mechanism. |
| Override `oracle` or `second-opinion` with the other model | Technically supported and traceable, but mixes differently governed resources under one role name. |
| Programmatic launch gate | Could enforce covered calls more strongly, but adds a separate authorization lifecycle and must cover continuations, revocation, and alternate launch paths. Not selected. |
| Persistent `enable`/`disable` changes | Native management changes user/project settings, not a grant limited to one session or task. |
| Fresh conversation for every question | Loses consultative continuity and requires repeated reconstruction of the decision context. |
| One conversation for all work | Carries unrelated premises and growing context between tasks, weakening both relevance and independence. |
| Permanently active process, extra memory, or longer run timeouts | Unnecessary for native saved-session continuation; these mechanisms address different lifecycles. |

The name `consultant` describes an invited advisor without ranking opinions or encoding a vendor. `third-opinion` implies an ordinal review pipeline; `advisor` already aliases the bundled `oracle`. `counsel` and `perspective` were plausible naming alternatives, but neither is an additional role.

## Guarantees and limitations

- Authorization is model-followed instruction policy, not a technical spending barrier. Model scope, advertisement, and a configured profile are not substitutes for this permission.
- The [project APPEND replacement and fork limits](instruction-layers.md#project-append-replacement) still apply. A trusted project APPEND replaces the user profile instead of automatically merging its consultant policy; this implementation adds no loader or enforcement hook.
- Advisory access does not confer approval, execution, or nested-delegation authority. The tool allowlist excludes shell and source-writing tools, but the shared MCP gateway is not mechanically read-only; role instructions prohibit mutating services. Runtime persistence and provider caches are separate from model-authorized file editing.
- Saved conversation is not guaranteed provider-cache reuse, lower quota consumption, or unlimited retention. The configured model and provider do not prove successful account authentication or available quota.
- No per-call budget cap, subscription-account change, provider fallback, cache keepalive, or storage relocation is part of this policy. Ordinary use remains subject to the configured providers and native runtime limits.

The [model decision](../model-decisions.md#2026-11-14--operator-authorized-sonnet-consultant) records the model/effort choice. The [role guide](../pi-subagents.md#operator-authorized-consultant) records its concrete settings and source contracts.
