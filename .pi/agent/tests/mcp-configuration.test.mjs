import assert from "node:assert/strict";
import test from "node:test";
import { fileURLToPath } from "node:url";
import { loadMcpConfig, setPiMcpConfigEnabled } from "../npm/node_modules/pi-mcp-adapter/dist/config.js";

const cwd = fileURLToPath(new URL("../../", import.meta.url));
setPiMcpConfigEnabled(true);
const config = loadMcpConfig(undefined, cwd);

test("effective MCP configuration retains the selected repository server and proxy policy", () => {
  assert.deepEqual(Object.keys(config.mcpServers), ["repowise"]);
  const server = config.mcpServers.repowise;
  assert.equal(server.command, "repowise");
  assert.deepEqual(server.args, ["mcp"]);
  assert.equal(server.cwd, undefined);
  assert.equal(server.lifecycle, undefined);
  assert.equal(config.settings.directTools, false);
  assert.equal(config.settings.namespaceProxyTools, false);
  assert.equal(config.settings.allowInstall, false);
});
