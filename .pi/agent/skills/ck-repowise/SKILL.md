---
name: ck-repowise
description: Use for repository-wide architecture, dependency and change-impact context, historical decisions, index-backed health analysis, or Repowise setup and index maintenance.
---

# Repowise

Use the repository index for cross-file context; verify consequential conclusions against current source. AFT remains primary for locating symbols, reading source and editing. A known-file lookup or an unrelated question does not need an index query.

## Select the repository

1. Identify the actual target root. For Git projects, `git -C <directory> rev-parse --show-toplevel` identifies it without changing files. Use explicit absolute paths for CLI commands.
2. The global MCP registration runs `repowise mcp` without a fixed path. Its working directory is the Pi session directory; changing a shell command's working directory does not retarget the MCP process. From an indexed subdirectory, Repowise can find an enclosing `.repowise/`; otherwise it uses the session directory. Workspace discovery can also select an enclosing workspace.
3. Check that the tool's reported repository matches the target. If not, use an explicit repository selector only when its discovered schema supports it, or ask the parent/operator to start the relevant session at the target root. Keep the global registration project-independent.

## Discover and call tools

Use the installed `pi-mcp-adapter` gateway:

```text
mcp({ server: "repowise" })
mcp({ describe: "<returned tool name>", server: "repowise" })
mcp({ tool: "<returned tool name>", args: { /* discovered parameters */ } })
```

Server listing discovers the catalog; `describe` supplies the complete schema. Use returned names, not guessed prefixes or parameters. Choose only tools needed for the question: an overview for orientation, context/dependency/impact tools for a named change, or history/health tools for the corresponding evidence. A tool catalog is not proof that a usable index exists.

The shared configuration keeps tool schemas on demand through `mcp`; no direct-tool, codemode, project `.mcp.json`, or project instruction setup is needed. If the gateway/provider is absent or the server is blocked, report that capability gap to the parent rather than changing permissions or installing another integration.

## Missing or stale index

Index creation and refresh write repository-local data. Follow task authorization and role limits: the main agent or an authorized execution role can prepare an index during a task that permits those writes; read-only roles request preparation from the parent. A question-only task does not authorize initialization. Share the target root and required freshness in that request. Do not treat a no-index response as an empty repository or a successful analysis.

For an unindexed repository, run from its root (replace the path):

```bash
repowise init /absolute/repository --no-workspace --no-prose --no-editor-setup --yes
```

This builds the normal index and code-derived documentation without model calls. `--no-editor-setup` confines setup to `.repowise/`, avoiding project instructions, MCP files, editor integration and git/distill hooks; `--no-workspace` limits this invocation to the selected repository. Preserve any existing model-written documentation: if `.repowise/` already exists, inspect its state and use an appropriate refresh rather than blindly rerunning initialization with `--yes`.

Before refreshing an existing index, check these preconditions:

- Parsed `.repowise/config.yaml` explicitly sets `editor_setup: false`. Missing/true is not an opt-out: `--no-agents` suppresses only AGENTS generation, not other editor instructions; `REPOWISE_SKIP_EDITOR_SETUP=1` does not guard this update path.
- `hooks.coverage_reingest` is not enabled in that config, and `.claude/settings.local.json` has no Repowise `--coverage-only` hook entries. Update synchronizes these independently of `editor_setup` and can add/remove entries.

If either check fails or cannot be completed, report the constraint and request an operator decision before refreshing or changing existing preferences. With both checks satisfied and current changes needing representation, an authorized execution role can refresh facts, including uncommitted work, without model-generated documentation:

```bash
repowise update /absolute/repository --no-workspace --index-only --working-tree --no-agents
```

This is not a guarantee that prose documentation is current. Inspect reported stale/gap notices and distinguish refreshed facts from older generated explanations. Do not enable model-backed answers, embeddings or document generation that can spend external credits without authorization.

After a build or refresh, reconnect the session's server and repeat the relevant query:

```text
mcp({ connect: "repowise" })
```

This also replaces a server that started without an index and was serving an empty in-memory store. Other sessions have their own connections; the parent must reconnect its own server after a child prepares the shared index.

## Completion and limits

- Check command exit status and named gaps; initialization can finish with gaps instead of a fully ready index. Report failed preparation or unavailable capabilities explicitly and use current source inspection when the task can proceed without the index.
- Confirm the post-preparation query names the intended repository and returns relevant indexed facts before relying on it. A connected server alone is insufficient.
- Keep `.repowise/` as local generated data; this workflow does not require committing it or changing project ignore/configuration files. Do not commit generated data accidentally.
- Index results are evidence, not authority: stale data, incomplete extraction and heuristic findings must not be presented as confirmed source behavior. Preserve read-only role restrictions even though the common MCP gateway can reach other configured servers.
