import { externalSignal, signal, untrack } from "halo/signals";
import { shelf } from "@/shelf/store";
import type { Feedback } from "@/ui/palette/types";

export type Mode = "hidden" | "shelf" | "compact" | "toast" | "drop" | "dashboard";
export type Resting = Exclude<Mode, "dashboard">;
export type Tab = "launcher" | "clipboard";

export const mode = signal<Mode>("hidden");
export const tab = signal<Tab>("launcher");
export const feedback = signal<Feedback | undefined>(undefined);

const timers = new Map<string, ReturnType<typeof setTimeout>>();
const later = (name: string, ms: number, fn: () => void) => {
  clearTimeout(timers.get(name));
  timers.set(name, setTimeout(fn, ms));
};
const cancel = (name: string) => clearTimeout(timers.get(name));

const toastMs = 1900;

/** Where the island rests when nothing else is going on: the shelf stays up while it holds files. */
export const idle = (): Resting => (untrack(shelf.files).length ? "shelf" : "hidden");

export function reveal() {
  cancel("conceal");
  if (untrack(mode) === "hidden") mode.set("compact");
}

export function conceal(delay = 450) {
  later("conceal", delay, () => {
    if (untrack(mode) === "compact") mode.set(idle());
  });
}

export function stayOpen() {
  cancel("conceal");
}

export function setResting(target: Resting) {
  cancel("conceal");
  cancel("toast");
  mode.set(target);
  if (target === "toast")
    later("toast", toastMs, () => {
      if (untrack(mode) === "toast") mode.set(idle());
    });
}

export function notify(next: Feedback) {
  feedback.set(next);
  setResting("toast");
}

export function openDashboard(next: Tab = "launcher") {
  cancel("conceal");
  cancel("toast");
  tab.set(next);
  mode.set("dashboard");
}

export function closeDashboard(target: Resting = idle()) {
  if (untrack(mode) === "dashboard") setResting(target);
}

export function toggleDashboard() {
  if (untrack(mode) === "dashboard") closeDashboard();
  else openDashboard();
}

// `halo trigger island action=toggle|open|close|clipboard`; the replayed last event on load is ignored.
let live = false;
externalSignal("island", {
  parse: (payload) => {
    if (!live) return undefined;
    const action = payload.action ?? "toggle";
    if (action === "open") openDashboard();
    else if (action === "close") closeDashboard();
    else if (action === "clipboard") openDashboard("clipboard");
    else toggleDashboard();
    return undefined;
  },
});
live = true;
