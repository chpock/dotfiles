# Subagent contribution reporting

## Purpose and ownership

The operator wants control over how a set of possible solutions becomes the selected direction, not only a polished final recommendation. Consultation can improve a conclusion while hiding the alternatives that preceded it: the parent absorbs an advisor's argument, presents the revised answer, and leaves the operator unable to see or reconsider the earlier options.

The reporting policy preserves that decision-level history and makes each advisor's contribution visible. It serves four goals:

- Keep the original proposal and considered alternatives available, including options later rejected.
- Attribute new ideas, evidence, arguments, and objections to their actual sources.
- Let the operator assess rejected ideas against their own priorities and steer subsequent work.
- Make delegation useful to evaluate: new information, confirmation of known information, and incomplete work are distinguishable outcomes.

The operative instructions live in [`agent/APPEND_SYSTEM.md`, Subagent contribution reporting](../../agent/APPEND_SYSTEM.md#subagent-contribution-reporting). This guide explains their purpose and operation; it is not another rule source or a required read before every consultation. The [instruction-layer guide](instruction-layers.md#content-ownership) explains primary/shared ownership.

The reporting duty belongs to the primary agent requesting analysis, design, research, or review from any subagent. Its scope is defined by the requested work, not by a particular role such as `second-opinion` or `consultant`. A child can describe its own output, but it cannot reliably reconstruct the parent's earlier options, determine everything the parent already knew, or attribute a synthesis assembled from several responses.

## The problem the report addresses

Existing [Review handling](../../agent/AGENTS.md#review-handling) rules already require checking findings and reporting their dispositions. That establishes whether a claim should be accepted, rejected, deferred, or left unresolved. It does not by itself preserve the starting recommendation, identify every contributor, or explain whether an advisor added anything new.

Reporting only accepted findings also hides potentially useful alternatives. A rejected proposal may be unsuitable under the current constraints yet reveal a direction the operator would prefer under different priorities. Making that proposal visible does not make its supporting claims true or authorize changing the constraints.

Novelty, correctness, usefulness, and completeness are different properties. New information may support an unchanged recommendation. A repeated argument may provide confirmation without adding information. An unsupported new claim still needs assessment. A partial response may contain a useful discovery while leaving the assigned question unresolved. A failed run alone does not establish a defect in the agent's instructions.

## How the instructions work

### Before consultation: preserve the starting position

The baseline is a concise decision summary recorded before requesting advice: the current position, considered alternatives, key known evidence, and rationale. It is kept in the conversation or an existing task record, not reconstructed later from the final recommendation.

A tentative position remains tentative. Exploratory work can start without a preferred solution; the report states that absence instead of inventing a recommendation or a ranking of alternatives. The baseline is an account of the actual starting point, not a requirement to complete the investigation before seeking help.

The record concerns proposals, evidence, and short reasons, rather than a transcript of internal reasoning. Earlier alternatives remain traceable through later revisions and successive consultations. Their status can change without erasing their existence.

### After assessment: explain contributions and the outcome

The operator-facing comparison has three parts:

| Part | Information it preserves |
| --- | --- |
| **Before** | The starting position and alternatives, including options dropped after consultation. |
| **Contributions** | What each subagent actually added relative to the baseline and supplied context, together with the assessment and disposition required by Review handling. Rejected or unresolved contributions remain visible. |
| **After** | The current recommendation, what changed or remained and why, and any new synthesis developed by the parent from the contributions. |

Attribution comes from the actual responses, not from an advisor's claim of originality or the parent's recollection of the final answer. An idea already in the baseline or supplied context is not a new discovery merely because an advisor repeats it. A new source or argument can still be a contribution when the conclusion was already known.

Matching contributions can be grouped, with all contributors named. Different assessments remain visible rather than being flattened into apparent agreement. If multiple advisors supply the same new finding, grouping avoids repetition without assigning exclusive credit to whichever response arrived first.

The parent may construct a further option from several inputs. The report identifies that synthesis as the parent's and names the contributions it uses, rather than assigning the whole result to one advisor. Gaps in the baseline, attribution, or assessment remain explicit.

### No new information and incomplete work

Every consulted subagent is accounted for, including one that adds no new information. Confirmation of known information can be reported as such without being called either a new discovery or a useless result.

Incomplete or failed work is reported separately from an assessed no-new-information result. When a partial response contains a usable finding, both the contribution and the remaining limitation are visible. Failure to obtain an assessment is not evidence that the assessment found nothing.

The following are illustrative reporting cases, not measurements or reports from executed consultations:

| Case | What the report communicates |
| --- | --- |
| An advisor proposes a new option that violates a verified requirement | The option, its source, and why it was rejected; the proposal remains visible. |
| An advisor supplies new evidence supporting the original recommendation | The new evidence and its source, while stating that the recommendation is unchanged. |
| An advisor confirms the supplied reasoning without adding evidence or arguments | The named advisor added no new information and confirmed the existing position within the stated scope. |
| Two advisors independently report the same new issue | One grouped issue credited to both, with any disagreement about its significance preserved. |
| An advisor returns one usable finding but cannot finish the assigned inspection | The finding and its disposition, plus the incomplete coverage; neither replaces the other. |
| A consultation fails before producing an assessment | No assessment was obtained; no finding of correctness or completeness is inferred. |

### Timing and operator decisions

The comparison appears in the next operator-facing response after the results have been assessed. It can accompany an already-needed response rather than requiring a separate message or approval round for every consultation.

The operator sees it before the parent acts on changes that require approval under the existing [Working style](../../agent/AGENTS.md#working-style) and [Review handling](../../agent/AGENTS.md#review-handling) rules. Confirmed defects within current authorization remain governed by those rules; reporting creates no additional approval gate for every fix.

## Why this form was selected

A final synthesis alone is compact but hides earlier options and the source of changes. Ordinary finding-disposition reports remain necessary, but do not replace the before/contributions/after comparison.

Full transcripts or a compulsory separate idea journal would add volume and maintenance without necessarily making the decision easier to steer. The selected form preserves distinct options and arguments in concise summaries, groups repetition without losing attribution, and works in the conversation or an existing task record.

The wording follows `writing-for-agents`: a pre-consultation step with a concrete baseline, a post-assessment report with identifiable contents, and explicit handling of no-new-information and incomplete outcomes. Shared verification and disposition duties remain in AGENTS rather than being redefined in the primary profile.

## Boundaries and activation

- Reporting does not change [second-opinion invocation conditions](second-opinion.md), required companions, role permissions, models, or the authority to approve decisions.
- The policy does not require additional consultations, compulsory rankings, a new persistent journal, or a quantitative novelty score. Newness is not a proxy for quality, and reporting a limitation does not diagnose its cause.
- This is a parent coordination instruction, not a scheduler hook or a change to context storage. No claim of information loss through compaction is needed to explain the reporting problem.
- An existing task record remains subject to the [task-storage lifetime policy](task-workspaces.md). This reporting rule does not extend retention guarantees.
- The formulation is intended to improve visibility and steerability. It is not evidence of measured improvements in model behavior or decision quality; practical usefulness is assessed through ordinary work.
- Existing primary sessions need `/reload` to load the revised instructions. The [project-APPEND replacement and fork boundaries](instruction-layers.md#project-append-replacement) still apply.
