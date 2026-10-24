// installed by herdr
// LOCALLY PATCHED for pi-subagents background work; NOT the stock integration.
// managed by herdr; reinstalling or updating the integration overwrites this file.
// HERDR_INTEGRATION_ID=pi
// HERDR_INTEGRATION_VERSION=9
// @ts-nocheck

/*
 * Local patch based on Herdr v0.9.3 / Pi integration v9.
 * The integration identifiers above describe the upstream base, not this patch.
 *
 * Why: upstream tracks only the parent agent's activity. When the parent ends
 * its turn while async subagents still run, it reports idle, which Herdr can
 * display as done and announce as a completion.
 *
 * pi-subagents (verified with 0.76.1) already emits paired herdr:busy events
 * { active: true/false, label?: string }. This patch consumes them here so the
 * existing herdr:pi publisher remains the single owner of lifecycle state:
 * blocked takes precedence; parent OR background activity means working;
 * otherwise idle. A separate lifecycle reporter would compete with this one.
 * The producer still owns child tracking and pane labels; no child polling here.
 *
 * LOCAL PATCH comments below mark the changed state calculation, new event
 * handler, and startup/shutdown guards. The transport and state-report queue
 * are unchanged. Reload startup may report idle before pi-subagents restores busy.
 * Shutdown suppression assumes our session_shutdown handler runs before the
 * producer's cleanup; reversing that order can also report idle. Uninterrupted
 * working across /reload is outside this patch's accepted scope.
 *
 * Regression tests: ../tests/herdr-busy.test.mjs (also run rpiv-herdr-bridge.test.mjs).
 * Rationale/review: ../../experiments/herdr-busy/review-findings.md.
 */

import net from "node:net";
import path from "node:path";

const HERDR_ENV = process.env.HERDR_ENV;
const socketPath = process.env.HERDR_SOCKET_PATH;
const socketEndpoint =
  process.platform === "win32" && socketPath ? `\\\\.\\pipe\\${socketPath}` : socketPath;
const paneId = process.env.HERDR_PANE_ID;
const source = "herdr:pi";

function enabled() {
  return HERDR_ENV === "1" && !!socketPath && !!paneId;
}

function sendRequestAttempt(request: unknown, timeoutMs: number): Promise<boolean> {
  if (!enabled()) {
    return Promise.resolve(true);
  }

  return new Promise((resolve) => {
    let done = false;
    let timeout: ReturnType<typeof setTimeout> | undefined;
    const finish = (delivered: boolean) => {
      if (done) return;
      done = true;
      if (timeout) {
        clearTimeout(timeout);
      }
      socket.destroy();
      resolve(delivered);
    };

    const socket = net.createConnection(socketEndpoint!);
    socket.on("error", () => finish(false));
    socket.on("connect", () => socket.write(`${JSON.stringify(request)}\n`));
    socket.on("data", () => finish(true));
    socket.on("end", () => finish(false));
    timeout = setTimeout(() => finish(false), timeoutMs);
    timeout.unref?.();
  });
}

async function sendRequest(request: unknown): Promise<void> {
  if (await sendRequestAttempt(request, 500)) {
    return;
  }
  await sendRequestAttempt(request, 1500);
}

type AgentState = "working" | "blocked" | "idle";

type QueuedState = {
  state: AgentState;
  message?: string;
  seq: number;
};

let reportSeq = Date.now() * 1000;
let currentAgentSessionId: string | undefined;
let currentAgentSessionPath: string | undefined;

function nextReportSeq(): number {
  reportSeq += 1;
  return reportSeq;
}

function updateSessionRef(ctx: any): void {
  try {
    const file = ctx?.sessionManager?.getSessionFile?.();
    currentAgentSessionPath =
      typeof file === "string" &&
      (path.posix.isAbsolute(file) || path.win32.isAbsolute(file))
        ? file
        : undefined;
  } catch {
    currentAgentSessionPath = undefined;
  }

  try {
    const id = ctx?.sessionManager?.getSessionId?.();
    currentAgentSessionId = typeof id === "string" && id.length > 0 ? id : undefined;
  } catch {
    currentAgentSessionId = undefined;
  }
}

function withSessionRef(params: Record<string, unknown>): Record<string, unknown> {
  if (currentAgentSessionPath) {
    return { ...params, agent_session_path: currentAgentSessionPath };
  }
  if (currentAgentSessionId) {
    return { ...params, agent_session_id: currentAgentSessionId };
  }
  return params;
}

function currentSessionRef(): Record<string, unknown> | undefined {
  if (currentAgentSessionPath) {
    return { agent_session_path: currentAgentSessionPath };
  }
  if (currentAgentSessionId) {
    return { agent_session_id: currentAgentSessionId };
  }
  return undefined;
}

function reportSession(sessionStartSource?: string): Promise<void> {
  const sessionRef = currentSessionRef();
  if (!sessionRef) {
    return Promise.resolve();
  }

  return sendRequest({
    id: `${source}:session:${Date.now()}:${Math.random().toString(36).slice(2)}`,
    method: "pane.report_agent_session",
    params: {
      pane_id: paneId,
      source,
      agent: "pi",
      seq: nextReportSeq(),
      session_start_source: sessionStartSource,
      ...sessionRef,
    },
  });
}

