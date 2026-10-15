// AeroSpace workspaces as signals, built only on halo's public API: `halo trigger` events from aerospace.toml
// wake it, `aerospace list-workspaces` supplies the state. Copy it into your config and adapt it; the same
// shape works for yabai or any WM with a CLI and change hooks.

import { screens, sh, type ScreenInfo } from "halo";
import { computed, effect, externalSignal, signal, type Accessor } from "halo/signals";

/** An AeroSpace workspace as `aerospace()` reports it. */
export interface Workspace {
  name: string;
  /** The halo display (`ScreenInfo.id`) showing this workspace, matched exactly through the macOS display index. */
  screen: number | undefined;
  focused: boolean;
  empty: boolean;
}

const separator = "--halo--";
const query =
  `aerospace list-workspaces --monitor all --format '%{workspace}|%{monitor-appkit-nsscreen-screens-id}'` +
  ` && echo ${separator} && aerospace list-workspaces --focused` +
  ` && echo ${separator} && aerospace list-workspaces --monitor all --empty no`;

/** Live AeroSpace state, from `aerospace()`. */
export interface AeroSpace {
  /** Every workspace with its display, focus and emptiness. */
  workspaces: Accessor<Workspace[]>;
  /** The focused workspace's name. */
  focused: Accessor<string | undefined>;
  /** Workspaces on one display, in AeroSpace's order. */
  on(screen: ScreenInfo): Accessor<Workspace[]>;
}

/**
 * AeroSpace workspaces, refreshed on every `aerospace.workspace` / `aerospace.focus` trigger.
 * Call once per config, at module level or inside a component.
 */
export function aerospace(options: { command?: string } = {}): AeroSpace {
  const event = externalSignal("aerospace.workspace", {
    parse: (payload) => ({ ...payload }),
  });
  const focusEvent = externalSignal("aerospace.focus", {
    parse: (payload) => ({ ...payload }),
  });
  const raw = signal<string | undefined>(undefined);
  const command = options.command ?? query;

  let generation = 0;
  effect(() => {
    event();
    focusEvent();
    const current = ++generation;
    sh(command).then((result) => {
      if (current !== generation) return;
      if (result.code !== 0)
        return console.warn(
          `aerospace: query failed (${result.code}): ${result.stderr.trim()}`,
        );
      raw.set(result.stdout);
    });
  });

  const warned = new Set<string>();
  const workspaces = computed<Workspace[]>(() => {
    const output = raw();
    if (output === undefined) return [];
    const [all = "", focusedOutput = "", nonEmpty = ""] = output.split(separator);
    const focused = event()?.focused ?? focusedOutput.trim();
    const occupied = new Set(
      nonEmpty
        .split("\n")
        .map((line) => line.trim())
        .filter(Boolean),
    );
    const byIndex = new Map<number, ScreenInfo>(
      screens().map((screen) => [screen.index, screen]),
    );
    return all
      .split("\n")
      .map((line) => line.trim())
      .filter(Boolean)
      .map((line) => {
        const [name = "", index = ""] = line.split("|");
        const screen = byIndex.get(Number(index));
        if (!screen && !warned.has(index)) {
          warned.add(index);
          console.warn(
            `aerospace: no display at macOS index ${index} for workspace ${name}; it won't be shown`,
          );
        }
        return {
          name,
          screen: screen?.id,
          focused: name === focused,
          empty: !occupied.has(name),
        };
      });
  });

  return {
    workspaces,
    focused: computed(() => workspaces().find((workspace) => workspace.focused)?.name),
    on(screen: ScreenInfo): Accessor<Workspace[]> {
      return computed(
        () => workspaces().filter((workspace) => workspace.screen === screen.id),
        {
          equals: (a, b) => JSON.stringify(a) === JSON.stringify(b),
        },
      );
    },
  };
}
