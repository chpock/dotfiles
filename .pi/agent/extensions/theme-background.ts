/*
 * Based on umbra-background.ts from pi-umbra (pi-umbra-theme 0.2.1):
 * https://github.com/grknbyk/pi-umbra/tree/main/pi-umbra-theme
 * Automatic terminal colors from the active theme: export.pageBg and colors.text.
 *
 * MIT License
 * Copyright (c) 2026 grkn
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import { readFileSync } from "node:fs";
import type { ExtensionAPI, ExtensionContext, Theme } from "@earendil-works/pi-coding-agent";
import { colorToHex, parseColor } from "@earendil-works/pi-tui";

function terminalColors(ctx: ExtensionContext): { background?: string; text?: string } {
  const theme = ctx.ui.theme;
  const path = theme.sourcePath ?? ctx.ui.getAllThemes().find((entry) => entry.name === theme.name)?.path;
  if (!path) return {};
  try {
    const json = JSON.parse(readFileSync(path, "utf8"));
    const resolve = (value: unknown): string | undefined => {
      try {
        const visited = new Set<string>();
        while (typeof value === "string" && Object.hasOwn(json.vars ?? {}, value)) {
          if (visited.has(value)) return undefined;
          visited.add(value);
          value = json.vars[value];
        }
        // An empty token means terminal default: reset, rather than pin a guessed color.
        if (value === "" || (typeof value !== "string" && typeof value !== "number")) return undefined;
        return colorToHex(parseColor(value));
      } catch {
        return undefined;
      }
    };
    return { background: resolve(json.export?.pageBg), text: resolve(json.colors?.text) };
  } catch {
    return {};
  }
}

export default function themeBackground(pi: ExtensionAPI) {
  let background: string | undefined;
  let text: string | undefined;
  let watched: Theme["colors"] | undefined;
  let watcher: ReturnType<typeof setInterval> | undefined;

  const sync = (code: 10 | 11, current: string | undefined, hex: string | undefined) => {
    if (hex !== current) {
      process.stdout.write(hex === undefined ? `\x1b]${code + 100}\x07` : `\x1b]${code};${hex}\x07`);
    }
    return hex;
  };

  const apply = (ctx: ExtensionContext) => {
    watched = ctx.ui.theme.colors;
    const colors = terminalColors(ctx);
    background = sync(11, background, colors.background);
    text = sync(10, text, colors.text);
  };

  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui") return;
    if (watcher !== undefined) clearInterval(watcher);
    apply(ctx);
    // Pi has no public theme-change event, and ui.theme is a stable forwarding Proxy.
    // Its cached colors change on theme switches and same-name hot reloads.
    watcher = setInterval(() => {
      if (ctx.ui.theme.colors !== watched) apply(ctx);
    }, 250);
    watcher.unref();
  });

  pi.on("session_shutdown", () => {
    if (watcher !== undefined) clearInterval(watcher);
    watcher = undefined;
    watched = undefined;
    // OSC 110/111 restore terminal profile defaults, not earlier dynamic overrides.
    background = sync(11, background, undefined);
    text = sync(10, text, undefined);
  });
}