function sendState(state: AgentState, message?: string, seq = nextReportSeq()): Promise<void> {
  return sendRequest({
    id: `${source}:${Date.now()}:${Math.random().toString(36).slice(2)}`,
    method: "pane.report_agent",
    params: withSessionRef({
      pane_id: paneId,
      source,
      agent: "pi",
      state,
      message,
      seq,
    }),
  });
}

let sendInFlight = false;
let queuedState: QueuedState | undefined;

function queueState(state: AgentState, message?: string): void {
  queuedState = { state, message, seq: nextReportSeq() };
  if (!sendInFlight) {
    void drainStateQueue();
  }
}

async function drainStateQueue(): Promise<void> {
  if (sendInFlight) {
    return;
  }

  sendInFlight = true;
  try {
    while (queuedState) {
      const next = queuedState;
      queuedState = undefined;
      await sendState(next.state, next.message, next.seq);
    }
  } finally {
    sendInFlight = false;
    if (queuedState) {
      void drainStateQueue();
    }
  }
}

export default function (pi) {
  if (!enabled()) {
    return;
  }

  let agentActive = false;
  // LOCAL PATCH: count outstanding paired busy signals, not individual children.
  // pi-subagents holds one signal for all its active runs; other producers can
  // hold their own, so releasing one must not clear another producer's activity.
  let busyCount = 0;
  let blockedCount = 0;
  let blockedMessage: string | undefined;
  let lastState: AgentState | undefined;
  let lastMessage: string | undefined;
  let rootSession = false;

  function desiredState() {
    if (blockedCount > 0) {
      return { state: "blocked" as const, message: blockedMessage };
    }
    // LOCAL PATCH: parent settlement must not finish still-running subagents.
    // The blocked check above keeps user-input requests higher priority than busy.
    if (agentActive || busyCount > 0) {
      return { state: "working" as const, message: undefined };
    }
    return { state: "idle" as const, message: undefined };
  }

  function publishState(force = false) {
    // LOCAL PATCH: gate publication, not event accounting, so early restored
    // signals survive. Also suppress headless, initializing and shutdown reports.
    if (!rootSession) {
      return;
    }
    const next = desiredState();
    if (!force && next.state === lastState && next.message === lastMessage) {
      return;
    }
    lastState = next.state;
    lastMessage = next.message;
    queueState(next.state, next.message);
  }

  // LOCAL PATCH: consume the activity protocol already emitted by pi-subagents.
  // Its optional label is display metadata, not part of our lifecycle state.
  pi.events.on("herdr:busy", (data: unknown) => {
    const active = (data as { active?: unknown } | null)?.active;
    // Reject malformed events rather than treating them as a release of busy.
    if (typeof active !== "boolean") {
      throw new TypeError("herdr:busy requires a boolean active field");
    }
    // Count before session_start too: producers may restore their signals first.
    busyCount = active ? busyCount + 1 : Math.max(0, busyCount - 1);
    // On label changes (e.g. 1 -> 2 children), pi-subagents synchronously emits
    // false then true without actually stopping. Publish after that pair, not
    // between its events, to avoid a spurious idle/done notification.
    queueMicrotask(() => publishState());
  });

  pi.events.on("herdr:blocked", (data) => {
    // LOCAL PATCH: the old rootSession guard moved into publishState(), so early
    // blocked signals are retained too; existing blocker counting is unchanged.
    if (!data?.active) {
      blockedCount = Math.max(0, blockedCount - 1);
      if (blockedCount === 0) {
        blockedMessage = undefined;
      }
      publishState();
      return;
    }

    blockedCount += 1;
    blockedMessage = data.label;
    publishState();
  });

  pi.on("session_start", async (event, ctx) => {
    // TUI only: RPC/JSON/print modes are headless (no PTY herdr can display),
    // and RPC still reports hasUI=true, so mode is the reliable gate.
    if (ctx?.mode !== "tui") {
      return;
    }
    // LOCAL PATCH: enable publication only after the initial session report
    // finishes; busy callbacks must not overtake it. Do not reset early counts.
    rootSession = false;
    updateSessionRef(ctx);
    await reportSession(event?.reason);
    rootSession = true;
    // A reload can replace this extension mid-run without emitting another agent_start.
    agentActive = ctx?.isIdle?.() === false;
    publishState(true);
  });

  // LOCAL PATCH: suppress state reports from queued busy callbacks or later cleanup.
  // This protects consumer-first shutdown, not every reload order (see header).
  pi.on("session_shutdown", () => {
    rootSession = false;
  });

  pi.on("agent_start", (_event, ctx) => {
    if (!rootSession) {
      return;
    }
    updateSessionRef(ctx);
    void reportSession();
    agentActive = true;
    publishState();
  });

  pi.on("agent_settled", (_event, ctx) => {
    if (!rootSession || ctx?.isIdle?.() !== true) {
      return;
    }

    agentActive = false;
    publishState();
  });
}
