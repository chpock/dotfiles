# Model-selection decisions

This journal records why model and reasoning choices change over time. Each dated decision separates practical observations, interpretation, the accepted choice and its trade-offs. Later decisions supersede earlier ones explicitly rather than rewriting their rationale.

The [selection guide](model-selection.md) owns the reusable method; [dated assessments](models-2026-10-17.md) own published model evidence. [Shared settings](settings.md) and [subagent configuration](pi-subagents.md) own configuration details. A decision's approval does not mean its runtime settings have been applied.

## 2026-10-31 — More reasoning for execution; Sol for routine review

**Status:** Applied to `agent/settings.json` and the configuration guides on 2026-10-31. This sets the baseline for new sessions and launches; it does not switch existing sessions or running children.

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
