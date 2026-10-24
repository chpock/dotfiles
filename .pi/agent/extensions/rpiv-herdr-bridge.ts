import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function rpivHerdrBridge(pi: ExtensionAPI): void {
  pi.events.on("rpiv:ask-user:blocked", (payload: unknown) => {
    const active = (payload as { active?: unknown } | null)?.active;
    if (typeof active !== "boolean") {
      throw new TypeError("rpiv:ask-user:blocked requires a boolean active field");
    }

    // Preserve each paired event; Herdr owns blocker counting and transport.
    pi.events.emit(
      "herdr:blocked",
      active ? { active: true, label: "Waiting for user answer" } : { active: false },
    );
  });
}
