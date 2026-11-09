# Local Pi settings

This guide describes the selected shared Pi configuration: values, motivation, effects and behavior when omitted. It is a configuration reference, not a change log or deployment audit.

Scope: shared `settings.json` choices, package selection and MCP settings. [pi-subagents.md](pi-subagents.md) owns child-role settings and their rationale. Model evidence is in the [2026-10-17 assessment](models-2026-10-17.md); the [selection guide](model-selection.md) owns the reusable research method. See [CONTEXT.md](CONTEXT.md) for document boundaries.

## Configuration ownership

| File | Responsibility |
| --- | --- |
| [`~/.pi/agent/settings.json`](../agent/settings.json) | Shared model defaults/scope, interface, reporting, packages and built-in selection. The `subagents` subtree is owned by [pi-subagents.md](pi-subagents.md). |
| [`~/.pi/agent/themes/README.md`](../agent/themes/README.md) | Theme selection rationale, color-role design and renderer boundaries. |
| `~/.pi/agent/mcp.json` | Repowise server registration: transport, command and arguments. |
| `~/.pi/agent/mcp-adapter.json` | Adapter exposure and installation policy. It augments the registration rather than copying its command. |

The MCP sections specify the official `npm:pi-mcp-adapter` setup with the schema-discovery behavior below. MCP platform examples use Pi **1.2.0**; model-setting semantics follow Pi **1.3.0**. These versions identify the source contracts used, not an audit of deployed packages.

These are user-level defaults. The adapter also reads shared MCP files and project configuration. The global adapter overlay takes precedence over the global Pi MCP registration; project files can override user-level configuration, and per-server settings can override global adapter defaults. Inspect the effective configuration in the actual working directory when diagnosing a difference; see the adapter's [precedence reference](https://github.com/nicobailon/pi-mcp-adapter/blob/main/docs/configuration.md#precedence).

## Settings metadata

| Setting | Why and effect | If omitted |
| --- | --- | --- |
| `$schema: "https://pi.dev/schemas/settings.schema.json"` | Validates recognized settings values and offers editor completion. Unknown top-level keys remain allowed, so the schema does not catch every misspelled field. Extension-specific contracts still need their own documentation. | No schema association from this file; Pi can still load settings. |
| `lastChangelogVersion` | Pi-managed marker of the changelog version already shown/handled. Keep it as application state rather than pinning a version in setup examples. | Pi has no stored acknowledgement marker; changelog behavior follows its startup/update logic. This is not an update-channel or version pin. |

## Interface and terminal

Selected merge fragment for `~/.pi/agent/settings.json`:

```json
{
  "theme": "gruvbox-dark-hard",
  "tuiMode": "fullscreen",
  "fullscreenExitOutput": "resume-hint",
  "quietStartup": true,
  "hideThinkingBlock": false,
  "editorPaddingX": 1,
  "outputPad": 1,
  "terminal": { "showTerminalProgress": false }
}
```

