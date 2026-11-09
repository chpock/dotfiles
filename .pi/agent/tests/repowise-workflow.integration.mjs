import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { createHash } from "node:crypto";
import { execFileSync, spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";
import { parseArgs } from "node:util";

const { values } = parseArgs({ options: { "run-models": { type: "boolean" }, "check-cli-guard": { type: "boolean" }, "output-dir": { type: "string" }, case: { type: "string" } } });
if (!values["run-models"] && !values["check-cli-guard"]) {
  console.log("Opt-in model/MCP regression: pass --run-models --output-dir /absolute/evidence/path [--case name].");
  process.exit(0);
}
const outputDir = values["output-dir"];
assert.ok(typeof outputDir === "string" && path.isAbsolute(outputDir), "An explicit absolute evidence destination is required");
fs.mkdirSync(outputDir, { recursive: true });
const root = fileURLToPath(new URL("../../", import.meta.url));
const agentDir = path.join(root, "agent");
const version = fs.readFileSync(path.join(agentDir, "install/current-version"), "utf8").trim();
const host = path.join(agentDir, `install/releases/${version}/node_modules/@earendil-works/pi-coding-agent`);
const pi = await import(path.join(host, "dist/index.js"));
const adapter = path.join(agentDir, "npm/node_modules/pi-mcp-adapter/index.ts");
const realRepowise = execFileSync("which", ["repowise"], { encoding: "utf8" }).trim();
const originalPath = process.env.PATH;
const hash = (text) => createHash("sha256").update(text).digest("hex");
const git = (cwd, ...args) => execFileSync("git", ["-C", cwd, ...args], { encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] }).trim();
const upstream = ["ck-repowise", "codebase-exploration", "architectural-decisions", "pre-modification-check", "change-review", "code-health", "dead-code-cleanup"];
const source = `def summarize(values):\n    total = 0\n    for value in values:\n        if value is not None:\n            if value >= 0:\n                if value > 100:\n                    total += value * 2\n                else:\n                    total += value\n            else:\n                total -= value\n    return total\n`;

function snapshot(paths) {
  const result = {};
  function visit(file) {
    if (!fs.existsSync(file)) { result[file] = null; return; }
    const stat = fs.lstatSync(file);
    if (stat.isSymbolicLink()) { result[file] = `symlink:${fs.readlinkSync(file)}`; return; }
    if (stat.isDirectory()) {
      result[file] = "directory";
      for (const name of fs.readdirSync(file).sort()) visit(path.join(file, name));
    } else result[file] = hash(fs.readFileSync(file));
  }
  paths.forEach(visit);
  return result;
}

