# Maintaining ck-repowise

## Purpose and organization

`ck-repowise` adapts the official Repowise skills for Pi. Its procedures start from work the agent is already doing: investigate, change, review, recover rationale, improve quality or repair references. They teach a sequence of actions and how to follow the results, rather than requiring the agent to identify an analytical capability before receiving instructions.

[AGENTS.md](../../AGENTS.md) owns activation and CWD-specific Git verification. The advertised description is deliberately minimal: this setup already has an explicit loading rule, so a second purpose/trigger description would consume catalog context without controlling activation. `SKILL.md` chooses the procedure; it does not repeat the language list or Git check.

| File | Responsibility |
| --- | --- |
| [SKILL.md](SKILL.md) | Activity routing, AFT primacy, useful-query selection and conditional support pointers. |
| [cases/exploration.md](cases/exploration.md) | Locate the implementation, orient when needed, answer a focused question and follow ambiguous/failure evidence. |
| [cases/changes.md](cases/changes.md) | Establish prospective impact, inspect consumers and governing choices, then reconcile the actual change. |
| [cases/review.md](cases/review.md) | Assess the actual diff, drill into outside-diff risks and conclude from verified findings. |
| [cases/history-and-decisions.md](cases/history-and-decisions.md) | Recover original rationale and change history; reconcile or maintain decisions within task authority. |
| [cases/quality-and-cleanup.md](cases/quality-and-cleanup.md) | Choose concrete improvements, verify comparisons and investigate unused-code candidates before removal. |
| [cases/literal-references.md](cases/literal-references.md) | Find, verify, repair and recheck literal references without confusing resolution with prose meaning. |
| [references/source-analysis.md](references/source-analysis.md) | Input support, target granularity, graph traversal and risk-evidence limits. |
| [references/validation.md](references/validation.md) | Test-selection interpretation, coverage evidence and assigned quality/security/coverage gates. |
| [references/workspace-analysis.md](references/workspace-analysis.md) | Cross-repository/service contracts, member binding and available workspace analyses. |
| [references/querying.md](references/querying.md) | Selected-operation discovery, repository binding, authority and result handling. |
| [references/index-lifecycle.md](references/index-lifecycle.md) | Guarded preparation of the index needed by a selected analysis. |
| This README | Procedural provenance, rationale, integration ownership and upgrade evidence. |

Only `SKILL.md` has skill frontmatter. Cases and references are ordinary Markdown, reached through conditions rather than advertised separately. Instruction paths use `cases/...` and `references/...` relative to the skill directory. Runtime work does not require reading this README or the whole bundle.

Separate exploration, change and review procedures preserve the point at which guidance is needed. Shared technical interpretation belongs in references; test selection and workspace work have their own conditional files so an ordinary source lookup need not load them. Index preparation is an internal dependency of a useful analysis, not an invented top-level agent activity.

<a id="upstream-methods-retained-control-flow-replaced"></a>

## Official procedures are the foundation

The maintained bases are the six official skills at `~/.agents/skills/<name>/SKILL.md`, from `repowise-dev/repowise`, `plugins/codex/skills/<name>/SKILL.md`. They remain installed and unmodified. They are the starting procedures for this adaptation, not a capability checklist applied after designing unrelated workflows.

| Official skill | Procedural sequence retained locally |
| --- | --- |
| `codebase-exploration` | Distinguish an exact lookup from broad orientation; establish the relevant map, answer a focused question, follow ambiguity into target context and source. |
| `pre-modification-check` | Assess prospective impact before editing; examine consumers, repeated fixes, co-change and verification gaps; establish context before structural refactoring. |
| `change-review` | Assess the whole change when needed; drill into per-file directives; investigate the concrete consequences; write the review around evidence. |
| `architectural-decisions` | Find decisions for the question/area, inspect the governing record before changing a pattern, distinguish an audit from a scoped lookup, and record/review choices only within authority. |
| `code-health` | Choose dashboard versus target mode; start with fix priorities, open the concrete finding/recipe, interpret the underlying problems and compare valid before/after evidence. |
| `dead-code-cleanup` | Find scoped candidates, distinguish confidence from verification, inspect dynamic consumers and recent activity, then remove verified code in a conservative order. |

