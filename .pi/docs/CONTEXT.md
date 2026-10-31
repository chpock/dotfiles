# Documentation map

Documentation describes its subject: configuration, design, a reusable method or dated research. The [documentation and comments guide](agents-md/documentation-and-comments.md) explains the audience, rationale and distinction between subject knowledge and task-execution narration. Retain subject-relevant rationale, sources, versions and factual limitations.

The configuration guides define the selected settings, their effects and why they are chosen. They are configuration references, not deployment audits; applying settings is a separate action. Each topical guide contains substantive material directly about its subject, rather than a catalog of unrelated mechanisms and statements that they do not apply.

| File | Read when | Owns | Keep elsewhere |
| --- | --- | --- | --- |
| [settings.md](settings.md) | Preparing or changing shared Pi/MCP settings | All shared `settings.json` choices: interface/reporting, main model/thinking/scope, packages/built-ins, metadata; shared MCP/REA policy and rationale | Child-role details; palette design; model research instructions/results; action/change history |
| [agents-md/task-workspaces.md](agents-md/task-workspaces.md) | Understanding the fallback mechanism or maintaining the global rule and its rationale | Rationale and detailed contract for the `AGENTS.md` task-workspace rule: precedence, resolver, naming, continuity and limits | Child-role/provider/output wiring; transient validation reports; change history |
| [agents-md/documentation-and-comments.md](agents-md/documentation-and-comments.md) | Understanding or maintaining the subject-focused writing rule | Problem, audience, rationale, examples, legitimate procedures/history and primary-source guidance for comments and project documentation | Agent execution/progress reports; task-specific operator follow-ups |
| [agent/themes/README.md](../agent/themes/README.md) | Changing the selected theme or diagnosing colors | Palette motivation, color-role hierarchy and native/extension rendering boundaries | Shared settings values; layout and tool permissions |
| [pi-subagents.md](pi-subagents.md) | Configuring pi-subagents or selecting and using subagents | Subagent purpose, roles, delegation/use rules; pi-subagents configuration and runtime behavior, including model/thinking, context, skills/tools/providers, MCP access, handoffs and relevant validation | Shared Pi settings; reusable model-research method; cross-cutting working conventions not specific to subagents |
| [model-selection.md](model-selection.md) | Revisiting models/providers or creating a dated assessment | Abstract capability/depth profiles, source-based selection/refresh procedure, relative-consumption method, report contract and cross-harness practice evidence | Concrete settings; current model-comparison results |
| [models-YYYY-MM-DD.md](models-2026-10-17.md) | Comparing models using evidence available on that date | Public model capabilities, lifecycle, reasoning support, relative resource weights, abstract-profile fit and sources | Local configuration, role assignments, settings proposals, research methodology and process histories |

**Current assessment:** [models-2026-10-17.md](models-2026-10-17.md).

For each settings topic, keep the selected value/fragment, motivation, owning file/precedence, omission behavior, trade-offs and relevant functional checks together.

For a model refresh, follow the selection guide, produce the dated comparison, then put configuration decisions and motivation in the owning settings guides. Update current-assessment links together. Preserve older assessments as dated evidence rather than turning them into live configuration guides. Keep a fact or rule in its owner and link to it from other documents.