function makeFixture(name, spec) {
  const { kind } = spec;
  const directory = path.join(outputDir, name);
  assert.ok(!fs.existsSync(directory), `Use a fresh evidence directory: ${directory}`);
  fs.mkdirSync(directory, { recursive: true });
  let repository = path.join(directory, "repo");
  fs.mkdirSync(repository);
  fs.writeFileSync(path.join(repository, "parser.py"), source);
  fs.writeFileSync(path.join(repository, "README.md"), "# Workflow fixture\n\nSmall analysis fixture.\n");
  if (!kind.startsWith("nongit")) {
    git(repository, "init", "-q");
    git(repository, "add", "parser.py", "README.md");
    git(repository, "-c", "user.name=Workflow fixture", "-c", "user.email=fixture@example.invalid", "commit", "-qm", `test: add ${name} fixture`);
  } else {
    assert.throws(() => git(repository, "rev-parse", "--show-toplevel"), "Non-Git fixtures require an evidence destination outside existing Git worktrees");
  }
  let externalTarget;
  if (kind === "nongit-external") {
    externalTarget = path.join(repository, "target");
    fs.mkdirSync(externalTarget);
    fs.writeFileSync(path.join(externalTarget, "parser.py"), source);
    git(externalTarget, "init", "-q");
    git(externalTarget, "add", "parser.py");
    git(externalTarget, "-c", "user.name=Workflow fixture", "-c", "user.email=fixture@example.invalid", "commit", "-qm", `test: add ${name} nested fixture`);
  }
  let cwd = repository;
  if (kind === "subdirectory") { cwd = path.join(repository, "nested"); fs.mkdirSync(cwd); }
  if (kind === "worktree") {
    const worktree = path.join(directory, "linked");
    git(repository, "worktree", "add", "--detach", worktree, "HEAD");
    repository = worktree;
    cwd = worktree;
  }
  if (spec.seed) {
    const args = ["init", repository, "--no-workspace", "--no-prose", "--no-editor-setup", "--no-save-key", "--yes"];
    const output = execFileSync(realRepowise, args, { cwd: repository, env: { ...process.env, REPOWISE_SKIP_EDITOR_SETUP: "1", REPOWISE_TELEMETRY_DISABLED: "1" }, encoding: "utf8" });
    fs.writeFileSync(path.join(directory, "fixture-setup.log"), output);
    fs.appendFileSync(path.join(repository, "parser.py"), "\n\ndef pending_value():\n    return 42\n");
    if (spec.seed === "unsafe") {
      const config = path.join(repository, ".repowise/config.yaml");
      const text = fs.readFileSync(config, "utf8");
      assert.match(text, /^editor_setup:\s*false/m);
      fs.writeFileSync(config, text.replace(/^editor_setup:\s*false/m, "editor_setup: true"));
    }
  }
  const bin = path.join(directory, "bin");
  const cliLog = path.join(directory, "cli.jsonl");
  fs.mkdirSync(bin);
  // MCP stays alive until teardown, so its start must be visible before an exit event exists.
  fs.writeFileSync(path.join(bin, "repowise"), `#!${process.execPath}
const fs = require('node:fs');
const {spawnSync} = require('node:child_process');
const log = ${JSON.stringify(cliLog)};
const record = {event:'start',id:process.pid,args:process.argv.slice(2),cwd:process.cwd(),skipEditorSetup:process.env.REPOWISE_SKIP_EDITOR_SETUP};
fs.appendFileSync(log,JSON.stringify(record)+'\\n');
const finish = status => {fs.appendFileSync(log,JSON.stringify({event:'finish',id:process.pid,status})+'\\n');process.exit(status);};
if(record.skipEditorSetup !== '1'){console.error('Unsafe editor-migration environment in workflow fixture');finish(91);}
const command=record.args[0];
const usage=record.args.length===1&&['--help','--version'].includes(command)||record.args.length===2&&['init','update','mcp'].includes(command)&&record.args[1]==='--help';
const preparation=['init','update'].includes(command);
if(!usage&&!preparation&&!(command==='mcp'&&record.args.length===1)){console.error('Unsupported CLI command in workflow fixture');finish(95);}
const required=command==='init'?['--no-editor-setup','--no-workspace','--no-save-key','--yes']:['--working-tree','--no-agents','--no-workspace','--index-only'];
const allowed=command==='init'?[...required,'--no-prose','--index-only']:required;
if(!usage&&preparation&&(record.args[1]!==${JSON.stringify(repository)}||record.args.slice(2).some(flag=>!allowed.includes(flag))||!record.args.includes('--no-prose')&&!record.args.includes('--index-only')||required.some(flag=>!record.args.includes(flag)))){console.error('Unsafe preparation arguments in workflow fixture');finish(92);}
if(!usage&&command==='init'&&${Boolean(spec.failure)}){console.error('Injected fixture error: Repowise initialization backend is unavailable.');finish(93);}
if(!usage&&command==='update'&&${spec.seed === "unsafe"}){console.error('Unsafe refresh: existing editor preferences must not be changed.');finish(94);}
const result=spawnSync(${JSON.stringify(spec.backend ?? realRepowise)},record.args,{stdio:'inherit',env:process.env});
if(result.error)throw result.error;
finish(result.status ?? 1);
`, { mode: 0o755 });
  execFileSync(process.execPath, ["--check", path.join(bin, "repowise")]);
  return { directory, repository, cwd, bin, cliLog, externalTarget, initialHead: kind.startsWith("nongit") ? null : git(repository, "rev-parse", "HEAD") };
}

