# ck-task-workflow

A Pi user-level, model-invoked skill for the primary agent coordinating tasks directly with the operator: planning, execution, continuation and completion, including stable plan/roadmap identities, independent lifecycle organization and persistent working-material placement.

## Problem and purpose

A list of actions is not necessarily an executable plan. It can omit the reason for the work, hide an unresolved decision or offer no way to establish completion. Later sessions may then repeat completed work, trust stale progress labels, create a competing plan or report file changes as proof of success.

This skill connects the task's agreed outcomes to stages, current evidence and an honest completion report. Written plans are proportionate to uncertainty and continuity needs: small unambiguous work does not acquire a mandatory planning ceremony, while a planning request does not silently become implementation permission.

External working storage solves a separate continuity problem. Plans, scratch reproductions and test evidence can otherwise become scattered across source checkouts, temporary directories and unrelated sessions. The persistent project/task namespace is a fallback for unassigned artifacts, not a relocation mechanism for explicit destinations, project deliverables or native reports.

## Primary-agent and delegated-work boundary

The primary agent owns the overall task plan, roadmap, lifecycle transitions and task-level completion assessment. A bounded delegated result supplies evidence for that assessment; it does not transfer ownership of the project's workflow to the child.

The primary agent supplies relevant task context and selected absolute working paths. Children use assigned or legitimate predefined destinations and return their results, evidence and blockers. An otherwise-unassigned artifact destination is a question for the parent, not a reason for each child to establish its own project workflow.

The skill is omitted from all default subagent catalogs. Explicitly delegated work to develop or review the workflow may use the relevant instructions as task input; that exception does not make the skill a routine child dependency or grant lifecycle authority.

## Instruction files and conditional loading

| File | Role and loading condition |
| --- | --- |
| [`SKILL.md`](SKILL.md) | Operational entry point: choose the relevant procedure; start/resume, maintain state, reconcile completion and place unassigned working files. |
| [`planning.md`](planning.md) | Contents and readiness, read for creating/revising task plans or roadmaps. |
| [`plan-lifecycle.md`](plan-lifecycle.md) | Common identity, exact root/grouped lookup, project-plan storage and independent state transitions. Read for creation, name resolution and standard-store lifecycle work. |
| [`roadmaps.md`](roadmaps.md) | Cross-plan order, ownership, dependencies and aggregate results. Read for roadmap authoring/coordination or work on an owned member; not required for standalone plans. |
| `README.md` | Rationale, examples, ownership and maintenance reference. Not a required additional read during task work. |

The split is by activity, not by an arbitrary size limit. Resolving a name or moving a document needs lifecycle rules, not the plan-authoring checklist. Writing a new project plan needs authoring and lifecycle guidance; roadmap work also needs the coordination branch. An assigned nonstandard plan preserves its binding; an owner relationship still requires the relevant roadmap context. A standalone task plan does not require a roadmap or the roadmap branch. A report that needs a location does not need plan details.

The branches are not separate skills and add no always-advertised descriptions. Reading the main skill does not automatically preload them. There is no fixed plan template.

## Project-plan lifecycle and stable references

One independent task has one original plan; a roadmap is another plan that coordinates several tasks toward a common outcome. The common store makes both document kind and physical ownership visible:

```text
<project-dir>/
    plans/
        future/
            2026-11-03-plan-release-check.md
            2026-11-03-roadmap-export-modernization/
                2026-11-03-plan-add-csv-export.md
        focused/
            2026-11-03-roadmap-export-modernization.md
        archive/
            2026-11-03-roadmap-export-modernization/
                2026-11-03-plan-export-contract.md
    2026-11-03-plan-export-contract/
        evidence/
```

The standalone release plan needs no roadmap. The two grouped plans have the same owner but different states; their roadmap is itself focused. The repeated grouping name is not a duplicated roadmap file. A move affects one document, not the whole tree, so remaining future work is not relabelled as current and archived members do not close their unfinished owner.

New names contain `plan` or `roadmap` between the date and description. The date belongs to the initially selected name, not the later activation or directory-creation date. Existing unmarked identities remain valid without renaming. Each member's evidence retains its separate task binding rather than inheriting the roadmap's working directory.

Durable references such as `Task: 2026-11-03-plan-add-csv-export` and `Roadmap: 2026-11-03-roadmap-export-modernization` describe identity rather than current location. Exact lookup covers the three state roots and their immediate grouping directories. Names remain project-wide unique; zero or multiple matches cannot be resolved by a title guess or latest modification time. This exchanges clickable file links for lookup without a registry or rewriting references. Project context is still necessary, and explicit nonstandard locations retain their bindings. Historical path references do not acquire automatic redirects.

The directory represents lifecycle stage. Progress and readiness remain substantive facts in the plan: focused work can be planning-only, blocked or awaiting required acceptance. Archived plans preserve the completed/cancelled outcome and evidence or decision, rather than treating every closed item as a successful implementation. A pause preserves progress for continuation; it is not erasure or automatic selection of another task.

This is a default convention for new project plans, not a migration of existing documents. Assigned plan paths, maintained project material and native reports retain their own destinations. A standard-store plan is not copied into its working directory, and no new report destination follows merely from creating it.

## Examples and boundaries