Literal-reference work supplements these bases using the installed analyzer's actual scope. Recent-regression, performance, workspace and validation branches extend an existing agent task; a new tool does not automatically become another user workflow.

### Adaptations to the local contract

- AFT remains primary for current-source lookup, reading and editing. Repowise supplies supported analytical evidence that is missing or materially simpler to obtain through it. Existing sufficient evidence is reused, so a self-contained task may finish without a query.
- The official sequences do not become mandatory query chains. A focused review need not score a whole change; an overall result can already answer the per-file/test question. Follow-up is driven by the actual result and remaining task, not every suggested action.
- Confidence, `safe_to_delete`, scores and inferred edges are not proof. Source verification and project approval/testing rules remain authoritative. Incomplete test selection does not silently redefine those rules.
- Global approval rules control architecture and decision mutations. An authorized cleanup does not need fresh permission for every verified deletion; an analysis request does not authorize accepting decisions or suppressing findings.
- Model/embedding use requires its own authorization. A configured provider, an available tool or a stored vector index does not supply that permission.
- Codex `/prompts:` setup/fallbacks and automatic editor/hook changes are replaced with the Pi gateway, selected CLI methods and guarded local preparation.
- Installed-version differences override stale upstream field assumptions. In particular, `get_risk` consumer lists require `graph`; churn/owner detail is opt-in, while tests/blast additions require changed-files mode.

## Writing and disclosure