if (values["check-cli-guard"]) {
  const log = path.join(outputDir, "backend-calls.jsonl");
  const backend = path.join(outputDir, "backend.cjs");
  fs.writeFileSync(backend, `#!${process.execPath}\nrequire('node:fs').appendFileSync(${JSON.stringify(log)},JSON.stringify(process.argv.slice(2))+'\\n');\n`, { mode: 0o755 });
  const fixture = makeFixture("cli-guard", { kind: "git", backend });
  const init = ["init", fixture.repository, "--no-workspace", "--no-prose", "--no-editor-setup", "--no-save-key", "--yes"];
  const update = ["update", fixture.repository, "--no-workspace", "--index-only", "--working-tree", "--no-agents"];
  const rows = () => fs.existsSync(log) ? fs.readFileSync(log, "utf8").trim().split("\n").filter(Boolean).map(JSON.parse) : [];
  const checks = [
    { args: ["mcp"], status: 0 }, { args: ["--help"], status: 0 }, { args: ["--version"], status: 0 },
    { args: ["init", "--help"], status: 0 }, { args: init, status: 0 }, { args: update, status: 0 },
    { args: ["ask", "Do not synthesize"], status: 95 }, { args: ["generate"], status: 95 },
    { args: ["unknown-future-command"], status: 95 }, { args: ["--help", "ask"], status: 95 },
    { args: [...init, "--prose"], status: 92 }, { args: init.filter((arg) => arg !== "--no-prose"), status: 92 },
    { args: update.filter((arg) => arg !== "--index-only"), status: 92 },
    { args: [init[0], path.join(fixture.directory, "wrong-target"), ...init.slice(2)], status: 92 },
    { args: ["mcp"], status: 91, skipEditorSetup: "" },
  ];
  for (const check of checks) {
    const before = rows().length;
    const result = spawnSync(path.join(fixture.bin, "repowise"), check.args, { cwd: fixture.cwd, env: { ...process.env, REPOWISE_SKIP_EDITOR_SETUP: check.skipEditorSetup ?? "1" }, encoding: "utf8" });
    assert.ifError(result.error);
    assert.equal(result.status, check.status, JSON.stringify({ check, stdout: result.stdout, stderr: result.stderr }));
    assert.equal(rows().length, before + (check.status === 0 ? 1 : 0), "Rejected commands must never reach the backend");
    if (check.status === 0) assert.deepEqual(rows().at(-1), check.args);
  }
  const result = { passed: true, checks: checks.length, modelRequests: 0, realRepowiseInvocations: 0 };
  fs.writeFileSync(path.join(outputDir, "guard-summary.json"), JSON.stringify(result, null, 2) + "\n");
  console.log(JSON.stringify(result, null, 2));
  process.exit(0);
}

function callsFrom(messages) {
  return messages.flatMap((message) => message.role === "assistant" ? message.content.filter((part) => part.type === "toolCall") : []);
}
function facts(session, fixture) {
  const messages = session.messages;
  const calls = callsFrom(messages);
  const skillReads = calls.filter((call) => upstream.some((name) => JSON.stringify(call.arguments).includes(`${name}/SKILL.md`)));
  const mcp = calls.filter((call) => call.name === "mcp");
  const queries = mcp.filter((call) => call.arguments.tool?.startsWith("repowise_"));
  const results = messages.filter((message) => message.role === "toolResult");
  const queryEvidence = queries.map((call) => ({
    call,
    response: results.find((item) => item.toolCallId === call.id),
  }));
  const successfulQueries = queryEvidence.filter(({ response }) => {
    if (!response || response.isError) return false;
    const payload = response.details?.mcpResult?.structuredContent?.result;
    if (payload?.error) return false;
    return !/no[_ -]index|no repowise index|not initialized/i.test(JSON.stringify(response.content));
  }).map(({ call }) => call);
  const events = fs.existsSync(fixture.cliLog) ? fs.readFileSync(fixture.cliLog, "utf8").trim().split("\n").filter(Boolean).map(JSON.parse) : [];
  const cli = events.filter((event) => event.event === "start").map((event) => ({ ...event, status: events.find((end) => end.event === "finish" && end.id === event.id)?.status }));
  return {
    cwd: fixture.cwd, repository: fixture.repository,
    model: `${session.model.provider}/${session.model.id}`, thinking: session.thinkingLevel,
    modelMessages: messages.filter((message) => message.role === "assistant").map(({ model, provider, usage, stopReason }) => ({ model, provider, usage, stopReason })),
    calls, skillReads, mcp, queries, queryEvidence, successfulQueries, cli,
    permissionCalls: calls.filter((call) => call.name === "ask_user_question"),
    indexCreated: fs.existsSync(path.join(fixture.repository, ".repowise", "wiki.db")),
    output: session.getLastAssistantText(),
  };
}

