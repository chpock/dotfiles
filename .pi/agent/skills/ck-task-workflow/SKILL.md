---
name: ck-task-workflow
description: Use as the primary agent for task planning and roadmaps, starting, resuming or completing multi-step work, or choosing a location for otherwise-unassigned task working files.
---

# ck-task-workflow

This workflow is for the primary agent coordinating work directly with the operator. Retain ownership of the overall plan/roadmap lifecycle when delegating bounded subtasks: provide the relevant task context and selected working paths, use returned results and blockers to update task state, and resolve requests for otherwise-unassigned artifact destinations.

Apply the procedures relevant to the assignment, within its authority and existing project requirements. Global authority, testing, review and delegation rules remain controlling; `ck-testing` owns test-design methods.

## Choose the needed workflow

- Unless a plan is explicitly requested, carry out small, unambiguous work directly. Reading this skill does not by itself require a plan, report file or task directory.
- Use a written plan when requested, or when work has consequential unknowns, dependent stages, several independent outcomes or expected continuation across sessions.
- Before creating or revising a written plan, read [planning.md](planning.md).
- Before creating a project plan or roadmap, resolving a name reference, or starting/resuming/changing a document's state in the standard store, read [plan-lifecycle.md](plan-lifecycle.md).
- Before authoring/coordinating a roadmap or working on one of its member plans, read [roadmaps.md](roadmaps.md). Standalone plans need no roadmap. Load branches only when their conditions apply.
- A planning-only request ends with the plan and its open questions; planning alone does not authorize implementation. A prepared future plan is not permission to start its work.

## Start or resume

1. Locate and read the existing plan or roadmap, relevant decisions and handoff before proposing a replacement. Resolve name references through the lifecycle procedure above; recover the established task path under the global continuity rules.
2. Establish the currently agreed scope, completed work, verification evidence, blockers and next action. Distinguish recorded claims from what their evidence establishes.
3. Check the prerequisites that matter against current files. Reassess checks whose evidence may have been invalidated by changes; continuation does not automatically repeat all work or all tests.
4. Continue when the next action fits the authorization and relevant prerequisites hold. Resolve consequential differences under the global decision rules before performing affected work.
5. For a standard-store plan, apply the lifecycle transition appropriate to the authorized work. Lifecycle placement is not permission to exceed the assignment.

## Execute and maintain task state

- Use one authoritative document per task or roadmap rather than competing copies.
- Assess each stage against its result and completion checks, not a count of edits or commands. Distinguish implemented work from verified work in progress records.
- For new evidence, distinguish changes to agreed goals, scope or constraints from implementation choices within them. Apply the global approval rules and record material decisions with their scope.
- Update the plan to reflect evidence and agreed changes. Preserve unmet requirements and verification gaps instead of weakening criteria retrospectively to declare success.
- Keep the plan concise: current state, material decisions and links to detailed logs, investigations and evidence belong there; their full contents remain in the appropriate working artifacts.

## Complete or hand off

- For multi-step work, reconcile each completion criterion with the result: fulfilled and verified; work performed but unverified or failing verification; not fulfilled; or changed/excluded by an agreed decision. Support the disposition with relevant evidence or the decision.
- Report remaining blockers, limitations and deviations explicitly. Do not present a partial handoff as completed implementation or an agreed omission as a passed check.
- For a plan in the standard project store, use the lifecycle procedure to reflect verified completion, an explicit pause or cancellation; unfinished work is not archived as completed.
- An operator response or a tool's managed report can be sufficient. Create a separate report file only when requested or needed for the task's durable record, using the applicable destination rules.

## Task working files

Apply the global rules for destination precedence and established task-path continuity before selecting a new fallback directory.

- For otherwise-unassigned plans, scratch scripts, reports, or test evidence, reuse an applicable task directory; otherwise run `"${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}/bin/pi-task-project-dir"` in the source CWD and use `<returned-dir>/YYYY-MM-DD-<description>`. For this shell command, a configured `PI_CODING_AGENT_DIR` must be an absolute path.
- Obtain the date from the host's local calendar. The description must match `[a-z0-9]+(-[a-z0-9]+)*` and be at most 64 characters. Create directories only when a working file is needed.
