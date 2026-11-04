# ck-testing

A Pi user-level, model-invoked home for testing guidance: how to design, write, and review tests and validation checks. Its initial policy addresses implementation-mirroring tests. Additional testing policies can be added as they are agreed, without introducing a separate skill for every testing concern.

[`SKILL.md`](SKILL.md) is the authoritative agent instruction. This README explains the motivation, boundaries, installation, and maintenance; it is not a second policy or required reading for ordinary testing work.

## The problem

An agent implements a change, then writes a test that opens the implementation file and searches for the same commands, identifiers, expressions, or phrases it just added. The check looks like regression coverage, but often establishes only that the implementation still looks familiar.

For example, finding a compiler command in a Makefile does not establish that the intended target runs it, uses the right dependencies, handles failures, or produces the required artifact. Likewise, finding a validation call in a function's source does not establish that invalid input reaches it or is rejected.

This is a general test-design failure, not a Makefile-specific rule. It can occur in application code, scripts, build definitions, configuration checks, or generated-code tooling.

### Reported model observations

The operator has observed this pattern in work performed by models from the **GPT-5.6, GPT-6, and GPT-6.1 families**. These are operator-reported observations, not a controlled benchmark, an estimate of frequency, or a claim that every model or run in those families behaves this way. The skill is model-independent.

## Why these checks are misleading

There are two distinct failure modes:

1. **Broken behavior can pass.** The expected text may occur in a comment, an unreachable branch, an unused helper, or incorrectly connected code. Even a precise syntax-tree query can establish presence without establishing the required effect.
2. **Correct changes can fail.** A requirement-preserving refactor can change names, helper structure, command composition, or internal representation. A test tied to those details then demands maintenance without identifying a requirement violation.

A more sophisticated inspection mechanism does not fix the underlying reasoning. The missing element is an independently justified expectation: what should be true for the task, a consumer, a specification, or an agreed engineering constraint. “This is what the current implementation does” is not enough. Declaring that implementation a contract after the fact does not supply an independent justification.

This does not require a separate specification document for every test. It requires a defensible reason for the assertion and evidence that actually supports it.

## The boundary is the requirement, not the technique

| Situation | Why the distinction matters |
| --- | --- |
| Search an implementation for a helper call or command to claim behavior is correct | Presence is not evidence that the relevant execution path works. Exercise that behavior instead. |
| Parse the same implementation and assert its current tree shape | Parsing improves structural precision, not the justification for freezing that structure. |
| Check actual CLI output, diagnostics, or protocol text | The produced text can be observable behavior. Match the parts required by the contract rather than incidental wording. |
| Validate repository metadata against a required release format | The file content itself is consumed under a format contract. Static validation is appropriate; application execution is unnecessary for that claim. |
| Check a forbidden dependency or API under an agreed architectural constraint | The source property itself is a requirement. Inspection can directly check that property without claiming to prove all runtime behavior. |
| Run a generator and inspect its output | Generated text or structure is an output contract. Checking required exports or syntax is distinct from finding template fragments in the generator's own source. Compilation or execution is needed when the claim requires that further evidence. |
| Observe a required interaction or internal invariant during a unit test | White-box testing can be meaningful when the interaction or invariant is independently required, rather than copied from the implementation's current sequence of steps. |

Even legitimate output tests can become implementation-mirroring tests if they freeze irrelevant details. A snapshot is not automatically good or bad; its content and review must correspond to what the test is intended to protect.

The policy therefore does **not** ban reading files, regular expressions, parsers, static analysis, snapshots, mocks, or unit tests. It also does not require every check to become an end-to-end test. The evidence must match the property and the scope of the claim.

An unavailable runtime is a validation limitation, not a reason to relabel a source-presence check as behavioral coverage. A legitimate static check may still provide narrower evidence, which should be described as such.

## Why a user-level skill

The same preference applies across projects, but its detailed instructions are relevant when designing or reviewing checks—not during every unrelated task.

Pi advertises a discovered skill's name, description, and path. The model reads the body when the task matches the description. This makes the description the routing instruction and keeps the full policy out of the initial prompt. Reading the body brings it into that session's context; it is not automatically unloaded after a test task.

There is no duplicate rule or mandatory pointer in `AGENTS.md`. The skill description covers both implementation work that adds tests and review work that evaluates them. Merely running an existing test command is not the principal trigger for the current policy.