The [Agent Skills specification](https://github.com/agentskills/agentskills/blob/main/docs/specification.mdx) permits arbitrary support directories and unrestricted Markdown bodies. Its [authoring guidance](https://github.com/agentskills/agentskills/blob/main/docs/skill-creation/best-practices.mdx) favors domain-specific procedures, clear defaults and conditional disclosure. Format validity alone does not establish that a procedure helps an agent perform its task.

Runtime sentences should change what the agent does, how it interprets a result or when it stops. Design explanation belongs here. Preserve an ordered method and a concrete completion condition in each case; a table of possible checks is not a replacement for the method. Keep a fact with the action it governs and give shared rules one owner.

Selected MCP schemas and CLI help supply ordinary syntax, defaults and accepted arguments. Generic call templates would duplicate that source. Retain non-obvious selection semantics in the procedure, such as prospective versus changed-files risk. A short worked decision/example remains appropriate if it teaches something that the schema and procedure do not.

Exact index commands are retained because their combined flags implement a safety grant rather than illustrate an API. Detailed controls belong with those commands. No configuration evaluation scripts, SDK probes or model-backed test scenarios are introduced; the local [configuration maintenance policy](../../../docs/settings.md#configuration-maintenance-policy) prohibits them. Static inspection of these documents does not demonstrate runtime effectiveness.

## Capability coverage

The source profile was reconciled with Repowise **0.60.1**: 18 MCP operations and 59 CLI registrations. This inventory is for maintaining the adaptation, not a runtime checklist.

| MCP operations | Place in the procedures |
| --- | --- |
| `get_overview`, `search_codebase`, `get_answer`, `get_symbol` | Orientation, concept discovery, focused explanations and following returned source identifiers in exploration. |
| `get_context` | Target context, uses, decisions, changes/suspects, ownership/provenance and literal reverse references in the relevant case. |
| `get_risk`, `get_change_risk` | Prospective impact, actual-change triage, consumer/co-change/fix-history leads, health delta and test-selection evidence. |
| `get_why` | Scoped rationale, original decision evidence and assigned decision audits. |
| `get_health` | Priorities, findings/recipes, performance hypotheses, coverage/trends, comparisons and literal drift. |
| `get_dead_code` | Scoped unused-code hypotheses and removal investigation. |
| `get_dependency_path`, `get_execution_flows` | Optional structural paths/entry-flow traversal when those questions need them. |
| `list_repos`, `get_architecture`, `get_blast_radius`, `get_conformance` | Existing workspace membership and task-relevant cross-repository coupling, downstream effects or rule checks. |
| `generate_refactoring_code`, `set_finding_status` | Separately authorized optional model-assisted patches and stored refactoring-plan dispositions. |

The seven specialist operations are opt-in. Architecture, blast-radius and conformance also require workspace mode. Repository-level tool configuration can alter exposure, so the global registration alone does not prove permanent unavailability. The procedures use the actual selected surface without enabling tools or changing permissions. The local index grant excludes workspace creation/rebuilding.

CLI coverage is grouped by contribution, not translated into one instruction per command:

1. **Analysis adapters:** `dead-code`, `doc-drift`, `health`, `risk`, `search`, `ask`, `context`, `symbol`, `why`. Their evidence is covered by the corresponding MCP method or selected CLI fallback.
2. **Additional evidence/delivery:** `overlap`, `decision`, `coverage`, `components`, `packages`, `pages`, `changes`, `suspects`, `check`, `ci-summary`, `events`, `report`, `impacted-tests`, `security`, `next`, `export`. These provide scoped history/context, optional reports, project gates or detailed test selection within the existing tasks. Many stored views already surface in core MCP responses; an extra CLI call is not required to duplicate them. Read-only change reports use `--no-build`.
3. **Administration:** `augment`, `init`, `delete`, `generate-claude-md`, `update`, `generate`, `hook`, `agents`, `uninstall`, `status`, `doctor`, `grammars`, `watch`, `serve`, `mcp`, `reindex`, `restyle`, `wiki-styles`, `whats-new`, `telemetry`, `config`, `publish`, `login`, `logout`, `whoami`, `workspace`, `plugins`. Only the guarded local init/update dependency has standing authorization here. Ordinary code work does not invent installation, publication, editor setup or workspace administration tasks.
4. **Execution/integration telemetry:** `costs`, `distill`, `expand`, `saved`, `savings`, `corrections`, `attribution`. AFT/native Pi owns ordinary command/source output; provenance has a targeted context view. The `corrections` command reads Claude Code transcripts, not Pi task failures. Integration investigations use their own authorized scope rather than becoming steps in every code task.

## Integration mechanics behind the safeguards

- The global MCP registration starts `repowise mcp` in the Pi session CWD without pinning a repository. It may select an enclosing indexed repository/workspace. A shell CWD change does not retarget that process; binding and returned identity must match the intended member.
- Gateway `describe` supplies the selected description/input schema. Large results can be saved behind a preview, so the query procedure requires recovering needed omitted details instead of treating the preview as complete.
- CLI startup can migrate global editor files before command-specific flags apply. `REPOWISE_SKIP_EDITOR_SETUP=1` therefore guards every invocation, including help. Update's project editor setup separately requires `editor_setup: false`; neither the environment guard nor `--no-agents` substitutes for that check.
- Update synchronizes coverage-hook entries independently of editor setup, including removal when re-ingest is disabled. Both enablement controls and existing hook entries must be checked to preserve hooks.
- Template rendering and configuration-driven vector rebuilding choose embedding backends differently. The preflight checks applicable paths using installed read-only state/config classifiers rather than copying their fingerprint algorithm. Helper imports use the interpreter behind the installed launcher, which may differ from the default Python environment. Reinitializing an uncertain store can overwrite model-written pages.
- MCP connections are session-local and can retain an empty in-memory store after starting without an index. Each querying session reconnects after preparation. Successful reconnect/update does not establish that all stored analyses were recomputed.

## Configuration ownership

- [Main skill discovery](../../../docs/settings.md#main-skill-discovery) owns the six exact vendor-resource exclusions. These are catalog selections, not vendor deletion or MCP restrictions.
- [Subagent skill catalogs](../../../docs/pi-subagents.md#skills) select `ck-repowise` rather than the vendor procedures. Cases remain available within each assignment without widening tools or authority.
- [MCP routing](../../../docs/settings.md#repowise-registration-and-routing) owns the gateway, CWD-based registration and startup guard. This skill adds no extension, hook or project setup.

Native project/launch overrides and retained context keep their own scope. Global exclusions do not suppress every same-name project copy. A fresh session or `/reload` after active work finishes adopts catalog/configuration changes; static inspection is not proof of live activation.

## Source contract and upgrades

Paths below are relative to the installed Repowise package, locally `/usr/lib/repowise/lib/python3.14/site-packages/repowise`:

- `server/mcp_server/__init__.py`, `cli/main.py`, `core/registry/tool_selection.py`: operation inventory, CLI registrations and effective exposure.
- `core/ingestion/language_configs.py`, `core/ingestion/parser/`, `core/ingestion/lightweight_imports/__init__.py`, `core/ingestion/languages/specs/{markdown,terraform}.py`: parsed/import-only/passthrough support and embedded-code boundaries.
- `server/mcp_server/tool_context/{context,enrichment,doc_mentions}.py`, `server/mcp_server/tool_risk/get_risk.py`, `server/mcp_server/tool_change_risk/tool.py`: target views, opt-in blocks, directives, actual-change scope and evidence limits.
- `server/mcp_server/tool_search/{tool,retrieval}.py`, `server/mcp_server/tool_answer/answer.py`, `server/mcp_server/tool_why/{tool,search,path_mode}.py`: retrieval, synthesis and query-embedding paths.
- `server/mcp_server/{tool_dependency,tool_flows,tool_architecture,tool_blast_radius,tool_conformance}.py`: structural traversal and workspace analyses.
- `server/mcp_server/tool_health/{tool,request}.py`, `server/mcp_server/{tool_dead_code,tool_refactoring,tool_findings}.py`: stored health, recipes, performance, unused-code hypotheses and optional plan operations.
- `core/analysis/doc_drift/{constants,extractor,resolver,analyzer}.py`: literal-reference coverage, renderer semantics and exclusions.
- `cli/commands/{check_cmd,coverage_check_cmd,security_cmd,impacted_tests_cmd,decision_cmd,report_changes_cmd}.py`, `cli/commands/health_cmd/{command,check}.py`: gates, test selection, stored-analysis writes and report/decision side effects.
- `cli/self_heal.py`, `cli/commands/init_cmd/{command,_prepare,_finish,_generate}.py`, `cli/providers/embedders.py`: startup guard and guarded model-free initialization.
- `cli/commands/update_cmd/{command,config_changes,deterministic,incremental}.py`, `core/{docs_mode,repo_config}.py`, `cli/providers/embedders.py`, `core/providers/{embedding/resolve,llm/specs}.py`: refresh paths and embedding selection.
- `cli/ui/env_persistence.py`, `cli/commands/augment_cmd/{_shared,coverage_reingest}.py`, `cli/editor_setup.py`: environment loading, editor opt-out and independent hook synchronization.

Native loading references: Pi **1.5.2** `docs/{skills,settings,packages}.md`, `dist/core/{package-manager,resource-loader,skills}.js`, and pi-subagents **0.88.1** `src/agents/skills.js`. Gateway metadata references in `pi-mcp-adapter`: `index.ts`, `tool-metadata.ts` and `proxy-modes.ts`.

When updating this adaptation, start from the affected official procedure, reconcile current source/schema behavior and preserve its useful action/result sequence. Inspect new capabilities for a real contribution to an existing task; do not auto-import upstream workflows or add runtime version/capability surveys. Update the support/side-effect profile and its owning file, then inspect the final instructions, links and authority boundaries. Keep unresolved execution evidence explicit.
