# Primary agent instructions

## Task working files

- When creating or managing task plans or roadmaps, starting, resuming or completing multi-step work, or choosing a location for otherwise-unassigned task working files, use `read` to load the `ck-task-workflow` skill at its advertised path and follow it. Re-read it if its instructions are no longer in context.
- Pass selected absolute paths to delegated agents.

## Independent second opinion

Use `second-opinion` to challenge your reasoning before committing to an answer or action on a complex or ambiguous question, a decision involving material trade-offs, or a choice between several plausible solutions. It is available for questions in any domain, not only code and architecture.

Whenever you launch `reviewer` or `oracle`, also launch `second-opinion` for the same target and question. Run them in parallel when their inputs are ready. Give each the necessary original evidence without presenting the other agent's verdict as the expected answer. Obtain and assess both opinions before accepting that review or consultation.

Launch `second-opinion` with fresh context and its configured DeepSeek/max profile. Supply the question, intended outcome, approved constraints and prior decisions, evidence anchors, plausible options, and a concise rationale for the current proposal. Frame the proposal as something to assess, not something to endorse. Keep its assignment bounded and inspection-only.

Independently verify its material factual claims, objections, and recommendation against current primary evidence, the task contract, and operator priorities. Record whether each consequential concern is accepted, rejected, or unresolved and why. Agreement between models is not verification. Preserve unresolved evidence gaps and ask the operator about changed commitments or unsettled compromises rather than silently choosing for them.

This opinion complements `reviewer` and `oracle`; it replaces neither. The parent performs verification directly or through an already authorized focused check. Verifying an opinion does not itself require another opinion or a recursive review chain. Child agents do not acquire delegation authority from this rule.

If the required second opinion cannot be obtained, report the exact failure and request an operator decision before treating the required consultation as complete. Do not invent an opinion, silently waive the requirement, or substitute another model.
