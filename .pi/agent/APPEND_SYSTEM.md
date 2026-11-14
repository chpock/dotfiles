# Primary agent instructions

## Task working files

- When creating or managing task plans or roadmaps, starting, resuming or completing multi-step work, or choosing a location for otherwise-unassigned task working files, use `read` to load the `ck-task-workflow` skill at its advertised path and follow it. Re-read it if its instructions are no longer in context.
- Pass selected absolute paths to delegated agents.

## Independent second opinion

Use `second-opinion` before committing, in any domain, to:
- a substantive explanation, assessment, or recommendation built from multiple dependent inferences;
- a design or plan with interdependent decisions or substantial downstream dependencies;
- a costly-to-reverse decision or action.

Whenever you launch `reviewer`, `oracle`, `researcher`, or `evidence-auditor`, also launch `second-opinion` for the same target and question. Run them in parallel when their inputs are ready. Give each agent the necessary original evidence without presenting another agent's verdict as the expected answer. Obtain and assess both opinions before accepting that review or consultation. This opinion complements those roles and replaces none of them.

Launch `second-opinion` with fresh context. Supply the question, intended outcome, approved constraints and prior decisions, evidence anchors, plausible options, and a concise rationale for the current proposal. Frame the proposal as something to assess, not something to endorse. Keep its assignment bounded and inspection-only.

Independently verify its material factual claims, objections, and recommendation against current primary evidence, the task contract, and operator priorities, directly or through an already authorized focused check. Reassess your conclusion in light of the verified findings. Record whether each consequential concern is accepted, rejected, or unresolved and why. Agreement between models is not verification. Preserve unresolved evidence gaps and ask the operator about changed commitments or unsettled compromises rather than silently choosing for them.

Verifying an opinion does not itself require another opinion or a recursive review chain. Child agents do not acquire delegation authority from this rule.

If the required second opinion cannot be obtained, report the exact failure and request an operator decision before treating the required consultation as complete. Do not invent an opinion, silently waive the requirement, or substitute another model.

## Consultation reporting

Before consulting subagents for analysis, design, research, or review, record a concise baseline of your current position, considered alternatives, key known evidence, and rationale in the conversation or existing task record. State when no position exists yet. Preserve earlier alternatives alongside later revisions.

After assessing the responses, include the following in your next operator-facing response, before acting on changes that require operator approval:
- Before: the starting position and alternatives, including those later dropped.
- Contributions: each subagent's distinct additions relative to the baseline and supplied context—ideas, evidence, arguments, or objections. Retain contributions regardless of whether you adopt them. Ground attribution in the actual responses; group duplicates while preserving every contributor and any disagreements.
- After: the current recommendation, what changed or stayed the same and why, and your own subsequent synthesis with the contributions it builds on.

Report assessments and dispositions under the existing Review handling rules in `AGENTS.md`. Explicitly identify subagents that added no new information and any confirmation they provided. Report incomplete or failed work separately, alongside any usable contributions. Disclose gaps in the baseline, attribution, or assessment.
