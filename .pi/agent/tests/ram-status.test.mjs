import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import test from "node:test";

const agentDir = fileURLToPath(new URL("../", import.meta.url));
const version = (await readFile(new URL("../install/current-version", import.meta.url), "utf8")).trim();
const piDir = new URL(`../install/releases/${version}/node_modules/@earendil-works/pi-coding-agent/`, import.meta.url);
const { loadExtensions } = await import(new URL("dist/core/extensions/loader.js", piDir));
const { ExtensionRunner } = await import(new URL("dist/core/extensions/runner.js", piDir));
const extensionPath = fileURLToPath(new URL("../extensions/ram-status.ts", import.meta.url));
const MiB = 1024 ** 2;
const GiB = 1024 ** 3;
const mcStatus = "mc: 41.6K (11%) · idle";

async function createHarness(t, mode = "tui") {
  const loaded = await loadExtensions([extensionPath], agentDir);
  assert.deepEqual(loaded.errors, []);
  assert.equal(loaded.extensions.length, 1);

  const runner = new ExtensionRunner(loaded.extensions, loaded.runtime, agentDir, undefined, undefined);
  const errors = [];
  runner.onError((error) => errors.push(error));
  const statuses = new Map([["magic-context", mcStatus]]);
  const updates = [];
  runner.setUIContext({
    setStatus(key, text) {
      updates.push([key, text]);
      if (text === undefined) statuses.delete(key);
      else statuses.set(key, text);
    },
  }, mode);

  let rss = MiB;
  const sample = t.mock.method(process.memoryUsage, "rss", () => rss);
  t.mock.timers.enable({ apis: ["setInterval"] });
  t.after(async () => {
    await runner.emit({ type: "session_shutdown" });
    t.mock.timers.reset();
    assert.deepEqual(errors, []);
  });

  return {
    runner,
    statuses,
    updates,
    sample,
    setRss: (bytes) => { rss = bytes; },
    start: () => runner.emit({ type: "session_start", reason: "startup" }),
    stop: () => runner.emit({ type: "session_shutdown" }),
  };
}

test("formats RSS with three significant digits and no fractional trailing zeros", async (t) => {
  const h = await createHarness(t);
  const cases = [
    [0, "0 MiB"],
    [0.125 * MiB, "0.125 MiB"],
    [MiB, "1 MiB"],
    [1.2 * MiB, "1.2 MiB"],
    [1.45 * MiB, "1.45 MiB"],
    [1.456 * MiB, "1.46 MiB"],
    [1.999 * MiB, "2 MiB"],
    [10 * MiB, "10 MiB"],
    [12.04 * MiB, "12 MiB"],
    [34.2 * MiB, "34.2 MiB"],
    [100 * MiB, "100 MiB"],
    [567 * MiB, "567 MiB"],
    [567.8 * MiB, "568 MiB"],
    [999.6 * MiB, "1000 MiB"],
    [1023 * MiB, "1020 MiB"],
    [GiB - 1, "1020 MiB"],
    [GiB, "1 GiB"],
    [GiB + 1, "1 GiB"],
    [1.2 * GiB, "1.2 GiB"],
    [1.7 * GiB, "1.7 GiB"],
    [1.456 * GiB, "1.46 GiB"],
    [10 * GiB, "10 GiB"],
    [34.2 * GiB, "34.2 GiB"],
    [567 * GiB, "567 GiB"],
  ];
  for (const [bytes, expected] of cases) {
    h.setRss(Math.round(bytes));
    await h.start();
    assert.equal(h.statuses.get("ram"), `ram: ${expected}`, `${bytes} bytes`);
  }
});

test("does not sample memory or start polling during extension loading", async (t) => {
  const h = await createHarness(t);
  t.mock.timers.tick(6000);
  assert.equal(h.sample.mock.callCount(), 0);
  assert.deepEqual(h.updates, []);
});

test("publishes immediately, then samples fresh RSS every two seconds", async (t) => {
  const h = await createHarness(t);
  h.setRss(567 * MiB);
  await h.start();
  assert.equal(h.statuses.get("ram"), "ram: 567 MiB");
  assert.equal(h.sample.mock.callCount(), 1);

  h.setRss(1.7 * GiB);
  t.mock.timers.tick(1999);
  assert.equal(h.sample.mock.callCount(), 1);
  t.mock.timers.tick(1);
  assert.equal(h.statuses.get("ram"), "ram: 1.7 GiB");
  assert.equal(h.sample.mock.callCount(), 2);

  h.setRss(34.2 * MiB);
  t.mock.timers.tick(2000);
  assert.equal(h.statuses.get("ram"), "ram: 34.2 MiB");
  assert.equal(h.sample.mock.callCount(), 3);
  assert.equal(h.statuses.get("magic-context"), mcStatus);
});

test("a repeated session start does not leave duplicate pollers", async (t) => {
  const h = await createHarness(t);
  await h.start();
  await h.start();
  const samples = h.sample.mock.callCount();
  t.mock.timers.tick(2000);
  assert.equal(h.sample.mock.callCount(), samples + 1);
});

test("shutdown clears only the RAM status and stops polling idempotently", async (t) => {
  const h = await createHarness(t);
  await h.start();
  await h.stop();
  await h.stop();
  assert.equal(h.statuses.has("ram"), false);
  assert.equal(h.statuses.get("magic-context"), mcStatus);
  const samples = h.sample.mock.callCount();
  const updates = h.updates.length;
  t.mock.timers.tick(10000);
  assert.equal(h.sample.mock.callCount(), samples);
  assert.equal(h.updates.length, updates);
});

test("polling restarts cleanly after session replacement or reload shutdown", async (t) => {
  const h = await createHarness(t);
  await h.start();
  await h.stop();
  t.mock.timers.tick(6000);
  h.setRss(1.2 * GiB);
  await h.start();
  assert.equal(h.statuses.get("ram"), "ram: 1.2 GiB");
  const samples = h.sample.mock.callCount();
  t.mock.timers.tick(2000);
  assert.equal(h.sample.mock.callCount(), samples + 1);
});

for (const mode of ["print", "json", "rpc"]) {
  test(`does not publish or poll in ${mode} mode`, async (t) => {
    const h = await createHarness(t, mode);
    await h.start();
    await h.stop();
    t.mock.timers.tick(6000);
    assert.equal(h.sample.mock.callCount(), 0);
    assert.deepEqual(h.updates, []);
    assert.equal(h.statuses.get("magic-context"), mcStatus);
  });
}
