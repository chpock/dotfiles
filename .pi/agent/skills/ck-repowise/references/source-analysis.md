# Use source-analysis evidence

## Match the input to the supported relation

| Input | Use and limit |
| --- | --- |
| Parsed source languages in the AGENTS.md loading list, except the import-only tier below | Extracted symbols and supported call/import/reference relations. Vue/Svelte/Astro/Razor support covers extracted code regions, not arbitrary template/markup behavior. Parsing does not guarantee complete dynamic dispatch or every health marker. |
| Clojure, Haskell, Lean, QML and Erlang | File/import relations only; ordinary symbols/calls are not extracted. |
| dbt SQL | Recognized `ref()`/`source()` wiring, not general SQL semantics or an SQL call graph. |
| Ansible YAML, HTML script/link targets and Godot resources | Dedicated literal wiring; use `cases/literal-references.md`, not general configuration/DOM analysis. |
| Markdown, Terraform/HCL, ordinary JSON/YAML/TOML and unsupported source dialects | No general program-symbol/call analysis. Use text inspection, explicit history or the separately supported literal-reference procedure for those questions. |

Use this profile instead of surveying parser capabilities during each task. If actual support contradicts it, identify the unsupported check and use current source; an index rebuild cannot add missing language semantics. Check the selected health detector's reported exclusions and provisional findings even for a parsed language.

## Establish uses and paths

1. Batch the known `get_context` targets and request the needed relationship. Callers, callees and live edit-site references require **symbol targets**, not file cards. For all symbols in a file, request `symbols`; the default card contains a ranked shortlist.
2. Read the actual definitions and consumers behind consequential edges. A `references` list marked complete covers its static extraction, exclusions and returned scope, not all dynamic/runtime users. Preserve old identities across moves; a target that no longer resolves is not evidence that it had no consumers.
3. To explain how two named nodes connect, use the opt-in `get_dependency_path` when exposed. It returns a directed structural path excluding temporal co-change edges; a no-path response may still suggest historically related files. Keep those suggestions separate from a dependency path.
4. To trace an entry point through callees, use the opt-in `get_execution_flows` when exposed. Its stored call-edge traversal is not observed runtime order or proof that every branch executes. Otherwise follow the needed callers/callees with `get_context` and current source.
5. For a module/component map, use its targeted context and structure/import views; use `get_overview` only for repository orientation. If the relevant path crosses repositories/services, continue with `references/workspace-analysis.md`.

## Assess file and change impact

- For prospective file impact, batch the planned files in `get_risk`. Request `graph` for consumer/dependent lists and relationship evidence; those lists are omitted by default. Request `churn` or `owners` only for the corresponding change-history/ownership question. Respect list totals, truncation and omissions; a short `impact_surface` is a ranked preview.
- For a real diff, supply `changed_files` to obtain the PR directive. `tests` and `blast` are changed-files-only additions, not missing data from a targets-only query. Investigate applicable `may_break` and `missing_cochanges` leads against the changed contract; neither establishes a defect by itself.
- For a whole commit/range or working-tree assessment, use `get_change_risk`. Read `directive` and `health_delta` before scores. Unknown status, a warning or an empty filtered scope does not establish a clean change. `risk_percentile` describes relative diff size/spread, not bug probability.

To interpret Repowise test-selection/coverage evidence or evaluate an assigned gate, follow `references/validation.md`. Returned recommendations do not authorize unrelated edits, new policies or broader analysis.
