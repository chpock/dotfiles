# Prepare the index needed by an analysis

Use this procedure when a selected analysis needs a missing or stale index. Reuse the CWD-specific Git proof and target root.

## Authority and prerequisites

The primary may prepare local `.repowise/` data for the selected analysis, including a read-only task. Perform the guarded preparation within that grant. Preserve source, editor instructions, hooks, project ignore files and existing analysis/provider preferences; keep generated data uncommitted. Obtain separate authorization for model/embedding use, coverage ingestion, analysis recomputation or decision/finding mutations.

Children query through their own connection. If an operation lacks required verification, preparation or refresh, send the primary a blocking supervisor request with the session CWD, target root, operation and required freshness. Wait for that dependency; continue unrelated work. The primary returns evidence of the requested readiness and its limits. Preserve the child's existing shell/write restrictions.

If not already loaded, read `references/querying.md` for target binding and query verification. Before running anything, distinguish the remedy:

- Missing index for supported analysis: initialize under the guards below.
- Existing index with relevant stale facts: inspect its state/configuration and safely refresh what the operation needs.
- Unsupported input/relation, excluded/unresolved target, absent coverage or unavailable stored-analysis block: identify that gap; do not repeatedly rebuild as a generic remedy.

## New index

For a genuinely unindexed repository, run from its verified root, with its explicit absolute path:

```bash
REPOWISE_SKIP_EDITOR_SETUP=1 repowise init /absolute/repository --no-workspace --no-prose --embedder mock --no-editor-setup --no-save-key --yes
```

If `.repowise/` already exists, inspect its state and use the refresh procedure. Preserve existing generated documentation; do not reinitialize an uncertain or partial index with `--yes`.

## Refresh an existing index

1. Read `.repowise/config.yaml` and the relevant environment controls. For names absent from the process environment, include nonempty values from `.repowise/.env`. Inspect credential presence without exposing or copying values.
2. Require explicit `editor_setup: false`. Require coverage re-ingest disabled in both `hooks.coverage_reingest` and `REPOWISE_HOOK_COVERAGE_REINGEST`, with no Repowise `--coverage-only` hook entries in `.claude/settings.local.json`.
3. Check embedding permission using the procedure below.
4. If any safeguard fails or remains unknown, report the freshness constraint and use current source where sufficient. Obtain an operator decision before changing preferences or adding model use. Otherwise run:

```bash
REPOWISE_SKIP_EDITOR_SETUP=1 repowise update /absolute/repository --no-workspace --index-only --working-tree --no-agents
```

### Check embedding permission

1. Use the repository config's `embedder` value, otherwise effective `REPOWISE_EMBEDDER`. A selected `mock` passes the embedding guard. For another explicit backend, check its authorization for the paths below.
2. With neither selection, resolve the fallback in order: Gemini (`GEMINI_API_KEY` or `GOOGLE_API_KEY`), OpenAI (`OPENAI_API_KEY`), OpenRouter (`OPENROUTER_API_KEY`), Ollama (`OLLAMA_EMBEDDING_MODEL`), EdenAI (`EDENAI_API_KEY`), then `embedder` in `~/.repowise/config.yaml`, then `mock`. Use the first nonempty environment signal; a keyed global backend needs a nonempty global `embedder_api_key`.
3. Check the backend for each applicable path:

   | Refresh path | Backend to check |
   | --- | --- |
   | Template-page rendering | Explicit repository/environment selection; otherwise keep inferred `mock` or `ollama`, and treat other inferred backends as `mock`. |
   | Configuration-driven vector rebuilding | Explicit repository/environment selection; otherwise the unfiltered fallback from step 2. |

4. When permission depends on which path will run, use the interpreter behind the installed `repowise` command for these read-only checks:
   - Apply `repowise.core.docs_mode.resolve_docs_mode` to saved `.repowise/state.json`; template rendering requires `deterministic`.
   - Apply `repowise.cli.commands.update_cmd.config_changes.classify_config_changes` to the verified repository root, saved state and parsed config; vector rebuilding requires `traversal_changed` or `generation_changed`.

   If applicability cannot be established, leave the embedding guard unresolved.
5. Proceed only when every applicable backend is `mock` or separately authorized.

## Reconnect and verify

1. Check the command's exit status and reported gaps. A successful exit may still report incomplete preparation.
2. In each session that will query the changed store, reconnect server `repowise` through the `mcp` gateway, then repeat that session's relevant query.
3. Confirm the intended repository and adequate freshness/coverage of the required facts. Report any remaining gap; do not infer current health, coverage or prose solely from a successful update or connection.
