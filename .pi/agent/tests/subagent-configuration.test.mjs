import assert from "node:assert/strict";
import { mkdir, mkdtemp, readFile, rm, writeFile } from "node:fs/promises";
import { homedir, tmpdir } from "node:os";
import { join } from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";

const agentDir = fileURLToPath(new URL("../", import.meta.url));
const cwd = fileURLToPath(new URL("../../", import.meta.url));
const version = (await readFile(new URL("../install/current-version", import.meta.url), "utf8")).trim();
const piDir = new URL(`../install/releases/${version}/node_modules/@earendil-works/pi-coding-agent/`, import.meta.url);
const subagentsDir = new URL("../npm/node_modules/pi-subagents/", import.meta.url);
const { discoverAgents } = await import(new URL("src/agents/agents.js", subagentsDir));
const { resolveSkills } = await import(new URL("src/agents/skills.js", subagentsDir));
const { parseFrontmatter } = await import(new URL("src/agents/frontmatter.js", subagentsDir));
const { buildEffectiveSystemPrompt } = await import(new URL("src/runs/shared/effective-system-prompt.js", subagentsDir));
const { DefaultPackageManager } = await import(new URL("dist/core/package-manager.js", piDir));
const { SettingsManager } = await import(new URL("dist/core/settings-manager.js", piDir));
const { loadSkills } = await import(new URL("dist/core/skills.js", piDir));
const settings = JSON.parse(await readFile(new URL("../settings.json", import.meta.url), "utf8"));
const discovery = discoverAgents(cwd, "both", settings.defaultProvider);
const repowiseSkills = ["codebase-exploration", "architectural-decisions", "pre-modification-check", "change-review", "code-health", "dead-code-cleanup"];
const repowiseAdvisorySkills = repowiseSkills.filter((name) => name !== "pre-modification-check");
const executorSkills = ["agent-browser", "ck-testing", "writing-for-agents", "codebase-design", "ck-repowise", ...repowiseSkills];
const advisorySkills = ["grill-for-unknowns", "ck-testing", "writing-for-agents", "codebase-design", "ck-repowise", ...repowiseAdvisorySkills];
const expectedCatalogs = {
  worker: executorSkills,
  delegate: executorSkills,
  reviewer: advisorySkills,
  oracle: advisorySkills,
  "second-opinion": ["codebase-design", "ck-repowise", ...repowiseAdvisorySkills],
  scout: ["ck-repowise", "codebase-exploration"],
  researcher: ["ck-repowise", "codebase-exploration", "architectural-decisions"],
  "evidence-auditor": ["ck-repowise", "codebase-exploration", "architectural-decisions"],
};

function role(name) {
  const agent = discovery.agents.find((candidate) => candidate.name === name);
  assert.ok(agent, `${name} must be discoverable`);
  return agent;
}

test("native role discovery accepts the configured overrides", () => {
  assert.deepEqual(discovery.agentDiagnostics, []);
  assert.deepEqual(discovery.agents.map((agent) => agent.name).sort(), Object.keys(expectedCatalogs).sort());
});

for (const [name, expected] of Object.entries(expectedCatalogs)) {
  test(`${name} exposes its selected catalog lazily without ambient inheritance`, () => {
    const agent = role(name);
    assert.equal(agent.inheritSkills, false);
    assert.deepEqual(agent.skills, expected);
    const skills = resolveSkills(agent.skills, cwd);
    assert.deepEqual(skills.missing, []);
    assert.deepEqual(skills.resolved.map((skill) => skill.name), expected);
    assert.ok(skills.resolved.every((skill) => !skill.disableModelInvocation));
    const prompt = buildEffectiveSystemPrompt({ agent, resolvedSkills: skills.resolved, cwd });
    assert.equal(prompt.includes("<name>codebase-design</name>"), expected.includes("codebase-design"));
    const repowise = skills.resolved.find((skill) => skill.name === "ck-repowise");
    assert.ok(repowise);
    assert.equal(repowise.path, join(agentDir, "skills", "ck-repowise", "SKILL.md"));
    assert.ok(prompt.includes("<name>ck-repowise</name>"));
    assert.equal(prompt.includes(repowise.content), false);
    assert.ok(agent.tools.includes("mcp"));
    assert.ok(agent.subagentOnlyExtensions.includes("~/.pi/agent/npm/node_modules/pi-mcp-adapter/index.ts"));
    for (const skillName of repowiseSkills) {
      const selected = skills.resolved.find((skill) => skill.name === skillName);
      assert.equal(prompt.includes(`<name>${skillName}</name>`), expected.includes(skillName));
      if (selected) {
        assert.equal(selected.path, join(homedir(), ".agents", "skills", skillName, "SKILL.md"));
        assert.equal(prompt.includes(selected.content), false);
      }
    }
    const design = skills.resolved.find((skill) => skill.name === "codebase-design");
    if (design) {
      assert.equal(design.path, join(homedir(), ".agents", "skills", "codebase-design", "SKILL.md"));
      assert.equal(prompt.includes(design.content), false);
    }
  });
}