## Installation and subagents

The Pi-specific user skill directory is:

```text
~/.pi/agent/skills/ck-testing/
├── SKILL.md
└── README.md
```

Pi discovers `<agent-dir>/skills/` automatically; the agent directory defaults to `~/.pi/agent` and can be overridden with `PI_CODING_AGENT_DIR`. This is Pi-specific storage rather than the shared Agent Skills directory. Do not set `disable-model-invocation: true`: this policy should be discoverable without the operator remembering to invoke it. An explicit `/skill:ck-testing` invocation remains available.

Local child skill assignments are owned by `~/.pi/agent/settings.json`, under `subagents.agentOverrides`, and explained in [`~/.pi/docs/pi-subagents.md`](../../../docs/pi-subagents.md). That document records the complete role matrix and its rationale rather than duplicating the configuration here.

`worker` and `reviewer` receive `ck-testing` through explicit `skills` lists with `inheritSkills: false`; the matrix also covers other roles. Newly installed skills require a deliberate assignment, while additions to this existing skill remain available through its unchanged name.

Explicit selection advertises metadata; it does not preload the skill body, grant tools, or authorize unrelated work. Normal discovery and project/launch overrides still apply. Avoid copying the testing policy into role prompts or maintaining a second per-role list of its rules.

Existing Pi instances need a reload or restart to refresh their resources. Use `/reload` after important active and background work has finished; it replaces extension runtimes and is not merely a file refresh. Already-running child agents are not retroactively updated.

Discovery and inheritance make the policy available, not mechanically enforced. A model can still miss a trigger or apply a rule incorrectly. Availability, actual skill reads, and the quality of resulting tests are separate things to verify.

## Extending the skill

The personal `ck-` prefix reduces accidental name collisions. Keep one coherent testing entry point as further guidance on test construction, test execution, or validation is approved.

- Keep broadly applicable working rules in `SKILL.md`, grouped by decision. Keep motivation and maintenance notes here.
- When a topic becomes substantial or applies only to a distinct branch, move its instructions into a focused `references/<topic>.md` file and add a precise condition for reading it in `SKILL.md`. Do not create empty reference files or a router before there is content to route.
- Add a new trigger to the description only when new behavior actually needs it. The description is always-loaded context, not a table of contents.
- Keep each rule authoritative in one place. If an existing global or project rule is deliberately moved here, update its old location as part of that agreed change rather than silently maintaining two versions.
- Keep framework-specific commands and repository details in their projects. This skill supplies cross-project testing principles, not a universal test runner.
- Evaluate changes with both prohibited and legitimate cases. A stricter instruction is not an improvement if it prevents meaningful static, output, or white-box tests.

No additional testing methodology, coverage threshold, or mandatory framework is implied by the initial policy. Those are future decisions, not hidden requirements of this skill.

## Validation approach

For changes to this skill or its wiring:

1. Use the installed loaders to verify valid frontmatter, unique discovery, and the effective role configuration. Check their returned data rather than asserting that configuration source contains a particular phrase.
2. Exercise ordinary test-writing and test-review tasks without naming or explicitly injecting this skill. Inspect the child transcript for an actual read and inspect the resulting tests or recommendations for the intended distinction.
3. Include counterexamples: actual textual output, release metadata, generated artifacts, and genuine static constraints must remain testable. Include a source-presence check that would pass despite broken behavior.
4. Treat a successful smoke test as bounded evidence, not proof that every future model or project will comply.

A check that `SKILL.md` contains the right slogans would reproduce the problem this skill is intended to solve.

## Background sources

- [Google Testing Blog: Change-Detector Tests Considered Harmful](https://testing.googleblog.com/2015/01/testing-on-toilet-change-detector-tests.html): explains the maintenance cost of tests that restate implementation rather than verify correctness.
- [MLIR Testing Guide: FileCheck best practices](https://mlir.llvm.org/getting_started/TestingGuide/#filecheck-best-practices): demonstrates useful output matching while warning against assertions on irrelevant output details.
- [Agent Skills specification: Progressive disclosure](https://agentskills.io/specification#progressive-disclosure): describes metadata-first discovery and on-demand loading of instructions and resources.

These sources support the design principles. The specific policy boundary and local Pi configuration are this operator's chosen application of those principles, not quotations from the sources.