| Setting | Why and effect | If omitted |
| --- | --- | --- |
| `theme: "gruvbox-dark-hard"` | Uses the selected custom theme. Palette motivation and effective foreground/background behavior belong in the [theme README](../agent/themes/README.md), not a second palette description here. | Pi uses `system`, adapting to terminal colors. |
| `tuiMode: "fullscreen"` | Preferred richer terminal UI for normal agent work, rather than the regular scrollback-oriented mode. This is a UI preference, not a model-quality setting. | Pi already defaults to fullscreen; keep the preference explicit. |
| `fullscreenExitOutput: "resume-hint"` | Leaves only the resume command for a saved session instead of replaying the conversation and UI on fullscreen exit. Avoids clutter and the exit-width interaction with Herdr described [below](#fullscreen-exit-output). Session persistence is unchanged. | Defaults to `"transcript"`: re-renders the transcript, editor, widgets and footer into the terminal's ordinary scrollback on fullscreen exit. |
| `quietStartup: true` | Removes visual clutter: hides the startup header and loaded-resource listing. | Defaults to false; startup information is displayed. |
| `hideThinkingBlock: false` | Shows the thinking content supplied by the provider, giving more detail about the agent's work. It does not expose unreturned private reasoning or increase model effort. | Already defaults to false; keep the visibility choice explicit. |
| `editorPaddingX: 1` | Gives input a one-cell horizontal margin instead of placing it flush against its edges. | Defaults to zero; the allowed range is 0–3 cells. |
| `outputPad: 1` | Keeps the transcript's one-cell horizontal margin for readable message/tool output, consistent with the input margin. | Already defaults to one; keep the layout choice explicit. |
| `terminal.showTerminalProgress: false` | Terminal-tab/window progress is not needed: the operator does not use terminals with this indicator. Keep OSC 9;4 activity reporting disabled. | Already defaults to false; keep the preference explicit. |

One-off mini chat can deliberately use regular mode; the package list below explains that separate opt-in interface.

### Fullscreen exit output

`fullscreenExitOutput: "resume-hint"` keeps exiting Pi quiet: the conversation, empty editor and status/footer are not printed again into the terminal. Pi returns to the ordinary terminal screen and prints a command to resume the session when a saved session file is available. This setting controls exit presentation, not saving: existing session history remains available, while a non-persistent session may have no resume hint. It does not change regular-mode output.

The default `"transcript"` replays the mounted UI after leaving the alternate screen. In Herdr 0.9.3, the ordinary screen reserves one column for the pane scrollbar, whereas the alternate screen uses that column too. A fullscreen exit can therefore put output rendered for 186 columns into a 185-column primary screen. Full-width borders and trailing padding wrap; a padding-only continuation looks like an extra blank line. Suppressing the replay avoids this interaction without changing Herdr's geometry policy.

Relevant upstream context:

- [Herdr PR #4016 — restore alternate-screen pane width](https://github.com/herdrdev/herdr/pull/4016) explicitly restores the extra terminal column on alternate-screen entry and the scrollbar gutter on exit; the geometry difference is intentional.
- [Herdr issue #5286 — one-column width oscillation with pane scrollbars](https://github.com/herdrdev/herdr/issues/5286) reports related scrollbar/PTY resizing behavior on 0.9.3 and 0.9.5. Its trigger is window resizing, not Pi's exit replay, so it is not an exact duplicate of this failure.
- [Herdr issue #1 — Pi footer cut off by one character](https://github.com/herdrdev/herdr/issues/1) documents an earlier scrollbar-related Pi rendering problem. Its closure does not establish that the exit-replay interaction is fixed.

## Reporting and warnings

```json
{
  "enableInstallTelemetry": false,
  "enableAnalytics": false,
  "warnings": { "anthropicExtraUsage": true }
}
```

| Setting | Why and effect | If omitted |
| --- | --- | --- |
| `enableInstallTelemetry: false` | Avoids unnecessary install/update reporting requests and associated reporting work. Also disables the selected provider-attribution headers controlled by this setting. | Defaults to true. This switch does not control update checks. |
| `enableAnalytics: false` | Avoids analytics requests/work that provide no benefit to this setup. This is a preference to avoid needless overhead, not a measured latency claim. | Already defaults to false; the explicit value records the no-analytics policy. Pi 1.3.0 currently uses this opt-in only in experimental first-run setup. |
| `warnings.anthropicExtraUsage: true` | Keeps a useful warning about possible paid extra usage when using Anthropic subscription authentication, including if that provider is selected later. | Already defaults to true; retain the protective warning explicitly. It warns rather than blocking charges. |

These are Pi switches, not a global network block: provider calls, update checks and extension-owned network behavior have their own controls.

## Default model and thinking

Selected main-agent baseline, as a merge fragment for `~/.pi/agent/settings.json`:

```json
{
  "defaultProvider": "openai-codex",
  "defaultModel": "gpt-6.1-sol",
  "defaultThinkingLevel": "xhigh"
}
```

| Setting | Why and effect | If omitted |
| --- | --- | --- |
| `defaultProvider: "openai-codex"` | Uses the ChatGPT-sign-in provider as the startup preference, matching the subscription access path. Provider identity matters: an API-key model with the same bare ID is a different connection/accounting path. | Pi chooses a provider automatically when no stronger selection exists. |
| `defaultModel: "gpt-6.1-sol"` | Selects a General-capability model for complex work with lower credit weights than Astra. The [model comparison](models-2026-10-17.md#task-specific-capabilities) supplies the supporting evidence. | Pi chooses a model automatically when no stronger selection exists. |
| `defaultThinkingLevel: "xhigh"` | Increases main-session reasoning depth because ordinary Sol/high use produced unacceptable gross errors. The [2026-10-31 decision](model-decisions.md#2026-10-31--more-reasoning-for-execution-sol-for-routine-review) records the practical basis and accepted limits. This is a supported effort, not a fixed token budget or quota multiplier. | A per-model startup setting can apply; otherwise Pi's builtin default is `medium`, subject to model support and stronger session/launch selection. |

These are startup defaults, not a mechanism that overwrites every active session: CLI/explicit selection, project settings, per-model thinking and restored session state can matter. The design assumes the main agent uses the selected defaults; no live tracking of temporary session changes is required.

The [worker/delegate/reviewer settings](pi-subagents.md#worker-delegate-and-reviewer-settings) pin worker and delegate to Luna/max for bounded execution; reviewer inherits the active main model with fixed max thinking. Keep their values and merge fragment in that guide. Switching the main model does not switch the pinned executors. Review affected role choices and supported efforts when changing the shared defaults or task boundaries.

### Provider compatibility

For the selected OpenAI Codex connection, Pi 1.3.0's bundled metadata declares a **500,000-token context** for Sol 6.1 and **272,000** for Astra/Sol/Luna and the 5.6 models, with **128,000** maximum output. These client declarations differ from the [published API contract](models-2026-10-17.md#model-interface-and-reasoning-support); an API specification alone does not expand the client's budget. Treat the client declaration and provider contract as separate limits, not proof of an adapter defect or account entitlement.

The provider uses `openai-codex-responses`; product access still depends on the account/workspace. Consult the [selection guide](model-selection.md#refresh-workflow) when changing model/provider. Local catalog presence alone is not access evidence.

## Model selection scope

`enabledModels` is an explicit working selection, not the complete catalog:

- `openai-codex`: the four OpenAI models selected for use, with the main default and child assignments documented in their owning sections.
- `opencode-go`: **only `deepseek-v4.1-flash`**. The operator does not intend to use the other models from this provider. In the [Go-plan usage-limits table](https://opencode.ai/v2/docs/console/go/#usage-limits), checked **2026-11-04**, DeepSeek V4.1 Flash is the only model listed with a **$100 Monthly limit**, for both Peak and Off-Peak usage. This is the Go plan, not Go Plus or Go Teams. The [decision journal](model-decisions.md#2026-11-04--deepseek-flash-only-for-opencode-go) records the replacement of the former $60-based selection.
- `github-copilot` and `anthropic`: Claude Opus/Sonnet/Haiku 5.5 through each provider. As of **2026-11-04**, these are selected as the latest generation in each retained class with favorable published pricing relative to preceding same-class versions. The [Claude 5.5 decision](model-decisions.md#2026-11-04--claude-55-for-anthropic-and-copilot) records the comparison, including Sonnet's lower cache-read rate rather than lower base input/output prices versus Sonnet 5. These are distinct connection/authentication paths, not interchangeable model IDs or identical subscription accounting.

Selected merge fragment:

```json
{
  "enabledModels": [
    "openai-codex/gpt-6-astra",
    "openai-codex/gpt-6-sol",
    "openai-codex/gpt-6-luna",
    "openai-codex/gpt-6.1-sol",
    "github-copilot/claude-opus-5.5",
    "github-copilot/claude-sonnet-5.5",
    "github-copilot/claude-haiku-5.5",
    "anthropic/claude-opus-5-5",
    "anthropic/claude-sonnet-5-5",
    "anthropic/claude-haiku-5-5",
    "opencode-go/deepseek-v4.1-flash"
  ]
}
```

This is an explicit model choice, not a rule to add every future model with the same allowance. Recheck the plan/limit when changing this list; the dollar amount is the provider's allowance unit, not the subscription price, a locally configured spending cap or an OpenAI API-price comparison. It does not establish equal token rates or request capacity across models.

Pi uses `enabledModels` for startup selection and model cycling; `/model` can switch between scoped and all available models. Explicit model selection, launch overrides and child settings are not a provider-side spending barrier. Without a nonempty scope, cycling can use all available models. Likewise, OpenCode's separate **Extra Usage** console option can permit pay-as-you-go fallback after an allowance is exhausted; this file neither enables nor disables it.

## Package selection

`packages` chooses resources to load for normal Pi sessions. Keep these sources in the merged array; the MCP subsection owns its adapter entry and exclusions. Removing a declaration stops loading resources through that declaration, not through every possible independent discovery path.

| Selected source | Motivation |
| --- | --- |
| `npm:@cortexkit/pi-magic-context` | Long-lived conversation/context management, retrievable history and project memory instead of repeatedly reconstructing old decisions. Its background-agent and retention settings live in the separate CortexKit configuration. |
| `npm:@cortexkit/aft-pi` | Indexed/structural source navigation, guarded file operations and managed shell execution. Reuse one tool integration rather than reconstructing these operations with shell commands. AFT's own switches live outside this file. |
| `npm:pi-hide-providers` | Hide unwanted providers/models from discovery lists, reducing selection noise beyond the working scope. Its blocklist is separate from `enabledModels`; it wraps model-runtime accessors rather than providing a billing limit. |
| `npm:pi-web-access` | Dedicated source-linked web search and content retrieval for current external evidence. Its routing/browser/privacy controls are in `web-search.json`. |
| `npm:@juicesharp/rpiv-ask-user-question` | Structured operator decisions with selectable choices and artifact previews rather than ambiguous free-form questionnaires. |
| `npm:pi-context-view` | Inspect what occupies context and which instructions/tool definitions extensions inject; useful for diagnosing context overhead instead of inferring it from the visible transcript. |
| `/w/projects/pi-toolview` | Load the maintained local tool-card/editor/footer presentation package directly, keeping tool output compact and navigable. |
| `npm:pi-subagents` | Native specialist/implementation/review delegation with parent-owned decisions and acceptance. Models, permissions and role rationale belong in [pi-subagents.md](pi-subagents.md). |
| `npm:pi-mini` | An opt-in low-clutter chat for quick terminal questions. It activates only with `--tui-mini` in terminal UI mode; merely loading it does not replace the normal fullscreen setup or disable session saving. |
| `npm:pi-mcp-adapter` | On-demand MCP discovery through one proxy, without eager catalogs or script tools; the design and parameters are [below](#mcp-access). |

Relative local sources resolve from the settings file; npm entries load managed installed packages. A local source loads from its directory without copying and therefore depends on that checkout being present. The selected adapter source is the official npm package, as specified by the MCP design. Removing every package would also remove these extensions' features unless loaded by another route; native built-ins and user-extension discovery remain independent.

## Child settings ownership

The `subagents` subtree is covered by [pi-subagents.md](pi-subagents.md): `defaultExtensions`, `defaultSubagentOnlyExtensions`, disabled external profiles, every selected role's `model`/`thinking`, instruction and skill inheritance, `skills`, `tools`, and role-specific provider overrides. Keep those values and their motivation there rather than maintaining a second child configuration here.

Other extension files such as `web-search.json`, CortexKit JSONC and UI overlays are separate configuration topics. This guide's `settings.json` coverage does not imply those files have been documented.

## Main skill discovery

Pi discovers user skills in `~/.pi/agent/skills/` and `~/.agents/skills/`, alongside selected package skills. The shared settings use native discovery without a top-level `skills` filter; each skill's frontmatter controls whether it is advertised for automatic selection.

The catalog includes `codebase-design`, the `ck-repowise` integration skill and the six [upstream Repowise workflow skills](pi-subagents.md#upstream-repowise-skills). Pi advertises each skill's name, description and path; the main agent decides when to read and apply matching procedures, without an operator reminder or forced invocation. Before Repowise workflow/tool use, the shared instruction pointer selects `ck-repowise` for Pi-specific boundaries. Selection remains model behavior rather than guaranteed programmatic routing.

Child catalogs are configured separately by the [subagent skill assignments](pi-subagents.md#skills). A child's explicit selection can differ from the main catalog, and a direct file read can reach a shared skill. Project/launch overrides and forked context retain their documented scope. Catalog selection is not a filesystem access restriction or removal of an MCP server.

## MCP access

### Goal and chosen design

- Keep `codemode` unavailable, not merely discourage its use.
- Discover configured server catalogs on demand without declaring every tool schema in ordinary model requests.
- Use the official adapter with one common **`mcp` proxy** for search, description, and execution.

Server access is independent of skill-catalog selection: the registration, adapter and role tool grants determine availability. Ordinary source-code navigation does not require Repowise; AFT remains primary for current-source location and inspection.

### Pi package and built-ins

Relevant fragment of `~/.pi/agent/settings.json`:

```json
{
  "packages": ["npm:pi-mcp-adapter"],
  "extensions": ["-builtin:mcp", "-builtin:codemode"]
}
```

Merge this fragment into the existing lists; it is not a replacement configuration.

| Setting | Why and effect | If omitted |
| --- | --- | --- |
| `packages` includes `npm:pi-mcp-adapter` | Loads the installed adapter in normal Pi sessions. | This package no longer supplies the `mcp` proxy. |
| `extensions` includes `-builtin:mcp` | Explicitly selects the adapter as the MCP owner. | Pi still suppresses its conflicting built-in when the adapter registers `/mcp`, but warns that it was not loaded. The adapter normally adds the disable entry itself. Do not depend on that automatic settings write. |
| `extensions` includes `-builtin:codemode` | Prevents the built-in from loading, even if another feature would otherwise activate it. | Codemode remains eligible for activation; disabling native MCP alone does not disable codemode. |

`autoEnableCodemode: false` only controls automatic activation by native MCP. It is not the solution here: native MCP is disabled, and codemode itself must not load. Native `exposure: "deferred"` and `tool_search` are not needed for this proxy-only design.

### Repowise registration and routing

The global `~/.pi/agent/mcp.json` registers the installed `repowise` executable with `args: ["mcp"]`, without a fixed repository argument or `cwd`. The adapter passes the session working directory to the stdio process. Repowise uses that directory or discovers an enclosing indexed repository/workspace; start the relevant Pi session at the target root and confirm the reported repository before querying. Project settings can still override this registration.

The global `AGENTS.md` pointer and the [ck-repowise skill](../agent/skills/ck-repowise/SKILL.md) own on-demand integration and index preparation; the official skills own task-specific analysis methods. This avoids project-local MCP and instruction files; native index data still lives in `.repowise/`. MCP does not automatically create a missing index. Preparation/refresh follows the task's write authorization and actual tool availability. The registration does not configure a model provider, but `get_answer` can autodetect existing credentials and invoke synthesis; index `--no-prose` is not a no-spend guarantee for later queries. Follow the integration skill's model-call approval boundary.

Repowise keeps the adapter's default lazy lifecycle: it can disconnect after idleness and reopen the on-disk index on demand. The skill owns index freshness and session-reconnection checks. Keep the server command in `mcp.json`, rather than duplicating it in the adapter overlay.

### Adapter policy

`~/.pi/agent/mcp-adapter.json`:

```json
{
  "settings": {
    "directTools": false,
    "namespaceProxyTools": false,
    "allowInstall": false
  }
}
```

| Setting | Why and effect | If omitted |
| --- | --- | --- |
| `directTools: false` | Keeps calls behind `mcp`; individual MCP tools are not registered as direct model tools. | Already defaults to false; the explicit value records the proxy-only policy. A per-server or higher-precedence override can still change exposure. |
| `namespaceProxyTools: false` | Omits redundant server-specific proxies. | Defaults to true, adding a separate proxy for each enabled server. |
| `allowInstall: false` | Refuses `mcp` requests with `action: "install"`; configured-server discovery and calls remain available. | Defaults to true, allowing additional server registrations through the proxy. This setting is not an OS-level installation ban. |

Lazy loading is not a promise of zero startup work: missing or invalid cached metadata can trigger a discovery connection. Metadata stored on disk is distinct from tool schemas declared to the model. `/reload` and session replacement recreate server connections; an on-disk repository index is independent of those connections.

### Parameter discovery and large responses

Search is a compact summary, not a complete parameter contract. Before constructing a request with unfamiliar parameters, use the selected tool's `describe` result:

```javascript
mcp({ server: "repowise" })
mcp({ describe: "<returned tool name>", server: "repowise" })
```

- Plain structural schemas stay compact.
- If compact rendering fails or would omit schema information, `describe` returns the original input JSON Schema, including referenced definitions, nested variants, descriptions, integer semantics, bounds, and defaults when present in the schema. Search supplies the scoped describe route without expanding every result into a full schema.
- References are preserved, not expanded or fetched. Local definitions remain available in the returned schema; external references still require their external schemas.
- The existing output guard bounds oversized descriptions and saves the complete text to the indicated file. Read that file when the inline preview omits needed fields. No extra exposure setting, direct tools, or script tool is required. Spill files may contain sensitive output and are not automatically cleaned up.

This is the supported discovery path, not a requirement to infer missing parameters from skill examples or implementation source.

### Access and approval boundaries

The common proxy reaches all enabled, permitted servers in the merged adapter configuration. Tool filters and approval policy still apply; choosing a server in a request is routing, not a security boundary.

Pi's outer tool event is named `mcp`, with the selected operation in its arguments. A permission or audit rule matching a direct MCP tool name does not automatically govern the proxied call. The adapter provides its own approval controls; this setup neither adds nor waives a separate per-tool approval policy.

### Applying and validating changes

After relevant configuration or package changes:

1. Reload each affected Pi instance after important foreground and background work has finished, or start a fresh session. `/reload` replaces extension state and server connections.
2. Inspect the effective server configuration and actual initial tool declarations: one `mcp` proxy, no `codemode`, script tools, server-specific proxies, or eagerly declared server catalog. Targeted discovery should not promote the catalog into direct tools.
3. Check model-visible `describe` output for both referenced/nested schemas and numerical constraints or annotations. Compare with the server's input schema; hidden metadata or a successful call with pre-known arguments is not sufficient evidence of usable discovery.
4. For changes affecting server calls or repository routing, query a known indexed repository and confirm that the reported repository and returned facts match the target. Follow the [skill's freshness and preparation checks](../agent/skills/ck-repowise/SKILL.md); unavailable indexes are a capability gap, not successful analysis.

Scope validation to what changed. Configuration removal needs effective-loader and discovery checks; it does not require rebuilding an unrelated repository index.

## References

- Shared settings/omission behavior and models: Pi 1.3.0 `docs/{settings,configuration,models,packages,themes}.md` under `~/.pi/agent/install/releases/1.3.0/node_modules/@earendil-works/pi-coding-agent/`.
- Scope and metadata semantics: that release's `dist/{main.js,core/{settings-manager,settings-schema,agent-session}.js,modes/interactive/{interactive-mode.js,components/model-selector.js}}`.
- Go allowance rationale and fallback behavior: [OpenCode Go usage limits](https://opencode.ai/v2/docs/console/go/#usage-limits), Go tab, checked 2026-11-04; [usage beyond limits](https://opencode.ai/v2/docs/console/go/#usage-beyond-limits).
- Package capabilities: installed package READMEs under `~/.pi/agent/npm/node_modules/` and the [local toolview README](../../../../w/projects/pi-toolview/README.md). Theme design and renderer references: [themes/README.md](../agent/themes/README.md).
- MCP setup: `docs/settings.md`, `docs/packages.md`, `docs/mcp.md`, and `docs/extensions.md` under the Pi 1.2.0 release's `@earendil-works/pi-coding-agent/` directory.
- [Current model evidence](models-2026-10-17.md); [child configuration](pi-subagents.md); [model-selection method](model-selection.md).
- Client declarations and transport: Pi 1.3.0 bundled `@earendil-works/pi-ai/dist/providers/{data/openai-codex.json,openai-codex.js}`.
- Adapter: [configuration](https://github.com/nicobailon/pi-mcp-adapter/blob/main/docs/configuration.md) and [tool discovery, approvals, and output limits](https://github.com/nicobailon/pi-mcp-adapter/blob/main/docs/tools.md).
- Main skill discovery: Pi 1.5.0 `docs/{skills,settings}.md` and `dist/core/{skills,package-manager}.js` under `~/.pi/agent/install/releases/1.5.0/node_modules/@earendil-works/pi-coding-agent/`.
