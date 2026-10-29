import { exec, type Reactive } from "halo";
import { audio } from "halo/services";
import { caffeinated, toggleCaffeinate } from "@/dashboard/caffeinate";
import { tab } from "@/island/state";
import type { Feedback, Item } from "@/ui/palette/types";
import { SymbolIcon } from "@/ui/SymbolIcon";

interface Command {
  id: string;
  title: string;
  subtitle: Reactive<string>;
  symbol: string;
  run(): void;
  /** Keeps the dashboard open instead of closing into a notice. */
  stays?: boolean;
  feedback?(): Feedback;
}

const loginwindow = (event: string) => () =>
  exec("osascript", ["-e", `tell application "loginwindow" to «event ${event}»`]);

const pmset =
  (...args: string[]) =>
  () =>
    exec("pmset", args);

const list: Command[] = [
  {
    id: "clipboard",
    title: "Clipboard History",
    subtitle: "Dashboard",
    symbol: "doc.on.clipboard",
    run: () => tab.set("clipboard"),
    stays: true,
  },
  {
    id: "lock",
    title: "Lock Screen",
    subtitle: "System",
    symbol: "lock",
    run: pmset("displaysleepnow"),
  },
  {
    id: "sleep",
    title: "Sleep",
    subtitle: "System",
    symbol: "moon.zzz",
    run: pmset("sleepnow"),
  },
  {
    id: "sleep-displays",
    title: "Sleep Displays",
    subtitle: "System",
    symbol: "display",
    run: pmset("displaysleepnow"),
  },
  {
    id: "restart",
    title: "Restart",
    subtitle: "System",
    symbol: "arrow.clockwise",
    run: loginwindow("aevtrrst"),
  },
  {
    id: "shutdown",
    title: "Shut Down",
    subtitle: "System",
    symbol: "power",
    run: loginwindow("aevtrsdn"),
  },
  {
    id: "logout",
    title: "Log Out",
    subtitle: "System",
    symbol: "rectangle.portrait.and.arrow.right",
    run: loginwindow("aevtrlgo"),
  },
  {
    id: "caffeinate",
    title: "Caffeinate",
    subtitle: () => (caffeinated() ? "On · keeping the Mac awake" : "Off"),
    symbol: "cup.and.saucer",
    run: toggleCaffeinate,
    feedback: () =>
      caffeinated() === undefined
        ? {
            title: "Caffeinate on",
            subtitle: "Keeping the Mac awake",
            symbol: "cup.and.saucer.fill",
          }
        : {
            title: "Caffeinate off",
            subtitle: "Sleep is allowed again",
            symbol: "cup.and.saucer",
          },
  },
  {
    id: "mute",
    title: "Toggle Mute",
    subtitle: "Audio",
    symbol: "speaker.slash",
    run: () => audio.toggleMuted(),
    feedback: () =>
      audio.muted()
        ? { title: "Sound on", subtitle: "Audio", symbol: "speaker.wave.2.fill" }
        : { title: "Muted", subtitle: "Audio", symbol: "speaker.slash.fill" },
  },
];

export function commands(): Item[] {
  return list.map((command) => ({
    id: `command:${command.id}`,
    title: command.title,
    subtitle: command.subtitle,
    icon: () => SymbolIcon(command.symbol),
    run: command.run,
    closeAfter: command.stays ? false : 0,
    feedback: command.feedback,
  }));
}
