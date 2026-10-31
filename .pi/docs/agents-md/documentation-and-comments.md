# Subject-focused documentation and code comments

## Purpose

Code comments and project documentation explain their subject to readers who did not participate in the development conversation. They preserve useful knowledge about behavior, constraints and reasons without requiring access to an agent's task history.

The authoritative instruction is in the global [`AGENTS.md`, Code and validation](../../agent/AGENTS.md#code-and-validation). That instruction is self-contained. This document explains the problem, interpretation, examples and supporting sources; reading it is not a prerequisite for following the instruction.

## Problem and motivation

An agent uses conversation to explain its actions, report progress, negotiate decisions and tell the operator what remains to be done. Those are useful communication functions, but they do not automatically belong in the code or project documentation produced during the task.

The failure occurs when that conversational frame carries into a maintained artifact. A configuration reference becomes a completion message, a code comment narrates a review exchange, or a design explanation attributes a choice to a request instead of explaining the requirement or constraint it serves.

Typical symptoms include:

- Narration of the current task: “We added this setting” or “The implementation now uses the new parser.”
- Operator attribution: “This is enabled because the operator asked for it.”
- Progress and acceptance statements: “Phase two is complete,” “The review finding is fixed,” or “All checks passed.”
- Task-specific follow-ups: “You still need to reload after our change.”
- References to missing conversational context: “As discussed above” when the discussion exists only in the chat.

These passages age with the task rather than with the system. They can imply that an operation remains outstanding after it has been performed, obscure the actual reason for a constraint, and leave future readers unable to distinguish current behavior from a temporary step in implementation. Passive voice does not solve the problem: “The setting was added as requested” is still a task narrative.

## The governing distinction

The distinction is **subject description versus task-execution narration**, not formal versus conversational prose.

A sentence belongs in a maintained artifact when it helps the intended reader understand or use that artifact's subject. A sentence belongs in a task update or report when it explains what the agent did on the current assignment, what the operator said, what stage is complete, or what that operator still needs to do for this particular change.

| Information | Appropriate destination |
| --- | --- |
| A component's purpose, behavior, interface, invariant or limitation | Relevant code documentation or project guide |
| A non-obvious reason the implementation must preserve a property | A nearby code comment or appropriate design explanation |
| A setting's effect, omission behavior, scope or operational requirement | Its configuration reference or relevant operating procedure |
| A requirement or material trade-off underlying a design choice | The relevant design document or decision record |
| The agent's edits, task progress, review disposition or checks performed | Operator communication or a task report |
| A one-time action still needed from the operator to finish the assignment | Operator communication or a task handoff/report |
| A versioned product change, compatibility boundary or migration | Changelog, release notes or migration documentation, according to the artifact's purpose |

Task reports are a separate artifact category, even though they may also use Markdown. This rule distinguishes content and audience; it does not select filesystem destinations. The separate [task-workspace policy](task-workspaces.md#destination-precedence) determines where an otherwise-unassigned report goes, while explicit and legitimate predefined destinations remain authoritative.

## Writing code comments

A code comment supplies useful information that the code alone cannot communicate, such as an invariant, external constraint, failure mode or non-obvious reason. API documentation can describe purpose, inputs, outputs, errors and usage. The existing instruction to comment only when the reason is non-obvious continues to govern whether an implementation comment is needed at all.

Comments explain the resulting implementation, not the sequence of attempts that produced it. A rejected alternative can still matter when its concrete limitation explains why an apparently simpler change would be incorrect; retain that limitation rather than the story of trying and rejecting it.

For example, a relevant comment could be:

```ts
// Keep the server alive to retain analysis state between requests.
```

The comment identifies the purpose of the lifetime choice. “We enabled keep-alive after the operator requested persistent analysis” instead records the conversation and leaves the technical requirement less direct.

Removing first-person language is not enough. “The lifetime issue was fixed during review” is still a review-status statement. If no useful explanation remains after removing the narrative, the added comment may be unnecessary.

## Writing project documentation

A reference explains what the system does, which values or modes are supported, what happens when a setting is omitted, and which constraints affect its use. A conceptual guide explains the model and reasons. A procedure gives repeatable steps for an identified reader goal.

For ordinary product and reference documentation, describe the applicable behavior directly rather than framing every sentence as a change from a previous implementation. Words such as “now,” “new” and “no longer” need a real version or historical purpose; they are not substitutes for stating the contract.

Preserve useful rationale without inventing it. If the conversation establishes a requirement, describe the requirement and its consequences. A request by itself does not establish a technical reason. When the only supported fact is that a value is the selected preference, state it as a preference where relevant or omit an unnecessary explanation; do not fabricate performance, security or compatibility claims.

### Illustrative transformations

The behavior statements below illustrate writing style; they are appropriate only when supported by the system being documented.

| Task-oriented passage | Subject-focused treatment |
| --- | --- |
| “We enabled keep-alive because the operator requested it.” | “Keep-alive retains in-memory analysis results between requests.” |
| “We moved parsing out of render after the reviewer pointed this out.” | “Parsing runs during preparation; rendering reuses the prepared data.” |
| “The implementation now uses the new resolver.” | Describe the resolver's selection rules and inputs directly. |
| “The reviewer finding is fixed and phase two is complete.” | Put the disposition and completion status in the task report, not the product explanation. |
| “You still need to run `/reload` after our change.” | Put this one-time follow-up in the operator update. Describe reload semantics in the relevant operating guide if they are part of that guide's subject. |
| “This follows the decision we discussed above.” | State the actual requirement or decision, or link to its maintained record rather than to an unavailable conversation. |

## Boundaries and legitimate cases

### Operating procedures and reader-directed instructions

The rule does not prohibit instructions addressed to the reader. “After editing the configuration, reload the application” can be a valid operating step when that is the actual activation requirement and the document owns that procedure. An example command is useful when it helps a future reader perform the documented operation.

The distinction is between a repeatable instruction and the current operator's outstanding task. A configuration reference can explain when values take effect; it should not become a deployment checklist tied to the agent's most recent edits. Conversely, a dedicated application/reload procedure should not lose necessary activation steps merely to avoid imperative language.

The command `/reload` and the pronouns “we” and “you” are not forbidden tokens. Their meaning, audience and purpose decide whether the passage belongs. Keyword deletion or conversion to passive voice is not an adequate check.

### Changelogs, migrations and historical documents

Change history is legitimate when history is the subject. Release notes describe versioned changes; migration guides explain differences and required actions; architecture decision records can preserve context, alternatives and consequences. Dated research can retain source dates, investigated versions and factual limitations.

These artifacts still distinguish product or decision history from agent task history. “Version 2 adds a migration command” describes a release; “I completed the migration step from our plan” describes task execution. An architecture decision record preserves the decision and reasoning, not a transcript of the operator-agent exchange.

No blanket prohibition on past tense, version references, issue links, alternatives or decision history follows from the rule. Their relevance depends on the kind of artifact and the information needed to understand it.

### Design rationale and operator requirements

A requirement supplied by the operator may be essential to understanding a design. Preserve its substance: for example, a required retention period, an access boundary or an accepted compatibility constraint. Merely writing “because the operator requested it” records who requested the choice without explaining the choice's purpose.

This is not a requirement to erase useful provenance from a decision record. Stakeholder ownership or an approval can be relevant to that record's purpose. The exclusion concerns narration of the current task conversation in place of subject-relevant explanation.

### Reports and communication

Task reports may describe implementation work, checks actually performed, review findings, unresolved issues and operator follow-ups. Such facts remain important; routing them away from product documentation does not excuse omission or unsupported claims of success.

Product validation instructions and task validation results are different. A test guide explains how to run or interpret a check. A particular run's pass/fail result and its limitations belong in that run's evidence or task report unless the document's explicit subject is those results.

## A practical editorial test

A useful review asks:

1. Can the intended reader understand the passage without the task conversation or the diff?
2. Does it explain the subject, a relevant constraint/reason, or a repeatable procedure?
3. Does its meaning remain valid after this particular task is finished?
4. If it is historical, does the document actually own that history and give the necessary reference point?
5. Is a claimed reason supported by evidence, rather than inferred from the fact that a request was made?

A passage that only reports task execution belongs in communication or a task report. A passage with lasting information can be rewritten to preserve that information. An unnecessary added comment can be removed rather than expanded. This is a semantic distinction, not a mechanical ban list, and instructions do not guarantee model compliance.

## Why the rule is short and self-contained

The global instruction combines a positive target—write for readers without the conversation—with a concrete destination for task narration. It is applicable at the point of writing a comment or document without requiring a separately selected skill, another guide read, or recollection of a prior correction in chat.

The local [`writing-for-agents` guidance](../../../.agents/skills/writing-for-agents/SKILL.md) favors explicit target behavior, a concrete guardrail where needed, and minimal always-loaded context. Those principles motivate keeping the operative rule in `AGENTS.md` while this reference carries the examples, distinctions and source discussion. The detailed wording remains a local synthesis rather than a quoted external standard.

## Sources and their scope

The following are primary-source examples and writing guidance. Repository instruction files express their own maintainers' conventions, not universal requirements for every project. Their broader rules are not adopted wholesale here.

### Kodi: comments independent of agent iteration history

[Kodi `AGENTS.md`, Comments](https://github.com/xbmc/xbmc/blob/master/AGENTS.md#comments) says:

> Do not leave comments that only make sense in the context of an agent's iteration history.

It also discourages recounting approaches tried, considered, replaced or removed. Implementation history and review rationale go in commit messages or PR descriptions unless necessary to understand the finished code. Its advice to preserve existing comments outside the change's scope is distinct from the rule about newly written text; the subject-focused rule alone does not authorize unrelated cleanup.

### Projen: separate code explanation from historical narration

[Projen `CLAUDE.md`, Code comments](https://github.com/projen/projen/blob/main/CLAUDE.md#code-comments) states:

> **No history in comments**: Do not narrate past decisions, alternatives considered, or issue numbers. That belongs in commit messages, PR descriptions or ADRs.

This illustrates separation of destinations. Its blanket wording about issue numbers and its other comment-length requirements are project-specific; the local rule instead keeps subject-relevant references and reasoning when they help the reader.

### Cadet: present behavior rather than a description of the diff

[Cadet `AGENTS.md`, Code Comments](https://github.com/vargasjr-dev/mycadet-temp/blob/main/AGENTS.md#code-comments) uses the principle:

> Comments describe the present; PRs describe the history.

Its examples discourage “now uses,” “was previously” and “after the refactor,” and suggest moving comments that only make sense beside the diff into the PR description. The useful distinction is reader independence. Its broad treatment of reasoning as PR material is not a reason to remove necessary rationale from code comments or design documentation.

### A shared AGENTS.md example: concise purpose and rationale

[Bensyverson's `AGENTS.md`, Principles](https://github.com/bensyverson/agents-md/blob/main/AGENTS.md#principles) distinguishes API documentation from implementation comments:

> **Comments say why, not what.** Doc comments state *what* concisely; other comments only explain the non-obvious. No change history in comments. Most code needs none.

This supports the existing distinction between API contracts and non-obvious implementation reasons. It does not imply that an API docstring should omit its purpose or behavior.

### Google engineering practices: preserve useful reasons and API contracts

[Google, What to look for in a code review — Comments](https://google.github.io/eng-practices/review/reviewer/looking-for.html#comments) says comments are usually useful when they explain **why** code exists, including information the code cannot express by itself. It separately identifies class, module and function documentation as describing purpose, usage and behavior.

This is a necessary complement to “no history”: removing task narration must not remove the reason a constraint exists. The same guide's [Documentation](https://google.github.io/eng-practices/review/reviewer/looking-for.html#documentation) section calls for documentation to remain aligned with code changes.

### Google documentation practices: match the document to its audience

[Google, Documentation Best Practices — Documentation is the Story of Your Code](https://google.github.io/styleguide/docguide/best_practices.html#documentation-is-the-story-of-your-code) distinguishes inline rationale, API contracts, directory orientation, operating instructions and design documents. It identifies future users and maintainers as the audience for API documentation, and treats implemented design documents as archives of decisions rather than substitutes for current references.

The title's “story” refers to useful explanation of the code, not to an agent's work diary. Different artifact types can legitimately describe behavior, procedures or historical decisions.

### Google developer documentation: avoid accidental temporal context

[Google, Timeless documentation](https://developers.google.com/style/timeless-documentation) recommends describing the applicable product behavior without relying on readers knowing earlier or future versions. Words such as “new,” “now” and “currently” can become stale or assume missing context.

It explicitly allows appropriate temporal language in time-stamped and procedural content, including release notes. This supports a relevance test rather than an absolute prohibition on historical wording.