test("second-opinion role-specific settings have one owner and preserve its inspection boundary", async () => {
  const definition = parseFrontmatter(await readFile(new URL("../agents/second-opinion.md", import.meta.url), "utf8"));
  assert.deepEqual(Object.keys(definition.frontmatter).sort(), ["description", "name"]);
  const configured = settings.subagents.agentOverrides["second-opinion"];
  const agent = role("second-opinion");
  const expected = {
    model: "opencode-go/deepseek-v4.1-flash",
    thinking: "max",
    advertise: true,
    acceptanceRole: "read-only",
    systemPromptMode: "replace",
    inheritProjectContext: true,
    inheritGlobalContext: true,
    inheritSkills: false,
    defaultContext: "fresh",
    skills: expectedCatalogs["second-opinion"],
    extensions: ["~/.pi/agent/npm/node_modules/pi-web-access/dist/index.js"],
    tools: ["read", "grep", "find", "ls", "web_search", "fetch_content", "get_search_content", "source_check", "contact_supervisor", "mcp"],
  };
  assert.deepEqual(configured, expected);
  for (const [field, value] of Object.entries(expected)) {
    assert.deepEqual(agent[field], value, field);
  }
  assert.equal(agent.systemPrompt, definition.body);
});

test("main native resource discovery retains design and repository guidance", async () => {
  // Keep package installation and extension execution outside a discovery-only check.
  const settingsManager = SettingsManager.inMemory({ skills: settings.skills ?? [] });
  const manager = new DefaultPackageManager({ cwd, agentDir, settingsManager });
  const resources = await manager.resolve();
  assert.deepEqual(resources.installFailures, []);
  const loaded = loadSkills({ cwd, agentDir, includeDefaults: false, skillPaths: resources.skills.filter((resource) => resource.enabled).map((resource) => resource.path) });
  const names = loaded.skills.map((skill) => skill.name);
  assert.ok(names.includes("codebase-design"));
  assert.ok(names.includes("ck-repowise"));
  for (const name of repowiseSkills) assert.ok(names.includes(name), name);
});


test("project catalog overrides and local skill definitions keep native precedence", async (t) => {
  const project = await mkdtemp(join(tmpdir(), "pi-skill-precedence-"));
  t.after(() => rm(project, { recursive: true, force: true }));
  await mkdir(join(project, ".pi"), { recursive: true });
  await writeFile(join(project, ".pi", "settings.json"), JSON.stringify({
    subagents: { agentOverrides: { worker: { skills: ["ck-testing"] } } },
  }));
  const localDir = join(project, ".agents", "skills", "codebase-design");
  await mkdir(localDir, { recursive: true });
  await writeFile(join(localDir, "SKILL.md"), "---\nname: codebase-design\ndescription: Project-specific design guidance\n---\n\n# Local design guidance\n");

  const projectAgents = discoverAgents(project, "both", settings.defaultProvider);
  assert.deepEqual(projectAgents.agentDiagnostics, []);
  const worker = projectAgents.agents.find((agent) => agent.name === "worker");
  assert.deepEqual(worker.skills, ["ck-testing"]);
  assert.equal(worker.model, role("worker").model);
  assert.deepEqual(worker.tools, role("worker").tools);
  const selected = resolveSkills(["codebase-design"], project);
  assert.deepEqual(selected.missing, []);
  assert.equal(selected.resolved[0].path, join(localDir, "SKILL.md"));
  assert.equal(selected.resolved[0].content, "# Local design guidance");
});


test("new native roles inherit the shared MCP provider without overriding explicit provider lists or tool grants", async (t) => {
  const project = await mkdtemp(join(tmpdir(), "pi-mcp-default-"));
  t.after(() => rm(project, { recursive: true, force: true }));
  const agentsDir = join(project, ".pi", "agents");
  await mkdir(agentsDir, { recursive: true });
  const webExtension = join(agentDir, "npm", "node_modules", "pi-web-access", "dist", "index.js");
  await writeFile(join(project, ".pi", "settings.json"), JSON.stringify({
    subagents: { agentOverrides: { "mcp-empty-fixture": { subagentOnlyExtensions: [] } } },
  }));
  for (const [name, provider] of [["mcp-default-fixture", ""], ["mcp-explicit-fixture", `subagentOnlyExtensions: ${webExtension}\n`], ["mcp-empty-fixture", ""]]) {
    await writeFile(join(agentsDir, `${name}.md`), `---\nname: ${name}\ndescription: Native provider precedence fixture\ntools: read\n${provider}---\n\nInspect assigned files without changes.\n`);
  }
  const loaded = discoverAgents(project, "both", settings.defaultProvider);
  assert.deepEqual(loaded.agentDiagnostics, []);
  for (const [name, expected] of [
    ["mcp-default-fixture", ["~/.pi/agent/npm/node_modules/pi-mcp-adapter/index.ts"]],
    ["mcp-explicit-fixture", [webExtension]],
    ["mcp-empty-fixture", []],
  ]) {
    const agent = loaded.agents.find((candidate) => candidate.name === name);
    assert.ok(agent, name);
    assert.deepEqual(agent.subagentOnlyExtensions, expected, name);
    assert.deepEqual(agent.tools, ["read"], name);
  }
});


test("a project child-only default replaces the user default without changing builtin tool grants", async (t) => {
  const project = await mkdtemp(join(tmpdir(), "pi-mcp-project-default-"));
  t.after(() => rm(project, { recursive: true, force: true }));
  await mkdir(join(project, ".pi"), { recursive: true });
  const webExtension = join(agentDir, "npm", "node_modules", "pi-web-access", "dist", "index.js");
  for (const providers of [[], [webExtension]]) {
    await writeFile(join(project, ".pi", "settings.json"), JSON.stringify({
      subagents: { defaultSubagentOnlyExtensions: providers },
    }));
    const loaded = discoverAgents(project, "both", settings.defaultProvider);
    assert.deepEqual(loaded.agentDiagnostics, []);
    const worker = loaded.agents.find((agent) => agent.name === "worker");
    assert.ok(worker);
    assert.deepEqual(worker.subagentOnlyExtensions, providers);
    assert.deepEqual(worker.extensions, role("worker").extensions);
    assert.deepEqual(worker.tools, role("worker").tools);
  }
});
