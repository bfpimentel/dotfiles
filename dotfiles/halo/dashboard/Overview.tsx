import { Box, For, Image, Shape, Text, exec, hide, ring, sh } from "halo";
import { aerospace, type Workspace } from "@/dashboard/aerospace";
import { battery, clock } from "halo/services";
import { computed, effect, signal, type Accessor } from "halo/signals";
import { caffeinated, toggleCaffeinate } from "@/dashboard/caffeinate";
import type { DashboardConfig } from "@/dashboard/types";
import { theme } from "@/ui/theme";

type Options = DashboardConfig["overview"];

const snappy = { stiffness: 520, damping: 30 };

export function Overview(props: { options: Options }) {
  const { options } = props;
  return (
    <Box
      style={{ flexDirection: "row", align: "center", gap: 14, padding: [10, 12, 4, 12] }}
      enter={{
        from: { opacity: 0, translateY: -6 },
        duration: 200,
        curve: [0.2, 0.9, 0.3, 1],
      }}
      exit={{ to: { opacity: 0, translateY: -4 }, duration: 100, curve: "ease-in" }}
    >
      {Clock()}
      {() => (caffeinated() === undefined ? null : Caffeinated())}
      {() => (battery.present() && battery.source() === "battery" ? Battery() : null)}
      <Box style={{ grow: 1 }} />
      {options.workspaces ? Workspaces() : null}
    </Box>
  );
}

function Clock() {
  return (
    <Box style={{ flexDirection: "row", align: "center", gap: 10 }}>
      <Text style={{ fontSize: 26, fontWeight: "bold", color: theme.foreground }}>
        {clock.format("HH:mm")}
      </Text>
      <Box style={{ gap: 0 }}>
        <Text style={{ fontSize: 11, fontWeight: "semibold", color: theme.foreground }}>
          {clock.format("EEEE")}
        </Text>
        <Text style={{ fontSize: 11, color: theme.muted }}>{clock.format("d MMMM")}</Text>
      </Box>
    </Box>
  );
}

const minute = clock.format("HH:mm");

function elapsed(since: number) {
  const minutes = Math.floor((Date.now() - since) / 60_000);
  return minutes < 60 ? `${minutes}m` : `${Math.floor(minutes / 60)}h ${minutes % 60}m`;
}

function Caffeinated() {
  const hovered = signal(false);
  return (
    <Box
      style={{
        flexDirection: "row",
        align: "center",
        gap: 8,
        padding: [4, 8],
        radius: 5,
        background: () => (hovered() ? "#ffffff14" : "#ffffff08"),
        transition: { background: 120 },
      }}
      enter={{ from: { opacity: 0, scale: 0.8 }, duration: 180, curve: snappy }}
      exit={{ to: { opacity: 0, scale: 0.8 }, duration: 120, curve: "ease-in" }}
      onHover={hovered.set}
      onClick={toggleCaffeinate}
    >
      <Image symbol="cup.and.saucer.fill" size={16} color={theme.accent} />
      <Box style={{ gap: 0 }}>
        <Text style={{ fontSize: 10, fontWeight: "bold", color: theme.muted }}>
          {() => (hovered() ? "TURN OFF" : "AWAKE")}
        </Text>
        <Text style={{ fontSize: 10, fontWeight: "semibold", color: theme.foreground }}>
          {() => {
            minute();
            const since = caffeinated();
            return since === undefined ? "" : elapsed(since);
          }}
        </Text>
      </Box>
    </Box>
  );
}

function Battery() {
  const level = () => (battery.percent() ?? 0) / 100;
  return (
    <Box style={{ width: 30, height: 30 }}>
      <Shape
        path={ring()}
        style={{
          width: 30,
          height: 30,
          fill: "transparent",
          stroke: () => (level() < 0.2 ? "#f38ba8" : theme.foreground),
          track: "#ffffff14",
          strokeWidth: 3,
          lineCap: "round",
          strokeEnd: level,
          transition: { strokeEnd: 300 },
        }}
      />
      <Box
        style={{
          position: "absolute",
          top: 0,
          right: 0,
          bottom: 0,
          left: 0,
          justify: "center",
          align: "center",
        }}
      >
        <Text style={{ fontSize: 9, fontWeight: "bold", color: theme.foreground }}>
          {() => `${battery.percent() ?? "–"}`}
        </Text>
      </Box>
    </Box>
  );
}

interface Windows {
  bundles: string[];
}

function Workspaces() {
  const spaces = aerospace();
  const windows = signal(new Map<string, Windows>());
  effect(() => {
    spaces.workspaces();
    sh("aerospace list-windows --all --format '%{workspace}|%{app-bundle-id}'").then(
      ({ stdout }) => {
        const byWorkspace = new Map<string, Windows>();
        for (const line of stdout.split("\n")) {
          const [workspace, bundle] = line.split("|");
          if (!workspace || !bundle) continue;
          const entry = byWorkspace.get(workspace) ?? { bundles: [] };
          if (!entry.bundles.includes(bundle)) entry.bundles.push(bundle);
          byWorkspace.set(workspace, entry);
        }
        windows.set(byWorkspace);
      },
    );
  });

  const chip = (workspace: Accessor<Workspace>, index: Accessor<number>) => {
    const hovered = signal(false);
    const name = workspace().name;
    const entry = computed(() => windows().get(name) ?? { bundles: [] }, {
      equals: (a, b) => a.bundles.join() === b.bundles.join(),
    });
    const label = () =>
      workspace().focused
        ? theme.background.slice(0, 7)
        : workspace().empty
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
          radius: 4,
          background: () =>
            workspace().focused ? theme.accent : hovered() ? "#ffffff14" : "#ffffff08",
          scale: () => (hovered() ? 1.06 : 1),
          transition: { background: 120, scale: { curve: snappy } },
        }}
        enter={{
          from: { opacity: 0, scale: 0.8 },
          duration: 180,
          delay: index() * 25,
          curve: snappy,
        }}
        onHover={hovered.set}
        onClick={() => {
          exec("aerospace", ["workspace", name]);
          hide("dashboard");
        }}
      >
        <Text style={{ fontSize: 12, fontWeight: "bold", color: label }}>{name}</Text>
        {() =>
          entry()
            .bundles.slice(0, 3)
            .map((bundle) => <Image app={bundle} size={14} />)
        }
      </Box>
    );
  };

  return (
    <Box style={{ flexDirection: "row", align: "center", gap: 6 }}>
      <For each={spaces.workspaces} key={(workspace) => workspace.name}>
        {chip}
      </For>
    </Box>
  );
}