async function verifyConnection(session, fixture) {
  const gateway = session.agent.state.tools.find((tool) => tool.name === "mcp");
  assert.ok(gateway);
  const invoke = async (args) => {
    const result = await gateway.execute(`verification-${Date.now()}`, args, new AbortController().signal);
    assert.ok(!result.isError, JSON.stringify(result));
    return result;
  };
  const catalog = await invoke({ server: "repowise" });
  const overviewName = JSON.stringify(catalog.content).match(/\b([A-Za-z0-9_]*get_overview)\b/)?.[1];
  assert.ok(overviewName, "The real catalog must expose an overview tool");
  await invoke({ describe: overviewName, server: "repowise" });
  const response = await invoke({ tool: overviewName, args: { include: ["scope"] } });
  const payload = response.details?.mcpResult?.structuredContent?.result;
  assert.ok(payload && !payload.error, JSON.stringify(response));
  const servedHead = payload._meta?.live_head ?? payload._meta?.indexed_commit;
  assert.ok(servedHead?.length >= 8 && git(fixture.repository, "rev-parse", "HEAD").startsWith(servedHead), "A separate real query must identify this fixture's unique Git HEAD");
  assert.ok(payload._meta?.index_scope?.file_pages?.eligible >= 1, "The real index must contain an eligible code file");
  assert.equal(payload._meta?.index_scope?.content_provenance, "template", "Preparation must not generate model-written documentation");
  return { tool: overviewName, response };
}

