import { Box, Image, Text, animate, exec, hide, sh, type NativeNode } from "halo";
import { aerospace, type Workspace } from "@/launcher/aerospace";
import { clock } from "halo/services";
import { computed, effect, signal } from "halo/signals";
import type { LauncherConfig } from "@/launcher/types";

type Theme = LauncherConfig["theme"];
type Options = LauncherConfig["dashboard"];

const snappy = { stiffness: 520, damping: 30 };

/// One strip shown while the search is empty: time and date on the left, AeroSpace workspaces on the right.
export function Dashboard(props: { theme: Theme; options: Options }) {
  const { theme, options } = props;
  return (
    <Box
      style={{ flexDirection: "row", align: "center", gap: 12, padding: [10, 12, 4, 12] }}
      enter={{
        from: { opacity: 0, translateY: -6 },
        duration: 200,
        curve: [0.2, 0.9, 0.3, 1],
      }}
      exit={{ to: { opacity: 0, translateY: -4 }, duration: 100, curve: "ease-in" }}
    >
      {Clock(theme)}
      <Box style={{ grow: 1 }} />
      {options.workspaces ? Workspaces(theme) : null}
    </Box>
  );
}

function Clock(theme: Theme) {
  let colon: NativeNode | undefined;
  const view = (
    <Box style={{ flexDirection: "row", align: "center", gap: 10 }}>
      <Box style={{ flexDirection: "row", align: "center" }}>
        <Text style={{ fontSize: 26, fontWeight: "bold", color: theme.foreground }}>
          {clock.format("HH")}
        </Text>
        <Text
          ref={(node) => (colon = node)}
          style={{
            fontSize: 24,
            fontWeight: "bold",
            color: theme.accent,
            padding: [0, 1, 3, 1],
          }}
        >
          :
        </Text>
        <Text style={{ fontSize: 26, fontWeight: "bold", color: theme.foreground }}>
          {clock.format("mm")}
        </Text>
      </Box>
      <Box style={{ gap: 0 }}>
        <Text style={{ fontSize: 11, fontWeight: "semibold", color: theme.foreground }}>
          {clock.format("EEEE")}
        </Text>
        <Text style={{ fontSize: 11, color: theme.muted }}>{clock.format("d MMMM")}</Text>
      </Box>
    </Box>
  );
  if (colon)
    animate(
      colon,
      { opacity: [1, 0.25] },
      { duration: 900, repeat: Infinity, alternate: true, curve: "ease-in-out" },
    );
  return view;
}

function Workspaces(theme: Theme) {
  const spaces = aerospace();
  const windows = signal(new Map<string, string[]>());
  effect(() => {
    spaces.workspaces();
    sh("aerospace list-windows --all --format '%{workspace}|%{app-bundle-id}'").then(
      ({ stdout }) => {
        const byWorkspace = new Map<string, string[]>();
        for (const line of stdout.split("\n")) {
          const [workspace, bundle] = line.split("|");
          if (!workspace || !bundle) continue;
          const list = byWorkspace.get(workspace) ?? [];
          if (!list.includes(bundle)) list.push(bundle);
          byWorkspace.set(workspace, list);
        }
        windows.set(byWorkspace);
      },
    );
  });

  const chip = (workspace: Workspace, index: number) => {
    const hovered = signal(false);
    const apps = computed(() => windows().get(workspace.name) ?? [], {
      equals: (a, b) => a.join() === b.join(),
    });
    const label = workspace.focused
      ? "#11111b"
      : workspace.empty
        ? theme.muted
        : theme.foreground;
    return (
      <Box
        style={{
          flexDirection: "row",
          align: "center",
          gap: 5,
          height: 26,
          padding: [0, 8],
          radius: 8,
          background: () =>
            workspace.focused ? theme.accent : hovered() ? "#ffffff14" : "#ffffff08",
          scale: () => (hovered() ? 1.06 : 1),
          transition: { background: 120, scale: { curve: snappy } },
        }}
        enter={{
          from: { opacity: 0, scale: 0.8 },
          duration: 180,
          delay: index * 25,
          curve: snappy,
        }}
        onHover={hovered.set}
        onClick={() => {
          exec("aerospace", ["workspace", workspace.name]);
          hide("launcher");
        }}
      >
        <Text style={{ fontSize: 12, fontWeight: "bold", color: label }}>
          {workspace.name}
        </Text>
        {() =>
          apps()
            .slice(0, 3)
            .map((bundle) => <Image app={bundle} size={14} />)
        }
      </Box>
    );
  };

  return (
    <Box style={{ flexDirection: "row", align: "center", gap: 6 }}>
      {() => spaces.workspaces().map(chip)}
    </Box>
  );
}
