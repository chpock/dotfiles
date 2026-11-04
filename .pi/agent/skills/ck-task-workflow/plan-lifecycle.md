# Project plan identity and lifecycle

Use this procedure to create project plans or roadmaps, resolve name references, or start, pause, resume or close documents in the standard project store. [Planning](planning.md) owns contents and readiness; the main skill owns execution and evidence-based completion. [Roadmaps](roadmaps.md) owns coordination of several plans.

## Scope and location

The standard store supplies a destination for new project plans and roadmaps when no stronger destination applies. Explicit operator paths, established project/tool destinations and existing bindings retain precedence. Keep those documents at their assigned locations; do not migrate or rename them, or create a standard-store copy. For a nonstandard document, preserve its known binding and applicable state convention.

Reuse the known project namespace. If none is known, obtain `<project-dir>` through the resolver procedure in [Task working files](SKILL.md#task-working-files), run in the relevant source CWD. The resolver returns the project directory, not a task directory. A changed date, origin or CWD does not replace an established binding.

The states are `future`, `focused` and `archive`. Within each state:

```text
<project-dir>/plans/<state>/
    <standalone-plan-name>.md
    <roadmap-name>.md
    <roadmap-name>/
        <member-plan-name>.md
```

A standalone plan represents one independent task, possibly with several stages. A roadmap coordinates several plans; it is a plan with the same identity and lifecycle rules. Only member plans go inside a roadmap grouping directory; roadmaps themselves remain at the state root. There is no separate `roadmaps/` store or recursive roadmap hierarchy.

Each document has one original in exactly one state. A grouping directory identifies ownership, not the state of the roadmap file. It can exist in several states with different member files while the roadmap itself occupies only one state root. Create only the directories needed to write or move a document, not an empty skeleton.

## Stable names

- Reuse established names. For a new identity, use `YYYY-MM-DD-plan-<description>` for a task plan, whether standalone or owned, and `YYYY-MM-DD-roadmap-<description>` for a roadmap. Apply the host-local date and description rules in [Task working files](SKILL.md#task-working-files); the kind marker is outside the 64-character description limit.
- Before choosing a new name, check for that exact `<name>.md` across all supported locations below and account for known bindings. Reuse the existing document for the same work; unrelated work needs a distinct description. Names are project-wide, not scoped to a roadmap or state; an archived name is not available for another task.
- State the full name in the document and keep its filename `<name>.md`. It remains unchanged through transitions, later sessions, title edits and later execution dates. Preserve older unmarked names and known bindings rather than applying the new format retrospectively.
- Use full names in durable references, for example `Task: 2026-11-03-plan-add-csv-export` or `Roadmap: 2026-11-03-roadmap-export-modernization`, rather than paths containing the current state. Within-project references use known project context; cross-project references also identify the project namespace.

## Resolve a name reference

1. Establish the project namespace and any explicit nonstandard binding. A name alone cannot identify a project or recover an unknown custom location; surface missing or ambiguous context. Read an explicit custom binding directly instead of assuming standard placement.
2. For a standard document, inspect the exact `<name>.md` at **all three** state roots and in their immediate roadmap grouping directories. Include both root and grouped matches even when an owner is expected. An absent directory is empty; inability to inspect one is an error, not evidence of absence. Use exact filenames, not partial titles, prefixes, recency or deeper recursive search.
3. With exactly one match, use its current absolute path and verify its role/location. With zero matches, report the missing document; with multiple matches, report the conflicting paths. Neither case authorizes a replacement, selecting the newest copy, deleting a conflict or performing a transition. A roadmap found nested as a member is an unsupported layout, not another hierarchy level.
4. A grouped plan belongs to the roadmap named by its immediate parent directory. Before working on it, read [roadmaps.md](roadmaps.md), resolve/read that roadmap at its own current location, and check the applicable ordering and constraints. Do the same for an explicitly recorded roadmap relationship at a nonstandard location. Missing/conflicting ownership is a blocker, not permission to treat the member as standalone. Root standalone plans need no roadmap lookup or roadmap-branch read.

Name references are not clickable file links. Resolve them before file operations; provide full names and resolved absolute paths in assignments/handoffs as needed. Working-directory and tool-output bindings remain paths. For member assignments include the resolved owner context needed to preserve its constraints.

## Lifecycle and transitions

| State or transition | Meaning and condition |
| --- | --- |
| `future` | Work prepared for later, not selected as current work. Creating or finding the document does not authorize implementation. |
| `focused` | Selected current work, including necessary planning. It is not approval of every action in the document. Several tasks or roadmaps may be focused simultaneously. |
| New document → `future` or `focused` | Use `future` for deferred work and `focused` for work already selected as current. A current task need not pass through `future`. |
| `future` → `focused` | The operator selects the work. Apply the main skill's start/resume checks and act only within the granted scope. Open design questions can remain while authorized planning proceeds. |
| `focused` → `future` | Work is explicitly paused/deferred. Preserve progress, decisions, blockers, evidence and the next step. |
| Open document → `archive` as completed | Its completion conditions are met, including operator acceptance where required. Record the outcome and supporting evidence/decisions. |
| Open document → `archive` as cancelled | An explicit operator decision cancels the work. Record cancellation and its reason; preserve existing progress rather than deleting the document. |

Blocked work or failed verification remains unfinished, not automatically archived or cancelled. Required acceptance pending prevents completion. Keep current work focused unless explicitly deferred. Directory placement describes lifecycle stage; the document records substantive progress, blockers and its completed/cancelled outcome. A future document is not an automatic queue entry.

Before a transition, resolve the single current file and check that the destination does not already contain that name. If already in the requested state, do not manufacture a move. Move the original with its filename unchanged, retaining contents and updating only relevant facts. A member keeps the same roadmap grouping name in its new state. Leave one original, not a copy or redirect. A conflict or failed move remains visible; do not overwrite a document or claim success.

Apply transitions independently: moving a roadmap file does not move its grouping directories or change member states; moving a member does not move its siblings or owner. A child can remain future while its roadmap is focused, or archive while its roadmap is unfinished. Apply any explicitly authorized collective decision to the affected documents individually, preserving each outcome. Placement alone does not propagate authorization, pause, cancellation or completion.

## Working materials and continuity

The document is the single original in the plan store, not a second `plan.md` inside its working directory. Preserve existing material-directory bindings. For otherwise-unassigned material with no prior binding, use `<project-dir>/<name>` for the relevant task or roadmap; create it only when a material file is needed. Use the established full name, not a new date or the containing roadmap's name for a member task.

Record the working directory in the relevant document when applicable. Logs, investigations and reports retain their destination rules; lifecycle transitions do not move them or introduce copies. Moving a document changes only its state-dependent file path, not its identity, project, owner or material binding. Existing historical path references are not rewritten automatically; new durable references use names.