- A one-line, well-understood correction can be performed directly when authorized. A requested plan for that correction still belongs to the planning branch.
- A multi-stage change with an unresolved compatibility choice needs a plan that identifies the choice, its consequences and the decision needed. A useful planning deliverable can be complete while implementation remains blocked.
- A recorded completed stage whose required integration check failed is implemented but not fully verified. The completion report preserves that distinction rather than deleting the criterion or treating command execution as success.
- A resumed task checks relevant current inputs and potentially invalidated evidence. An interruption alone is not grounds to repeat every check; an old progress label alone is not grounds to trust it.
- A future plan with an obsolete technical assumption remains a planning artifact, not an instruction to implement the old design. Its prerequisites are checked when work is authorized.
- A member plan reads its owning roadmap even when that file is in another lifecycle state. Relevant dependency outcomes constrain execution; an archived cancellation is not a successful prerequisite.
- A roadmap may reference a standalone plan or another roadmap's member without adopting or copying it. Overall completion follows its own criteria and evidence, not the count of archived task plans.
- A test log already routed by its tool keeps that destination. Only an otherwise-unassigned artifact needs the resolver-selected external task directory; no second copy is introduced.

Material decisions and concise current state belong in the plan. Detailed logs and evidence remain at their applicable destinations, linked rather than pasted into the plan. The skill does not require every task to create a report file or durable workspace.

## Ownership and boundaries

| Owner | Responsibility |
| --- | --- |
| [Shared `AGENTS.md`, Task working files](../../AGENTS.md#task-working-files) | Persistent destination precedence, no relocation/extra copies, maintained project locations, established task-path continuity and ambiguity/failure escalation. |
| [Primary `APPEND_SYSTEM.md`, Task working files](../../APPEND_SYSTEM.md#task-working-files) | Requires reading/rereading this skill for matching work and passing selected absolute paths to delegated agents. |
| [`SKILL.md`](SKILL.md) and its conditional branches | Task lifecycle, plan contents/readiness, identity/lookup/state transitions and the operative resolver/naming/create-only-when-needed procedure. |
| [Task-workspace reference](../../../docs/agents-md/task-workspaces.md) | Detailed resolver contract, rationale, examples, normalization, retention and limits. Explanatory, not a required additional read. |
| `ck-testing` and `ub-mode` | Their test-design and code-engineering methods; those instructions are not duplicated here. |
| Global/operator/project authority, testing and review rules | Permissions, scope changes, validation requirements and handling review findings. A plan or workspace does not expand authority. |
| [Pi subagent guide](../../../docs/pi-subagents.md#default-assignments-by-role) | Role assignments and the exclusion of this skill from default child catalogs, not a second copy of this coordination workflow. |

Existing project conventions and explicit task requirements remain controlling. The personal `ck-` prefix reduces accidental skill-name collisions; it is not a path pin or reserved namespace.

## Discovery and context

The Pi-specific user skill location is `~/.pi/agent/skills/ck-task-workflow/SKILL.md`. Pi discovers `<agent-dir>/skills/` automatically; the agent directory defaults to `~/.pi/agent` and can be overridden with `PI_CODING_AGENT_DIR`. Pi advertises the skill's name, description and path; its body is loaded with `read`, not an assumed tool named `skill`.

The primary-agent pointer in `APPEND_SYSTEM.md` covers plan/roadmap creation and management, starting/resuming/completing multi-step work and unassigned working-file placement. It requires rereading after context loss. Conditional references carry their own loading conditions; reloading only the main file does not recover a needed planning branch.

Persistent instructions and task recovery are distinct. Reading the skill recovers the procedure, not a forgotten task path, decisions or evidence. The current assignment, plan and handoff carry those separately; ambiguous recovery remains subject to the global escalation rule.

The primary agent retains normal skill discovery; default child catalogs omit this skill. Shared `AGENTS.md` does not impose the workflow read requirement, and fresh native children do not automatically load the operator's APPEND. This separates routine instruction delivery, not filesystem access or authority: a child may read an assigned workflow document, and a fork can retain the parent's instructions and previously read skill text.

The [instruction-layer guide](../../../docs/agents-md/instruction-layers.md#how-the-selected-mechanism-works) explains fresh/fork loading and project APPEND replacement. Same-name project skills and supported launch overrides can affect the resolved instructions; inspect the effective location when validating availability. Discovery and delivery do not guarantee correct application.

## Maintaining and validating the skill

Keep operative instructions in the main file and its substantive conditional branches. Keep explanations here or in the existing subject reference. Each operational rule has one owner; a deliberate ownership change includes updating the former owner and affected references.

Extend only agreed behavior. Keep plan identity, lookup and transitions together in their lifecycle owner; new approval gates, queues, mandatory review stages or tools require their own agreement. Conditional files earn their place through useful branch-specific procedure rather than empty routing or template hierarchies.

Validate native discovery for the primary agent, omission from default child catalogs, preserved unrelated role settings and local links. For operative workflow changes, inspect bounded primary-agent task behavior: relevant reads, standalone and roadmap/member planning, root/grouped lookup and conflicts, independent lifecycle moves that preserve identity/material bindings, dependency-aware execution, aggregate completion, preserved destinations and simple work that avoids unnecessary files. Catalog checks alone do not establish delivered instructions; inspect effective prompt content for that claim. Delivery checks alone cannot establish adherence to a workflow, and a successful model probe is not a guarantee of future compliance.

## References

- [Pi skills documentation](https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/skills.md): metadata-first discovery and file-based loading of skill resources.
- [Agent Skills specification](https://agentskills.io/specification): packaging and progressive disclosure.
- [Task working files and external workspaces](../../../docs/agents-md/task-workspaces.md): storage mechanism, precedence, examples and limits.
