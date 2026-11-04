# Task working files and external workspaces

## Purpose and scope

The [shared instructions](../../agent/AGENTS.md#task-working-files) define destination precedence and task-path continuity. The [primary-agent instructions](../../agent/APPEND_SYSTEM.md#task-working-files) require loading `ck-task-workflow` for matching work and passing selected absolute paths to delegated agents. The [`ck-task-workflow` skill](../../agent/skills/ck-task-workflow/SKILL.md) owns the **fallback-location procedure**: task working files with no established destination use a persistent external workspace. The policy combines those shared constraints, a deterministic project-directory resolver and an agent-selected task name.

## Problem and motivation

Plans, one-off reproductions, logs, screenshots and review notes are useful during development but are not automatically part of a project's maintained contents. Putting them beside source code mixes deliverables with investigation material, makes cleanup ambiguous, and increases the risk of accidental publication. Ignoring them in Git does not remove them from the checkout.

An undefined destination also makes continuity fragile: one agent chooses a repository directory, another uses `/tmp`, and a later session cannot locate either. A persistent project/task namespace gives genuinely unassigned files a predictable home without requiring a project registry.

The fallback root is independent of the coding agent's session-history directory. Its contents can survive transcript retention, session replacement and worktree deletion. It also works for non-Git CWDs such as `~/work/editor-config`; a repository or manual project registration is not a prerequisite.

This is deliberately **not** a requirement to relocate every artifact:

- Explicit operator paths remain authoritative, including a requested path inside a project.
- Legitimate predefined tool/harness and established project destinations stay in use.
- Maintained code, regression tests, intended fixtures, configuration and documentation remain project deliverables.
- Existing transcripts, native reports, capture files and caches retain their own storage mechanisms.

## Destination precedence

Destination selection applies to each artifact separately. A task can use several already-defined destinations alongside an external fallback directory.

| Priority | Condition | Destination |
| --- | --- | --- |
| 1 | The operator specifies a destination for the artifact. | Use it directly. A new explicit destination can override an earlier fallback binding. |
| 2 | A legitimate tool/harness contract or established project convention already determines the destination. | Use that mechanism directly. |
| 3 | The artifact is otherwise unassigned, and an applicable fallback task directory is already known. | Reuse that task directory. |
| 4 | The artifact is otherwise unassigned, and no applicable task directory is known. | Resolve the project directory and select a new dated task directory. |

A directory invented by the agent on the spot, such as `reports/`, `.development-artifacts/` or `/tmp/my-task`, is not a pre-existing destination. Conversely, a tool's actual configured output directory is not made invalid merely because it is in temp or session storage.

Artifacts are written directly to their selected destinations. The fallback introduces no second copy, relocation, capture suppression or change to a tool's storage configuration. A conflict between an explicit operator destination and a tool's supported output controls remains an explicit unresolved conflict; a second file would not resolve it.

### Working material versus project deliverables

| File purpose | Treatment |
| --- | --- |
| Maintained implementation, configuration, regression test or required fixture | Keep in its proper project location. |
| Maintained project design/user documentation | Keep in the documented project location. |
| Disposable plan, hypothesis, reproduction script, comparison or scratch output with no destination | Use the fallback task directory. |
| One-off test log, screenshot, trace, benchmark export or review evidence with no destination | Use the fallback task directory. |
| Report or result already managed by a tool | Keep the tool's destination; do not mirror it into the fallback tree. |
| Intermediate information that can remain in memory | No file or directory is required. |

Purpose determines the classification, not extension or filename. A scratch reproduction can become a maintained regression test; in that role it belongs in the project's test suite rather than remaining the only regression coverage in external storage. This policy does not replace build-system output/cache conventions.

Project task plans and roadmaps have a [defined plan-store convention](../../agent/skills/ck-task-workflow/plan-lifecycle.md#scope-and-location) owned by `ck-task-workflow`. It covers standalone plans and roadmap-owned plans under the same lifecycle, supplying their destination before general fallback placement. Existing bindings and stronger assigned destinations retain precedence. The resolver itself does not allocate or move these documents.

## Task-directory layout

For new fallback work, the resolver runs in the relevant **source CWD**, not in the external workspace. Its result identifies the project, not the individual task. The agent combines that result with a locally dated task name:

```text
<project-dir>/YYYY-MM-DD-<description>
```

The resolver only computes a path. Directory creation belongs to the caller and happens when a working file is needed. An existing task binding is reused rather than recomputed, and the absolute path identifies the same task in later handoffs.

The following example illustrates construction of a **new fallback directory**, not replacement of an explicit destination or an existing task binding:

```bash
project_dir=$("${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}/bin/pi-task-project-dir") || exit 1
task_date=$(date +%F) || exit 1
task_description=investigate-schema-discovery
task_dir="$project_dir/$task_date-$task_description"
mkdir -p -- "$task_dir" || exit 1
```

The description is illustrative, not a fixed directory for unrelated tasks. Quoted variables preserve paths containing spaces. Resolution and directory creation are separate operations: a successful resolution does not prove that the eventual destination is writable, and creation/write failures remain visible failures.

Optional files and subdirectories can follow the needs of the task:

```text
<project-dir>/YYYY-MM-DD-investigate-schema-discovery/
    investigation.md
    scratch/
    evidence/
    test-runs/
```

This tree is optional organization, not an automatically created or mandatory skeleton. A task without working files needs no directory; plans, progress files and subdirectories exist only when needed for the work.

### Task names

A general fallback task name is `YYYY-MM-DD-<description>`. Project plans and roadmaps use the [lifecycle naming convention](../../agent/skills/ck-task-workflow/plan-lifecycle.md#stable-names), which adds a document-kind marker. An established plan/roadmap name also identifies any newly needed material directory; it is not regenerated or stripped of its marker when execution starts.

- `YYYY-MM-DD` is the local date when the task name is first established, obtained from the host rather than guessed by the model. A name chosen during project planning remains unchanged if execution or physical directory creation happens later.
- The description is 1–64 ASCII characters and matches `[a-z0-9]+(-[a-z0-9]+)*`.
- Use lowercase English words and digits separated by single hyphens. No spaces, underscores, leading/trailing hyphens or repeated hyphens.
- The date and its separating hyphen are outside the 64-character description limit.
- Unrelated tasks on the same date need distinct descriptions. A coincidentally existing directory is not evidence that it belongs to the current task.

Examples: `2026-10-24-external-task-workspaces` and `2026-10-24-reproduce-issue-831`. The displayed dates are examples; a new task uses the host's actual local date.

## Resolver interface

Executable: [`pi-task-project-dir`](../../agent/bin/pi-task-project-dir), in the `bin` subdirectory of Pi's agent configuration directory. `PI_CODING_AGENT_DIR` selects that directory; when unset or empty, it defaults to `$HOME/.pi/agent`.

```bash
"${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}/bin/pi-task-project-dir"
"${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}/bin/pi-task-project-dir" --help
```

These shell commands require an absolute path when `PI_CODING_AGENT_DIR` is set. Pi's own configuration parser can expand a literal `~` in that variable, but shell parameter expansion does not. The variable locates the executable; `XDG_DATA_HOME` separately determines the fallback storage base.

| Aspect | Contract |
| --- | --- |
| Runtime | Bash 4+, Git and GNU coreutils: `realpath`, `sha256sum`, `stat`. No Python/Node backend. |
| Input | Physical CWD, Git metadata/configuration and the standard home/XDG environment. There is no project-name argument. |
| Success | Exit 0; one absolute project-directory path and a newline on stdout. |
| Failure | Nonzero status; a diagnostic on stderr, no project path on stdout. |
| Side effects | No file/directory creation, migration, remote access or SSH-configuration lookup. |
| Caller responsibility | Decide applicability, recover or choose the task name, create needed directories and route file-writing tools. |

### Base directory

The base is `$XDG_DATA_HOME/pi/tasks` when `XDG_DATA_HOME` is absolute. An unset, empty or relative value selects `~/.local/share/pi/tasks`; in that case the home directory must be absolute. Existing symlinks and path components are physically resolved, so the printed physical path can differ from the textual environment value.

This uses the persistent-data category from the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir/latest/), not a disposable cache. The resolver has no age-based cleanup mechanism.

### Choosing the project identity

| Source CWD | Canonical identity |
| --- | --- |
| Inside a Git working tree or bare repository with `origin` | `origin:<normalized-host-and-relevant-port>/<repository-path>` |
| No Git repository, or a repository without `origin` | `local:<physical-absolute-cwd>` |

Git discovery works from nested directories and linked worktrees. The origin source is the **first effective fetch URL**, obtained through Git's own URL-rewrite interpretation. A push URL or a raw single-value `remote.origin.url` read is not a substitute. Multiple fetch URLs do not all become project identities.

Inherited `GIT_DIR`, `GIT_WORK_TREE`, `GIT_COMMON_DIR`, `GIT_INDEX_FILE` and `GIT_CEILING_DIRECTORIES` are removed for resolution so they cannot redirect discovery away from CWD. Normal user Git configuration, including `url.*.insteadOf`, remains applicable. Broken configuration, dubious ownership/access and other Git errors fail; they are not silently treated as “no repository.”

An effective-URL rewrite change can change the namespace for a **new** task even when the literal origin in `.git/config` stays unchanged. No SSH alias expansion or network lookup is used to establish server identity.

### Origin normalization

These ordinary forge spellings share the same host/path namespace:

```text
https://github.com/alice/sample-project.git
http://github.com/alice/sample-project.git
git@github.com:alice/sample-project.git
ssh://git@github.com/alice/sample-project.git
```

Normalization:

- Supports HTTP, HTTPS, SCP-style SSH and `ssh://` forms with ASCII hostname/SSH-alias tokens or bracketed hexadecimal IPv6.
- Lowercases the hostname; preserves repository-path case and percent-encoded spelling without decoding.
- Omits transport credentials and scheme from the identity.
- Omits conventional default ports: HTTP 80, HTTPS 443, SSH 22. Retains other ports.
- Removes leading/trailing path slashes and one terminal `.git` suffix. An empty final repository name, empty interior segment, `.` or `..` segment, or backslash is an error.

This is a **forge-oriented naming convention**, not proof that every SSH/HTTP endpoint is interchangeable. On a generic SSH server, `host:team/repo` can be relative to a user's home while `ssh://host/team/repo` is absolute; ignoring the username can erase another real distinction. The chosen convention can group those spellings. It also does not deduplicate SSH aliases, percent-encoding variants or expanded/compressed IPv6 spellings by contacting or interpreting the remote system.

### Directory name and hash

1. For an origin identity, use readable host/path with `/` replaced by `-`.
2. For a local identity, prefix `local-`, omit the physical path's leading `/`, and replace the remaining `/` with `-`.
3. Append `-` and the first **four lowercase hexadecimal** characters of SHA-256 over the UTF-8 canonical identity, with no appended newline.

The hash is computed **before** flattening, including the `origin:` or `local:` prefix. For example, `github.com/team-a/project` and `github.com/team/a-project` flatten alike but have different canonical inputs. The short suffix reduces this ambiguity; it does not prove collision freedom. Four hex characters have only 65,536 possible values. There is no collision registry, locking service or automatic disambiguation layer.

Examples with the default data root:

| Input | Project directory |
| --- | --- |
| Origin `https://github.com/alice/sample-project.git` | `~/.local/share/pi/tasks/github.com-alice-sample-project-<hash>` |
| Non-Git CWD `/home/alice/work/editor-config` | `/home/alice/.local/share/pi/tasks/local-home-alice-work-editor-config-3e85` |

The first example leaves `<hash>` symbolic because the executable computes the suffix. In the second, the canonical string is exactly `local:/home/alice/work/editor-config`. The equivalent HTTP/SSH examples above use one project directory independently of the checkout's location.

### Grouping consequences

- Nested CWDs in an origin-bearing repository, independent same-origin clones and linked worktrees share a project directory by design.
- Different origins, including an upstream and a fork, generally select different project namespaces.
- No-origin repositories and non-Git directories use the precise physical CWD: different subdirectories have different local identities.
- Symlink spellings of the same CWD converge. Moving a local directory changes a newly computed identity.

Project grouping is not task matching. Multiple tasks can share a project directory without sharing a task directory.

## Continuation and context loss

An established fallback task path remains authoritative for that task. Midnight, a changed origin/rewrite, another checkout or a different source CWD does not implicitly move its files. The resolver establishes a namespace for new work; it does not migrate an existing task. An explicit new operator destination still takes precedence.

A current task assignment, an explicit handoff or unambiguous task documents provide recovery evidence. Several plausible directories are an ambiguity, not a reason to select the newest one or silently create another task. There is no registry, manifest or automatic recovery service.

## Instruction ownership and context loss

Shared `AGENTS.md` owns destination precedence, task-path continuity and ambiguity/failure escalation. Primary `APPEND_SYSTEM.md` owns the condition for reading/rereading `ck-task-workflow` and the instruction to pass selected absolute paths to delegated agents. The skill owns resolver invocation, task naming and directory creation. Pi advertises its metadata and location rather than automatically preloading the full body. This reference explains the rationale and detailed mechanism; it is not an additional required read.

Conversation compaction can discard a loaded skill body or chosen task path independently of persistent system-context instructions. Re-reading the skill recovers the procedure, not the task's selected path. Handoffs carry that path separately; the shared ambiguity rule prevents guessing a replacement. Persistent instructions and task-path recovery are distinct responsibilities. The [instruction-layer guide](instruction-layers.md#skills-and-context-lifetime) explains loading boundaries, fork inheritance and project APPEND replacement.

## Output tools, retention and failures

A tool's supported output binding determines where its automatic files go; prose alone cannot redirect those writes. For otherwise-unassigned output, the binding selects the task workspace. Existing documented tool output/cache destinations remain authoritative rather than being rewritten by this policy.

A tool that clears its output directory uses a dedicated run subdirectory, such as `test-runs/<run-name>`, not the task root holding notes and evidence. Separate files/subdirectories prevent parallel writers from overwriting one another. There is no run-name allocator or mandatory run layout.

Resolver, directory-creation or output-routing errors remain explicit failures rather than triggering a silent switch to `/tmp`, the checkout or session storage. The resolver rejects unsupported/local/file origin forms, query/fragment suffixes, control characters, malformed supported origins, unusable non-directory path components, overlong project-name components and output resolving into the current source directory. Names are not silently truncated, and Git errors do not expose the raw credential-bearing origin in diagnostics. These checks do not guarantee that every future write succeeds or protect against concurrent external filesystem changes.

External files are not automatically versioned, shared or backed up with the source repository. Sensitive logs/screenshots remain subject to access and retention requirements. Material intended for long-term project maintenance belongs in the project's documentation/tests through an authorized change; external working files are not a substitute for deliverables. Cleanup requires explicit authorization and is not an implied side effect of resolution.

The policy is an instruction-and-routing convention, not a filesystem permission sandbox, repository-write interceptor or guarantee that every tool obeys prose.
