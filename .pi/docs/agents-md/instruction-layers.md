# Shared instructions and primary-agent instructions

## Purpose and selected architecture

Use the global `AGENTS.md` for policy shared by the primary agent and applicable subagents. Use `APPEND_SYSTEM.md` for the primary agent's operator-facing coordination and working profile. Keep detailed, conditional methods in skills and bounded task facts in delegation briefs.

This is the selected instruction architecture, not a claim that the live instruction files have already been repartitioned. The actual files and effective session configuration determine what each request receives. This guide explains the design, its rationale, limitations and alternatives; it is not an additional mandatory instruction source or a deployment checklist.

The loading contracts below were checked against **Pi 1.4.0** and **pi-subagents 0.84.0**. These are evidence versions, not a requirement to pin those releases indefinitely. Recheck the relevant contracts after upgrades.

The [pi-subagents guide](../pi-subagents.md#instruction-inheritance-and-primary-only-text) owns role settings, provider/tool/skill assignments and child-runtime configuration. This guide owns instruction-content placement, the rationale for the split and the comparison of possible carriers. [CONTEXT.md](../CONTEXT.md) describes documentation ownership.

## The problem

A primary agent coordinates an operator's overall goal. A subagent normally completes a bounded assignment and reports to its parent. The two need many of the same engineering rules, but not all the same responsibilities.

A mixed global instruction file can accidentally tell a child to:

- ask the human operator for a decision instead of contacting its supervisor;
- load the overall task/roadmap workflow for a small delegated task;
- manage project plans, arrange reviews or select further work without that authority;
- perform required checks using tools its role does not possess.

Removing a primary-owned skill from a child's catalog does not cancel an inherited instruction to read it. Conversely, disabling all global-context inheritance removes useful common rules along with the misplaced coordination instructions. Neither change alone separates the audiences.

This is a mismatch between responsibilities and instruction scope, not proof that a model deliberately ignored a valid instruction. Similar problems are reported in other coding-agent systems; their reports are corroborating examples, not evidence of the cause of every local failure.

### Three independent properties

| Property | Question | What it does not establish |
| --- | --- | --- |
| Delivery | Did the actual request contain the intended text? | That the model applied it correctly. |
| Applicability and authority | Does the rule apply to this role and authorized assignment? | That a mentioned tool is available or an operation is permitted. |
| Enforcement | What can the runtime, permission layer or operating system actually allow or block? | Whether every architectural judgment or validation claim is sound. |

A file split addresses delivery and helps express applicability. It is not a permission system, filesystem sandbox or guarantee of obedience.

## Content ownership

### Shared `AGENTS.md`

The shared file carries concise standing requirements for all relevant agents:

- evidence, facts versus assumptions and truthful completion claims;
- code quality, boundary validation and useful comments/documentation;
- impact-based validation and honest reporting of failed or unperformed checks;
- review findings as claims requiring verification;
- commit, push, publication and deployment authorization;
- applicable language rules for internal work;
- destination precedence, established artifact bindings and no invented replacement paths;
- decision boundaries and the route for escalation appropriate to the current role.

Apply each requirement within the assignment and available capabilities. A read-only reviewer can identify a missing test without obtaining permission to edit code or run shell commands. A skill's instructions do not widen that role's tool or task authority.

Classify individual requirements rather than moving whole headings by their title. For example, an internal-language rule remains shared even if its old location happens to be a section named Delegation.

### Primary `APPEND_SYSTEM.md`

The primary profile carries responsibilities of the agent working directly with the operator:

- clarify the overall goal, priorities and material trade-offs with the operator;
- own the project plan/roadmap lifecycle and the applicable `ck-task-workflow` read trigger;
- select and coordinate bounded delegations, synthesize their results and maintain overall task state;
- resolve otherwise-unassigned working destinations and provide selected paths to children;
- present the final result and unresolved decisions to the operator;
- follow the primary session's communication/profile preferences.

This is a local content convention built on Pi's loading behavior. Pi does not parse these responsibility categories or define APPEND as a universally primary-only file. The profile can contain substantive primary duties, not just cosmetic preferences; its replaceability is therefore a material limitation, described below.

A child may be assigned to review a plan or improve the workflow itself. That bounded assignment supplies the relevant documents as inputs; it does not transfer ownership of the whole project lifecycle. Explicitly authorized nested coordination is likewise limited to its granted scope, not prohibited merely because it is delegated.

### Skills, project context and task briefs

| Material | Place | Reason |
| --- | --- | --- |
| Shared standing constraints | Global `AGENTS.md` | Automatically present through the selected common-context route. |
| Primary coordination and profile | User-level `APPEND_SYSTEM.md` | Separate primary loading without copying builtin child roles. |
| Detailed conditional methods | Relevant skills | Load the procedure when its task conditions apply. |
| Repository facts, build/test commands and local conventions | Project/ancestor context files | Keep project-owned knowledge with its actual scope. |
| Exact task, authority, paths, evidence, output and stop conditions | Delegated brief | These differ between assignments and cannot be inferred from standing rules. |
| Role purpose and capability limits | Builtin role plus minimal supported overrides | Preserve author-owned role guidance rather than copying it to add common rules. |
| Technical background and alternatives | This guide and linked references | Explain the mechanism without enlarging every request. |

Keep each requirement in one authoritative place. Do not make every brief repeat the standing policy or keep competing copies in AGENTS, APPEND, skills and role prompts. A plain Markdown link is not an automatically expanded import.

## How the selected mechanism works

### Paths and prompt construction

`<agent-dir>` is Pi's resolved agent directory, normally `~/.pi/agent`. `PI_CODING_AGENT_DIR` or the SDK's `agentDir` can change it. Use the resolved location rather than hard-coding a person's home directory.

Pi's ordinary prompt construction includes both kinds of text:

| Input | Prompt component | Loading distinction |
| --- | --- | --- |
| Applicable context files, including AGENTS | `project_context` | Context-file discovery can combine files from several applicable locations. |
| Selected APPEND content | `addendum` | Normal discovery selects a project or user append file, not both. |
| Skill catalog | `skills` | Names, descriptions and locations; not every skill body. |

Both AGENTS and APPEND contribute to system context. APPEND is not a higher authority merely because of its filename, and AGENTS is not merely optional background information. Conflicting content should be resolved at its owner rather than relying on filename priority. `SYSTEM.md` is different again: it replaces Pi's base prompt instead of supplying the ordinary addendum.

Project context files are discovered from the working directory and its ancestors, as well as the agent directory. An `AGENTS.override.md` replaces recognized context files only in its own directory; it does not selectively remove global sections. Project trust is required for project `.pi/APPEND_SYSTEM.md`, but not for discovering AGENTS context files.

### Fresh native subagents

The selected common-policy route requires both `inheritProjectContext: true` and `inheritGlobalContext: true` for relevant fresh children. In the analyzed version, global inheritance defaults to false; the configured seven roles explicitly enable it. If project-context inheritance disables all context files, the global flag cannot independently restore them. The [role guide](../pi-subagents.md#shared-child-configuration) owns those settings.

The native child loader explicitly supplies append input to Pi. Without a child append prompt it passes an empty list, preventing rediscovery of the operator's APPEND file. In a child using append mode, the supplied text is the child's own role prompt; it is not an instruction to import the operator profile. Both discovered user and project APPEND files are bypassed by that explicit input.

This behavior is intentional: pi-subagents fixed operator-APPEND leakage in 0.79.2. The local PR #2961 and the release's additional saved-Herdr-machine fix #2969 have different scopes. The analyzed local loader establishes the normal local contract; the release note is not a substitute for checking a different remote/custom runtime.

| Session path | Shared AGENTS | Primary APPEND |
| --- | --- | --- |
| Ordinary primary Pi session | Applicable context files | Selected user or trusted project APPEND, if present. |
| Fresh native child with the required inheritance | Retained through context loading/filtering | Not automatically discovered; the child has its own role/task instructions. |
| Fork child | Present in the inherited parent prefix when the parent had it | Present in that prefix when the parent had it. |
| Custom SDK host, remote integration or replacement prompt hook | Depends on that integration | Must be checked; the native local contract is not universal. |

### Fork is not fresh-context isolation

An intentional `context: "fork"` preserves the parent's prompt and conversation prefix. Disabling `inheritGlobalContext`, `inheritProjectContext` or `inheritSkills` does not scrub those inherited instructions. A replace-mode child role does not remove that prefix either. The child's own role and task boundaries are carried in its task instructions.

Consequently, primary duties must remain identifiable as duties of the operator-facing coordinator even when their text is visible in inherited history. A delegated agent remains responsible for its bounded assignment, not the parent's whole workflow. The native fork preface states child-role precedence; this is an instruction to the model, not enforced audience filtering.

Strict absence of primary text requires a fresh-context contract or a separate change to fork behavior. That would change history continuity and potentially prompt-cache behavior. It is not part of this file-organization decision, and no blanket switch of oracle or other roles to fresh follows from it.

The native fork documentation describes a later transition to the child's own prompt after compaction removes inherited messages. That is distinct from ordinary model-side context reduction or an assumption that every Magic Context operation performs the same transition. Retention, updates and role applicability across that boundary need actual verification for the chosen runtime; no universal compaction or cache-performance result is implied here.

### Project APPEND replacement

For ordinary discovery, Pi chooses:

1. `<cwd>/.pi/APPEND_SYSTEM.md`, if the project is trusted and the file exists;
2. otherwise `<agent-dir>/APPEND_SYSTEM.md`, if it exists;
3. otherwise no discovered append file.

The project and user files are **not concatenated**. Even an empty selected project file does not mean "also load the global file." Project APPEND replacement does not by itself remove the separately loaded shared AGENTS files.

This is an accepted property of the selected mechanism, not a solved composition feature. It has an important consequence: a primary duty whose only source is the user APPEND can disappear in a project with its own APPEND. A rule that must survive arbitrary project-profile replacement cannot rely on that sole copy. Before placing such a rule, its scope and the permitted project override behavior must be settled explicitly; the split does not silently downgrade an obligation to a preference.

There is no automatically adopted launcher, manual copy, global/project concatenation rule or new loader to hide this limitation. Keeping short primary-scoped mandatory triggers in AGENTS is a possible hybrid, compared below, not an unannounced replacement of the selected architecture. Selecting the carrier does not determine the final placement of every existing bullet.

### Skills and context lifetime

Pi and the configured child skill catalogs initially advertise metadata, not full procedure bodies. A matching task or a surviving read instruction still needs the model to read the skill. A skill catalog entry therefore differs from automatically delivered common policy.

The `ck-task-workflow` catalog omission for children does not cancel an applicable instruction still present in AGENTS. Separating the read trigger itself is necessary when repartitioning the files; primary-only wording inside the skill is too late to prevent an unqualified read obligation.

Read skill bodies and ordinary briefs are conversation content. They may be summarized or reduced; their exact lifetime depends on the runtime. System-context assembly is a different route, but it is not proof that arbitrary prompt-transforming extensions can never remove or replace content. Claims about survival require observations of actual requests, not just filenames or TUI history.

## Decisions and delegated authority

The shared policy preserves operator decision rights while routing questions to the appropriate recipient:

1. The primary asks the operator about decisions reserved to the human.
2. A child requests a decision from its supervising parent through the supported `contact_supervisor` channel. If the required channel is unavailable, it reports the blocker rather than inventing permission or speaking to the operator through another interface.
3. The parent may resolve questions within already approved/delegated authority. It takes reserved decisions to the operator rather than treating parenthood as blanket approval authority.
4. The child continues affected work after receiving the scoped decision. A progress receipt or tool acknowledgement is not that decision.

This routing does not expand read/write/shell/nesting permissions. Detailed validation methods remain conditional on the role's assignment and capabilities; unavailable required checks remain explicit gaps rather than fictional passes.

## Why this architecture was selected

- It uses native Pi context files and intentional pi-subagents loading behavior rather than a custom policy loader or core patch.
- Shared baseline rules have one source and do not depend on every child remembering a first-read action.
- Primary coordination has a separate loading route for ordinary fresh children.
- Builtin role prompts remain author-owned, with minimal overrides.
- Conditional skills retain their existing role without becoming the only carrier of baseline authority.
- Native fork continuity is preserved, with its visible-parent-text limitation documented rather than disguised as isolation.

The trade-offs are project APPEND replacement, semantic role scoping in forks and continued dependence on correct model application. No measured token saving, cache gain, latency improvement or universal compliance rate is established. The design reduces audience conflict; it does not eliminate every delivery or behavior failure.

## Alternative mechanisms

The identifiers below match the research comparison. They are labels, not Pi configuration fields or a required implementation sequence. Except for R2, these mechanisms are alternatives or complementary tools, not selected additions.

| Option | Advantage | Main cost or condition |
| --- | --- | --- |
| R0 — Keep mixed global instructions | No migration or new component. | Preserves the original audience/catalog conflict. |
| R1 — One role-scoped AGENTS | Small native change; one common source. | Primary-only text still reaches children; applicability is model-interpreted. |
| R1-H — Scoped mandatory core and conditional methods | No new loader or role snapshots; mandatory triggers can survive project APPEND replacement. | Short primary clauses remain in children; conditional reads still depend on the model. |
| **R2 — Shared AGENTS and primary APPEND** | **Selected:** native fresh-child split, one common baseline, preserved builtin roles. | Project replacement and fork inheritance remain. |
| R2-L — Explicit primary append launcher | Uses Pi CLI append support. | Owns launch coverage and composition; bypasses discovered append files. |
| R3 — Shared skill/read-first file | One authored method source; conditional detail stays out of ordinary tasks. | Bootstrap, reading and retention are model-dependent. |
| R4 — Repeat rules in every brief | No new loader; tailored task boundaries. | Repetition, omissions and divergent policy copies. |
| R5 — Assemble policy into role prompts | Supported upstream carrier; automatic text after correct assembly. | Builtin prompt replacement/snapshots or a maintained generator. |
| R6 — Shared-policy extension | One common source through a public additive API; preserves builtin bodies. | New executable lifecycle, failure, provider and fork responsibilities. |
| R7 — Project/ancestor carrier | Native context discovery with no new code. | Coverage depends on filesystem placement and project-context inheritance. |
| R8 — Upstream shared-file feature | Could make composition a supported native contract. | Prospective in the analyzed surfaces; author acceptance, implementation and release needed. |
| R9 — Supervisor bridge template | Existing documented child-instruction file mechanism. | Coupled to bridge activation; read failure falls back without blocking launch. |
| R10 — Permissions or operation guards | Can block supported operations independently of remembered prose. | Complement, not general instruction delivery or a compiler for architectural judgment. |

### R0, R1 and R1-H: retain one shared policy file

R0 preserves both engineering and operator-facing instructions without separating them. It is a holding state, not a resolution of an unqualified workflow pointer or incorrect escalation route.

R1 makes primary-only clauses explicitly apply to the operator-facing coordinator. Shared safety/quality policy remains automatic. It is the smallest way to resolve conflicting responsibilities when physical text exclusion is not required. Children still spend attention on irrelevant text, and a future unqualified bullet can recreate the problem.

R1-H refines this: keep the mandatory core and short role-scoped triggers in AGENTS, detailed methods in skills, and only genuinely replaceable convenience text in APPEND if desired. It avoids making mandatory primary triggers depend solely on an overrideable file. This can be preferable if project-profile replacement must not remove those triggers, but it deliberately sacrifices strict primary-text exclusion. It is not the same content split as placing primary coordination in APPEND.

Role scoping remains useful alongside other loading mechanisms, especially for forks. Ordinary Markdown audience headings are not a machine-readable filtering protocol.

### R2-L: force append input through a launcher

Pi accepts repeatable `--append-system-prompt <text|path>`. Explicit append sources bypass discovery of **both** project and user APPEND files. A launcher can select a primary file without project discovery replacing it, but legitimate project append content is then also absent unless explicitly composed.

That composition needs its own ordering and update rules. Every relevant TUI, RPC, SDK, Herdr and resume launch path must receive the intended input; a shell alias does not cover them all. In the analyzed loader, a nonexistent path-like input is treated as literal text, while an unreadable existing file warns and returns the input string. Passing a filename is therefore not proof that its contents loaded or that failure blocks execution.

This trades discovery precedence for launcher ownership. It is not a simple native "combine both files" switch and does not remove parent text from forks.

### R3: require a shared skill or first-read document

A common skill/file can hold substantial conditional engineering methods without an executable integration. Its read instruction must itself reach the child: putting that instruction only in an excluded global AGENTS is circular. Default catalog selection does not preload the body, and a read-only role still needs a permitted reading route.

Reading and rereading after context loss remain model behavior. Per-role bootstrap prompts may incur R5's replacement cost. Explicit `/skill:name` invocation, including a manually exposed skill, is another native route, but requiring the operator to invoke it loses ordinary-language automatic triggering. This is useful for methods, weaker for a baseline that must already be present.

### R4: transmit policy in each delegation brief

Task-specific goal, scope, evidence, outputs and stop conditions belong in a brief under every architecture. Using briefs as the only standing-policy carrier additionally requires the parent to remember and faithfully reproduce every applicable rule on every launch.

That creates omissions, paraphrase drift and repeated text. Fresh children depend on the packet's completeness; forks may retain contradictory older wording. A first task message alone does not establish retention through compaction. Use briefs for assignment-specific facts, not as an implicit substitute for the common-policy source.

### R5: put common instructions into each role prompt

The pi-subagents 0.79.2 release note recommends the agent prompt or `agentOverrides.systemPrompt` for instructions intentionally supplied to a child. This is a supported route, not a speculative workaround.

However, `systemPrompt` overrides replace the builtin role body. `systemPromptMode: append` appends the resulting agent prompt to Pi's base; it does not append an override to the author's builtin role. Preserving that body therefore requires a local snapshot or explicit composition. Copies drift after upstream changes; a generator preserves one authored common source but introduces generation/staleness responsibilities. The primary also needs a route to the same policy.

This is suitable when role-prompt ownership is intentional. It conflicts with the preference to preserve builtin roles merely to add a common baseline.

### R6: automatically inject a shared policy through an extension

Pi's public structured-prompt API can add a named section without replacing the whole role prompt. A common file could be automatically supplied to the primary and children while global inheritance is disabled. This avoids first-read dependence and can preserve a single authored source.

It requires a real integration contract: provider loading in foreground/background and explicit role lists, failure behavior, updates/reload, duplicate prevention and coverage after session reconstruction. A thrown extension-hook error must not be assumed to stop all work; Pi can log extension errors and continue.

Fork projection also matters. The analyzed runtime excludes changed loadout sections such as `rules`, `skills` and `project_context` from the child task-instruction block; it forwards changed non-loadout sections there and omits identical named/value sections at that loop. This is not arbitrary text deduplication. Replacing the parent's system prompt changes fork behavior. A process-level `PI_SUBAGENT_CHILD` marker documented for async hosts is not proof of a discriminator for every in-process session; a conditional loader needs a supported identity contract.

The public API makes this a legitimate extension possibility, not automatically a hack. It nevertheless adds executable code and lifecycle ownership; the example API is not evidence that an unimplemented loader is correct with all providers or Magic Context.

### R7: use project or ancestor AGENTS instead of global inheritance

A common workspace ancestor can naturally cover multiple checkouts, and repository-owned rules belong in project context. This needs no new loader.

It does not cover arbitrary working directories. Moving a checkout or using a worktree outside the ancestor changes coverage; separate copies drift, while a broad ancestor may affect unrelated projects/tools. It also couples personal policy to `inheritProjectContext`. Symlinks or copies do not remove those ownership and coverage issues.

### R8: add independent common-file support upstream

A dedicated common-instruction carrier could preserve builtin roles and define composition, precedence, failure, refresh and fork behavior as a supported feature. Other products provide concrete precedents.

The analyzed pi-subagents documentation/override fields and pinned release notes do not expose an equivalent independent carrier; that is a time-scoped observation, not an exhaustive proof of absence in every integration or future version. Upstream acceptance, implementation, tests and a release are still required. The current recommendation of role prompts does not predict whether a new feature would be accepted. No fictional setting name or promised upstream roadmap follows from this option.

### R9: reuse the supervisor bridge template

`intercomBridge.instructionFile` replaces the default child coordination template. It supports parent-target interpolation and documented activation modes, but bridge activation needs a targetable parent. It is not an unconditional common-policy loader.

A custom template takes ownership of preserving the default coordination instructions. If the configured file cannot be read, the analyzed implementation warns, uses its default template and can remain active. Policy found only in the custom file can therefore disappear without preventing launch. The primary also needs a separate route to the common policy. A template naming the parent can affect launch-contract identity.

This is appropriate for deliberate coordination customization, not an independent shared baseline merely because it accepts Markdown.

### R10: enforce the subset expressible as operations

Actual tool permissions or supported pre-operation guards can block covered actions even if the model forgets prose. A read-only role should have an appropriate capability boundary; instructions remain necessary for evidence, scope and judgment.

A guard must cover the real operation paths: blocking a direct edit tool is not enough if shell or MCP can mutate the same target. Overbroad checks can interrupt legitimate work. A command name cannot generally establish architectural approval or meaningful test quality. This complements the selected architecture rather than replacing instruction delivery; no new guard is selected here.

## External precedents and their limits

| Source | Useful lesson | Qualification |
| --- | --- | --- |
| [Claude subagents](https://code.claude.com/docs/en/sub-agents) and [memory](https://code.claude.com/docs/en/memory) | Separate roles, shared memory, opt-outs, loader imports and full skill preloading can be distinct features. | Agent-type exceptions, skipped missing/disabled skills and forks matter. Pi metadata catalogs do not inherit Claude's preload or reinjection contract. |
| [Claude CLI](https://code.claude.com/docs/en/cli-reference) | A dedicated child-append channel is a concrete feature design. | The documented flags have version/non-interactive limits and exclude forks; they are not Pi flags. |
| [Codex AGENTS](https://developers.openai.com/codex/guides/agents-md), [custom agents](https://developers.openai.com/codex/multi-agent) and [#26806](https://github.com/openai/codex/issues/26806) | Shared-file chaining, role configuration and actual permissions are separate. The issue closely describes parent obligations leaking to bounded children. | Proposed audience tags/inheritance controls in an issue are not implemented settings or proof of every current Codex path. |
| [OpenCode rules](https://opencode.ai/docs/rules/) and [pinned instruction loader](https://github.com/anomalyco/opencode/blob/6d1c444b8c53da667b51ed45b0a7c0aca1174674/packages/core/src/config/plugin/instruction.ts) | Native common-file composition can avoid policy copies; refresh and remote fallback need contracts. | Not an installed Pi feature or a complete audit of OpenCode child delivery. |
| [Copilot custom agents](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-custom-agents) | Role purpose and tool capabilities can be specified separately; a planner need not implement. | This does not settle Pi inheritance or justify replacing builtin roles. |
| [Pinned Anbeeld AGENTS](https://github.com/Anbeeld/AGENTS.md/blob/c2f3faaaa8196bd028ae7e590423ad60c837223a/AGENTS.md) and [Superpowers controller/worker workflow](https://github.com/obra/superpowers/blob/2ce8aa15d05bd57213e6f746f953aafb7ded7a8b/skills/subagent-driven-development/SKILL.md) | Explicit primary ownership, bounded worker briefs and escalation are practical conventions. | No measured compliance proof. Superpowers' automatic-commit/model/review policies are not adopted. |
| [Third-party Pi context modes, version 0.1.5](https://cdn.jsdelivr.net/npm/pi-dynamic-workflows-oc-style@0.1.5/docs/context-modes.md) | Shared AGENTS plus main-only APPEND has a documented Pi-ecosystem precedent. | Different extension and fresh-child design; its code/test claims were not independently audited and it does not solve project/user APPEND replacement. |
| [AGENTS.md format](https://agents.md/) | A common, readable instruction-file convention. | Plain Markdown, not a universal audience parser or enforced security policy. |

[Anthropic's context-engineering article](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) and [customization guide](https://claude.com/blog/steering-claude-code-skills-hooks-rules-subagents-and-more) support separating standing context, conditional methods and actual controls. Product-specific retention claims and vendor advice are not local performance evidence.

Forum experience is lower-authority evidence: the inspected [Hacker News thread](https://news.ycombinator.com/item?id=45230768) contains contradictory inheritance accounts. The independent [CLAUDE inheritance article](https://amitkoth.com/which-agents-read-claude-md/) illustrates version sensitivity; its no-per-agent-opt-out statement conflicts with the researched official `omitClaudeMd` documentation. Its measurements and causal claims are not used to rank models or prove this design. No single forum or article establishes a universal best practice.

## Observable contract and verification limits

Instruction-architecture validation concerns actual delivered text and authorized behavior, not merely whether a file contains a keyword. The following are relevant cases for an implementation or upgrade; this table is not a record that they have passed.

| Case | What the evidence must distinguish |
| --- | --- |
| Primary without project APPEND | Common policy versus the selected primary profile. |
| Primary with trusted project APPEND | Actual replacement, including absent global-only duties; no assumed concatenation. |
| Fresh child in each relevant role | Shared policy present, native role preserved, primary profile not automatically discovered, unchanged tools/authority. |
| Project context disabled or global inheritance omitted | Missing-policy consequences of those flags, rather than assumed delivery. |
| Intentional fork | Parent text remains; the child follows its own bounded role without an isolation claim. |
| Compaction, reconstruction or reload | Distinguish native prompt transitions from conversation reduction; inspect subsequent effective requests. |
| Material decision beyond child authority | Supervisor routing, followed by operator approval where actually required. |
| Bounded plan review or multi-step child task | No unintended transfer of overall plan/roadmap ownership. |
| Missing/replaced instruction input | Observed error/fallback behavior; no assumption of fail-closed startup. |
| Skill-dependent task | Catalog resolution, actual skill read and correct application are separate observations. |

Useful evidence includes actual prompt sections/source paths or hashes, child journals, supervisor messages and filesystem/tool outcomes. A model's statement that it complied is insufficient. Cache/performance comparisons or model benchmark campaigns are not required by this architecture. Broader remote/provider/MC behavior remains a separate validation question, not an implied result of the documented local source contracts.

## Authoritative Pi sources

The links below identify the installed reference sources; versioned paths delimit the implementation inspected and may need refreshing after updates.

- [Pi configuration](../../agent/install/releases/1.4.0/node_modules/@earendil-works/pi-coding-agent/docs/configuration.md): agent directory, context discovery, project trust and project-over-user APPEND selection. [Public configuration reference](https://pi.dev/docs/latest/configuration).
- [Pi prompt construction](../../agent/install/releases/1.4.0/node_modules/@earendil-works/pi-coding-agent/dist/core/system-prompt.js): `buildSystemPromptSections`, including `addendum`, `project_context` and skill metadata.
- [Pi resource loader](../../agent/install/releases/1.4.0/node_modules/@earendil-works/pi-coding-agent/dist/core/resource-loader.js): `discoverAppendSystemPromptFile`, explicit append-source handling and `resolvePromptInput` fallback behavior.
- [Pi skills](../../agent/install/releases/1.4.0/node_modules/@earendil-works/pi-coding-agent/docs/skills.md): metadata discovery, explicit invocation and body loading.
- [pi-subagents prompt assembly](../../agent/npm/node_modules/pi-subagents/docs/agents.md#prompt-assembly) and [fork details](../../agent/npm/node_modules/pi-subagents/docs/tool-reference.md#fork-context-details): fresh/fork scope and inheritance flags.
- [Native child loader](../../agent/npm/node_modules/pi-subagents/src/runs/shared/child-session.js) and [launch assembly](../../agent/npm/node_modules/pi-subagents/src/runs/shared/child-launch.js): explicit append input and the child's own role text.
- [Native prompt boundary and fork projection](../../agent/npm/node_modules/pi-subagents/src/runs/shared/subagent-prompt-runtime.js): filtering, child-role instructions and fork request construction.
- [Role override implementation](../../agent/npm/node_modules/pi-subagents/src/agents/agents.js): replacement of the builtin `systemPrompt`, rather than an automatic author-prompt append.
- [Supervisor bridge configuration](../../agent/npm/node_modules/pi-subagents/docs/configuration.md#intercombridge) and [implementation](../../agent/npm/node_modules/pi-subagents/src/intercom/intercom-bridge.js): template activation and default-template fallback on read failure.
- [Official additive prompt example](../../agent/install/releases/1.4.0/node_modules/@earendil-works/pi-coding-agent/examples/extensions/prompt-customizer.ts) and [extension contracts](../../agent/install/releases/1.4.0/node_modules/@earendil-works/pi-coding-agent/docs/extensions.md): supported customization versus error/composition responsibilities.
- [pi-subagents #2960](https://github.com/nicobailon/pi-subagents/issues/2960), [PR #2961](https://github.com/nicobailon/pi-subagents/pull/2961), [remote follow-up #2969](https://github.com/nicobailon/pi-subagents/issues/2969) and [pinned changelog](https://github.com/nicobailon/pi-subagents/blob/343ba73abeaf0a6e942a906ee4333a35f495b757/CHANGELOG.md): intentional APPEND separation, local/release scope and the documented per-role prompt route.
- [pi-subagents #1807](https://github.com/nicobailon/pi-subagents/issues/1807#issuecomment-5595564759): intentional global exclusion and an anecdotal deletion report. It does not prove that inheriting prose would have prevented the incident.
