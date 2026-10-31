import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function formatMemory(bytes: number): string {
  const gibibyte = 1024 ** 3;
  const useGiB = bytes >= gibibyte;
  const value = bytes / (useGiB ? gibibyte : 1024 ** 2);
  return `${Number(value.toPrecision(3))} ${useGiB ? "GiB" : "MiB"}`;
}

export default function ramStatus(pi: ExtensionAPI): void {
  let timer: ReturnType<typeof setInterval> | undefined;

  function stop(): void {
    if (timer !== undefined) {
      clearInterval(timer);
      timer = undefined;
    }
  }

  pi.on("session_start", (_event, ctx) => {
    stop();
    if (ctx.mode !== "tui") return;

    const update = () => {
      ctx.ui.setStatus("ram", `ram: ${formatMemory(process.memoryUsage.rss())}`);
    };
    update();
    timer = setInterval(update, 2000);
    timer.unref();
  });

  pi.on("session_shutdown", (_event, ctx) => {
    stop();
    if (ctx.mode === "tui") ctx.ui.setStatus("ram", undefined);
  });
}