const cases = {
  "main-health": { kind: "git", eligible: true, prompt: "Оцени code health и поддерживаемость parser.py. Выяви главное место для упрощения. Исходники не меняй." },
  "main-exploration": { kind: "git", eligible: true, prompt: "Исследуй структуру проекта: найди точку входа обработки values и объясни основные ветви данных. Названия файлов заранее неизвестны; исходники не меняй." },
  "main-edit": { kind: "git", eligible: true, edit: true, prompt: "Переименуй функцию summarize в parser.py в summarize_values, не меняя её поведения. Другие изменения не нужны." },
  "nongit-health": { kind: "nongit", eligible: false, prompt: "Оцени code health и поддерживаемость parser.py. Выяви главное место для упрощения. Исходники не меняй." },
  "nongit-external-target": { kind: "nongit-external", eligible: false, prompt: "Оцени code health и поддерживаемость target/parser.py перед его рефакторингом. Исходники не меняй." },
  "nongit-edit": { kind: "nongit", eligible: false, edit: true, prompt: "Переименуй функцию summarize в parser.py в summarize_values, не меняя её поведения. Другие изменения не нужны." },
  "git-unrelated": { kind: "git", eligible: false, prompt: "Переведи на русский: The small garden is quiet. Ответь только переводом." },
  "git-lookup": { kind: "git", eligible: false, prompt: "Прочитай README.md и сообщи только его заголовок. Анализ проекта не требуется." },
  "subdirectory-health": { kind: "subdirectory", eligible: true, prompt: "Оцени code health и поддерживаемость ../parser.py. Выяви главное место для упрощения. Исходники не меняй." },
  "worktree-health": { kind: "worktree", eligible: true, prompt: "Оцени code health и поддерживаемость parser.py. Выяви главное место для упрощения. Исходники не меняй." },
  "safe-refresh": { kind: "git", eligible: true, seed: "safe", prompt: "Оцени влияние планируемого рефакторинга parser.py на текущую кодовую базу. Код изменился после предыдущего индекса: сопоставь текущий набор функций с индексом; для выводов нужны актуальные индексированные структурные факты, не только чтение файла. Исходники не изменяй." },
  "unsafe-refresh": { kind: "git", eligible: true, seed: "unsafe", gap: true, prompt: "Оцени влияние планируемого рефакторинга parser.py на текущую кодовую базу. Код изменился после предыдущего индекса: сопоставь текущий набор функций с индексом; для выводов нужны актуальные индексированные структурные факты. Исходники и существующие настройки не изменяй; если актуализация недоступна, явно обозначь ограничение и продолжи по исходникам." },
  "failed-preparation": { kind: "git", eligible: true, failure: true, gap: true, prompt: "Оцени code health и поддерживаемость parser.py перед рефакторингом. Исходники не меняй. Если вспомогательные средства недоступны, явно обозначь ограничение и продолжи по исходникам." },
};
const selected = values.case ? [values.case] : Object.keys(cases);
const summary = [];
pi.initTheme("dark");
for (const name of selected) {
  assert.ok(cases[name], `Unknown case: ${name}`);
  const spec = cases[name];
  const fixture = makeFixture(name, spec);
  const globalPaths = [".claude.json", ".claude/settings.json", ".claude/settings.local.json", ".codex/config.toml", ".codex/hooks.json", ".repowise/editor-migrations"].map((file) => path.join(os.homedir(), file));
  const protectedPaths = [...globalPaths, ...["README.md", "AGENTS.md", "CLAUDE.md", ".gitignore", ".mcp.json", ".claude", ".vscode"].map((file) => path.join(fixture.repository, file))];
  if (!spec.kind.startsWith("nongit")) {
    const commonGitDir = git(fixture.repository, "rev-parse", "--path-format=absolute", "--git-common-dir");
    protectedPaths.push(path.join(commonGitDir, "hooks"), path.join(commonGitDir, "info", "exclude"));
  }
  if (!spec.edit) protectedPaths.push(path.join(fixture.repository, "parser.py"));
  if (fixture.externalTarget) protectedPaths.push(path.join(fixture.externalTarget, "parser.py"), path.join(fixture.externalTarget, ".repowise"));
  if (spec.seed === "unsafe") protectedPaths.push(path.join(fixture.repository, ".repowise/config.yaml"));
  const before = snapshot(protectedPaths);
  process.env.PATH = fixture.bin + path.delimiter + originalPath;
  const extensionErrors = [];
  const settingsManager = pi.SettingsManager.create(fixture.cwd, agentDir, { projectTrusted: true });
  const guard = (api) => api.on("tool_call", (event) => {
    if (event.toolName === "mcp" && (!spec.eligible || event.input.tool?.endsWith("get_answer"))) {
      return { block: true, reason: "This fixture forbids this Repowise call; attempted use is recorded as a regression." };
    }
  });
  const loader = new pi.DefaultResourceLoader({
    cwd: fixture.cwd, agentDir, settingsManager, noExtensions: true,
    additionalExtensionPaths: [adapter], noThemes: true, noPromptTemplates: true,
    extensionFactories: [guard],
  });
  let session;
  try {
    await loader.reload();
    assert.deepEqual(loader.getExtensions().errors, []);
    assert.ok(loader.getAgentsFiles().agentsFiles.some((file) => file.path === path.join(agentDir, "AGENTS.md")), "Real shared policy must be loaded");
    assert.ok(loader.getSkills().skills.some((skill) => skill.name === "ck-repowise"), "Real lazy skill catalog must be advertised");
    const created = await pi.createAgentSession({ cwd: fixture.cwd, agentDir, settingsManager, resourceLoader: loader, sessionManager: pi.SessionManager.create(fixture.cwd, path.join(fixture.directory, "sessions")) });
    session = created.session;
    await session.bindExtensions({ mode: "print", onError: (error) => extensionErrors.push(error) });
    const initialSource = fs.readFileSync(path.join(fixture.repository, "parser.py"), "utf8");
    let indexedQueryCompleted = false;
    let indexedBeforeSourceEdit = null;
    const unsubscribe = session.subscribe((event) => {
      if (event.type !== "tool_execution_end") return;
      const file = path.join(fixture.repository, "parser.py");
      const currentSource = fs.existsSync(file) ? fs.readFileSync(file, "utf8") : null;
      if (indexedBeforeSourceEdit === null && currentSource !== initialSource) indexedBeforeSourceEdit = indexedQueryCompleted;
      const payload = event.result?.details?.mcpResult?.structuredContent?.result;
      if (event.toolName === "mcp" && !event.isError && payload && !payload.error) indexedQueryCompleted = true;
    });
    console.log(`Running ${name}: ${session.model.provider}/${session.model.id}, cwd=${fixture.cwd}`);
    try { await session.prompt(spec.prompt); } finally { unsubscribe(); }
    assert.ok(session.systemPrompt.includes(fs.readFileSync(path.join(agentDir, "AGENTS.md"), "utf8").trim()), "The real shared policy must reach the model");
    const result = { ...facts(session, fixture), indexedBeforeSourceEdit };
    if (spec.eligible && result.indexCreated) result.harnessVerification = await verifyConnection(session, fixture);
    fs.writeFileSync(path.join(fixture.directory, "trace.json"), JSON.stringify(result, null, 2) + "\n");
    assert.ok(result.modelMessages.some((message) => message.usage?.totalTokens > 0), "A real model request is required");
    assert.deepEqual(result.permissionCalls, [], "Preparation must not ask the operator for approval");
    assert.deepEqual(extensionErrors, [], "Extension failures invalidate the probe");
    assert.deepEqual(snapshot(protectedPaths), before, "Source/editor/hook state must remain unchanged");
    if (fixture.initialHead) assert.equal(git(fixture.repository, "rev-parse", "HEAD"), fixture.initialHead, "No commit is authorized by these tasks");
    if (spec.eligible) {
      assert.equal(result.indexCreated, !spec.failure, "Eligible work must prepare its index or expose a real preparation failure");
      assert.ok(result.skillReads.some((call) => JSON.stringify(call.arguments).includes("ck-repowise/SKILL.md")), "Integration body must be read before use");
      if (!spec.failure) assert.ok(result.successfulQueries.length > 0, "An actual successful Repowise query is required");
      const servers = result.cli.filter((entry) => entry.args[0] === "mcp");
      assert.ok(servers.length > 0 && servers.every((entry) => git(entry.cwd, "rev-parse", "--show-toplevel") === fixture.repository), "Real MCP processes must be rooted in this fixture's worktree");
      const initializations = result.cli.filter((entry) => entry.args[0] === "init").length;
      if (spec.failure) assert.ok(initializations >= 1, "Preparation must actually be attempted");
      else assert.equal(initializations, spec.seed ? 0 : 1, "Only a missing index should be initialized");
      const updates = result.cli.filter((entry) => entry.args[0] === "update").length;
      if (spec.seed === "safe") assert.ok(result.cli.some((entry) => entry.args[0] === "update" && entry.status === 0), "Changed required structural facts must refresh successfully and automatically");
      if (!spec.seed && !spec.failure) assert.ok(result.cli.some((entry) => entry.args[0] === "init" && entry.status === 0), "Initialization must actually exit successfully");
      if (spec.seed === "unsafe") assert.equal(updates, 0, "Incompatible existing preferences must block refresh");
      if (!spec.gap) assert.match(fs.readFileSync(path.join(fixture.repository, ".repowise/config.yaml"), "utf8"), /editor_setup:\s*false/);
      if (spec.gap) {
        assert.match(result.output, /repowise|индекс|index/i, "Report the unavailable indexing capability");
        assert.match(result.output, /не удалось|недоступ|ошиб|не обнов|огранич|сбой|fail|unavailable|blocked|constraint|editor_setup/i, "The remaining preparation/freshness gap must be explicit");
      }
      assert.ok(result.cli.every((entry) => entry.skipEditorSetup === "1"));
    } else {
      assert.equal(result.skillReads.length, 0, "Excluded work must not load Repowise skill bodies");
      assert.equal(result.mcp.length, 0, "Excluded work must not attempt Repowise MCP use");
      assert.equal(result.indexCreated, false, "Excluded work must not create an index");
      assert.equal(result.cli.filter((entry) => ["init", "update"].includes(entry.args[0])).length, 0);
    }
    if (spec.kind.startsWith("nongit")) assert.throws(() => git(fixture.cwd, "rev-parse", "--show-toplevel"), "Excluded work must not create a Git repository to bypass eligibility");
    if (spec.edit) {
      const file = path.join(fixture.repository, "parser.py");
      assert.match(fs.readFileSync(file, "utf8"), /def summarize_values\(/);
      execFileSync("python3", ["-c", "import ast, pathlib, sys\nexpected = ast.parse(sys.argv[1])\nexpected.body[0].name = 'summarize_values'\nactual = ast.parse(pathlib.Path(sys.argv[2]).read_text())\nassert ast.dump(actual) == ast.dump(expected), 'Only the requested function rename is authorized'", source, file]);
      if (spec.eligible) assert.equal(result.indexedBeforeSourceEdit, true, "Indexed assessment must complete before source bytes change");
    }
    summary.push({ name, passed: true, model: result.model, skillReads: result.skillReads.length, queries: result.successfulQueries.length, init: result.cli.filter((entry) => entry.args[0] === "init").length, updates: result.cli.filter((entry) => entry.args[0] === "update").length, expectedGap: Boolean(spec.gap) });
    console.log(`PASS ${name}`);
  } finally {
    if (session) {
      if (session.extensionRunner.hasHandlers("session_shutdown")) await session.extensionRunner.emit({ type: "session_shutdown", reason: "quit" });
      session.dispose();
    }
    process.env.PATH = originalPath;
    fs.writeFileSync(path.join(outputDir, "summary.json"), JSON.stringify(summary, null, 2) + "\n");
  }
}
