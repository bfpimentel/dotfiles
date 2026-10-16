import { exec, hide, show } from "halo";
import { audio } from "halo/services";
import { SymbolIcon, type Item, type Theme } from "@/dashboard/items";

interface Command {
  id: string;
  title: string;
  subtitle: string;
  symbol: string;
  run(): void;
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
    run: () => show("clipboard"),
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
    id: "mute",
    title: "Toggle Mute",
    subtitle: "Audio",
    symbol: "speaker.slash",
    run: () => audio.toggleMuted(),
  },
];

export function commands(theme: Theme): Item[] {
  return list.map((command) => ({
    id: `command:${command.id}`,
    title: command.title,
    subtitle: command.subtitle,
    icon: () => SymbolIcon(command.symbol, theme),
    run: () => {
      if (command.id !== "clipboard") hide("dashboard");
      command.run();
    },
  }));
}
