import {
  Box,
  For,
  Image,
  Input,
  Surface,
  Text,
  animate,
  hide,
  sh,
  show,
  type NativeNode,
  type ScreenInfo,
} from "halo";
import { session } from "halo/services";
import { computed, effect, onCleanup, signal, type Accessor } from "halo/signals";
import {
  appItem,
  loadRecents,
  runningBundles,
  saveRecents,
  scanApps,
  type App,
  type Usage,
} from "@/dashboard/apps";
import { commands } from "@/dashboard/commands";
import { SymbolIcon, alpha, type Item, type Theme } from "@/dashboard/items";
import { Overview } from "@/dashboard/Overview";
import { calculate, rank, segments, type Ranked } from "@/dashboard/rank";
import type { DashboardConfig } from "@/dashboard/types";

const ROW_HEIGHT = 48;
const snappy = { stiffness: 520, damping: 30 };

const formatNumber = (value: number) => String(Number(value.toPrecision(12)));

function calculatorItem(
  value: number,
  copied: Accessor<boolean>,
  onCopy: () => void,
  theme: Theme,
): Item {
  return {
    id: "calc",
    title: formatNumber(value),
    subtitle: () => (copied() ? "Copied to clipboard" : "Enter to copy"),
    icon: () => SymbolIcon("equal", theme),
    run: () => {
      sh(`printf %s '${formatNumber(value)}' | pbcopy`);
      onCopy();
      setTimeout(() => hide("dashboard"), 700);
    },
    searchable: false,
  };
}

export function Dashboard(props: { screen: ScreenInfo; config: DashboardConfig }) {
  const { config } = props;
  const theme = config.theme;

  const apps = signal<App[]>([]);
  const running = signal(new Set<string>());
  const recents = signal<Record<string, Usage>>({});
  const query = signal("");
  const selected = signal(0);
  const copied = signal(false);
  const rows = new Map<string, NativeNode>();

  const refresh = () => {
    scanApps(config.searchPaths, config.depth, config.exclude).then(apps.set);
    runningBundles().then(running.set);
  };
  refresh();
  loadRecents().then(recents.set);

  let lastWake: number | undefined;
  effect(() => {
    const wake = session.lastWake();
    if (wake !== undefined && wake !== lastWake) refresh();
    lastWake = wake;
  });

  const idle = computed(() => !query().trim());
  const result = computed(() => (config.calculator ? calculate(query()) : undefined));
  const searchable = computed(() => [
    ...apps().map((app) => appItem(app, running, theme)),
    ...commands(theme),
  ]);
  const items = computed<Ranked[]>(() => {
    const ranked = rank(searchable(), query(), {
      aliases: config.aliases,
      pinned: config.pinned,
      recents: recents(),
      limit: idle() && config.overview.enabled ? config.overview.rows : config.maxResults,
    });
    const value = result();
    if (value === undefined) return ranked;
    const calc = calculatorItem(value, copied, () => copied.set(true), theme);
    return [
      { item: calc, match: { score: 0, indices: [] } },
      ...ranked.slice(0, config.maxResults - 1),
    ];
  });
  const heading = computed(() =>
    result() !== undefined
      ? "CALCULATOR"
      : query().trim()
        ? `${items().length} OF ${apps().length}`
        : "PINNED & RECENT",
  );

  const move = (delta: number) => {
    const count = items().length;
    if (count) selected.update((index) => (index + delta + count) % count);
  };

  const remember = (item: Item) => {
    const next = {
      ...recents(),
      [item.id]: { count: (recents()[item.id]?.count ?? 0) + 1, last: Date.now() },
    };
    saveRecents(next);
    recents.set(next);
  };

  const choose = (entry: Ranked | undefined) => {
    if (!entry) return;
    const { item } = entry;
    const row = rows.get(item.id);
    if (row)
      animate(row, { scale: [1, 0.95, 1.02, 1] }, { duration: 280, curve: "ease-out" });
    item.run();
    if (item.searchable !== false) setTimeout(() => remember(item), 170);
  };

  const reset = () => {
    query.set("");
    selected.set(0);
    copied.set(false);
    refresh();
  };

  function Row(entry: Accessor<Ranked>, index: Accessor<number>) {
    const { item } = entry();
    const isSelected = () => selected() === index();
    onCleanup(() => rows.delete(item.id));
    return (
      <Box
        ref={(node) => rows.set(item.id, node)}
        style={{
          flexDirection: "row",
          align: "center",
          gap: 12,
          height: ROW_HEIGHT,
          padding: [0, 12],
          radius: 5,
          background: () =>
            isSelected() ? alpha(theme.accent, 0.16) : alpha(theme.accent, 0),
          transition: { background: 140 },
        }}
        enter={{
          from: { opacity: 0, translateY: 10 },
          duration: 200,
          delay: index() * 22,
          curve: [0.2, 0.9, 0.3, 1],
        }}
        onHover={(hovered) => hovered && selected.set(index())}
        onClick={() => {
          selected.set(index());
          choose(entry());
        }}
      >
        <Box
          style={{
            width: 32,
            height: 32,
            scale: () => (isSelected() ? 1.1 : 1),
            transition: { scale: { curve: snappy } },
          }}
        >
          {item.icon(isSelected)}
          {item.badge?.() ?? null}
        </Box>
        <Box style={{ grow: 1, gap: 1 }}>
          <Box style={{ flexDirection: "row" }}>
            {() =>
              segments(entry().item.title, entry().match.indices).map((part) => (
                <Text
                  style={{
                    fontSize: 14,
                    fontWeight: part.hit ? "bold" : "medium",
                    color: part.hit ? theme.accent : theme.foreground,
                  }}
                >
                  {part.text}
                </Text>
              ))
            }
          </Box>
          <Text style={{ fontSize: 11, color: theme.muted }}>
            {() => {
              const { subtitle } = entry().item;
              return typeof subtitle === "function" ? subtitle() : subtitle;
            }}
          </Text>
        </Box>
        <Text
          style={{
            fontSize: 13,
            fontWeight: "semibold",
            color: theme.accent,
            opacity: () => (isSelected() ? 1 : 0),
            translateX: () => (isSelected() ? 0 : -8),
            transition: { opacity: 120, translateX: { curve: snappy } },
          }}
        >
          ↵
        </Text>
      </Box>
    );
  }

  function Empty() {
    let icon: NativeNode | undefined;
    const view = (
      <Box
        style={{ height: 104, justify: "center", align: "center", gap: 10 }}
        enter={{ from: { opacity: 0, scale: 0.94 }, duration: 180 }}
      >
        <Image
          ref={(node) => (icon = node)}
          symbol="questionmark.app.dashed"
          size={28}
          color={theme.muted}
        />
        <Text
          style={{ fontSize: 13, color: theme.muted }}
        >{`Nothing matches “${query().trim()}”`}</Text>
      </Box>
    );
    if (icon)
      animate(
        icon,
        { rotate: [0, -14, 11, -6, 3, 0] },
        { duration: 560, curve: "ease-out" },
      );
    return view;
  }

  function Hint(keys: string, label: string) {
    return (
      <Box style={{ flexDirection: "row", align: "center", gap: 6 }}>
        <Box style={{ padding: [2, 6], radius: 3, background: "#ffffff12" }}>
          <Text style={{ fontSize: 11, fontWeight: "semibold", color: theme.foreground }}>
            {keys}
          </Text>
        </Box>
        <Text style={{ fontSize: 11, color: theme.muted }}>{label}</Text>
      </Box>
    );
  }

  return (
    <Surface
      name="dashboard"
      defaultHidden
      screen={props.screen}
      anchor={["top"]}
      margins={[Math.round(props.screen.frame.height * 0.18), 0, 0, 0]}
      size={{ width: 680, height: 600 }}
      layer="overlay"
      input="keyboard"
      onFocus={reset}
      onBlur={() => hide("dashboard")}
      enter={{
        from: { opacity: 0, scale: 0.95, translateY: -16 },
        curve: { stiffness: 420, damping: 30 },
      }}
      exit={{
        to: { opacity: 0, scale: 0.97, translateY: -8 },
        duration: 120,
        curve: "ease-in",
      }}
    >
      <Box style={{ origin: [0.5, 0] }}>
        <Box
          style={{
            padding: [4, 8, 10, 8],
            background: theme.background,
            radius: 9,
            borderWidth: 1,
            borderColor: "#ffffff12",
            transition: { layout: { duration: 240, curve: [0.2, 0.9, 0.3, 1] } },
          }}
        >
          <Box
            style={{ flexDirection: "row", align: "center", gap: 12, padding: [14, 12] }}
          >
            <Image
              symbol="magnifyingglass"
              size={20}
              color={() => (query() ? theme.accent : theme.muted)}
            />
            <Input
              autofocus
              value={query}
              placeholder="Search apps, or type math…"
              style={{ grow: 1, fontSize: 22, color: theme.foreground }}
              onInput={(value) => {
                query.set(value);
                selected.set(0);
              }}
              onKeyDown={({ key }) => {
                const item = items()[selected()];
                switch (key) {
                  case "ArrowDown":
                    move(1);
                    return true;
                  case "ArrowUp":
                    move(-1);
                    return true;
                  case "Enter":
                    choose(item);
                    return true;
                  case "Tab":
                    show("clipboard");
                    return true;
                  case "Escape":
                    if (query()) {
                      query.set("");
                      selected.set(0);
                    } else {
                      hide("dashboard");
                    }
                    return true;
                  default:
                    return false;
                }
              }}
            />
          </Box>
          <Box style={{ height: 1, background: "#ffffff10" }} />
          {() =>
            config.overview.enabled && idle() ? (
              <Overview theme={theme} options={config.overview} />
            ) : null
          }
          <Box style={{ padding: [10, 12, 6, 12] }}>
            <Text style={{ fontSize: 10, fontWeight: "bold", color: theme.muted }}>
              {heading}
            </Text>
          </Box>
          <Box style={{ gap: 2 }}>
            <For each={items} key={(entry) => entry.item.id}>
              {Row}
            </For>
            {() => (items().length ? null : Empty())}
          </Box>
          <Box
            style={{
              flexDirection: "row",
              align: "center",
              gap: 14,
              padding: [12, 12, 2, 12],
            }}
          >
            {Hint("↑↓", "select")}
            {Hint("↵", "open")}
            {Hint("⇥", "clipboard")}
            {Hint("esc", "clear / close")}
            <Box style={{ grow: 1 }} />
            <Text style={{ fontSize: 11, color: theme.muted }}>
              {() => `${apps().length} apps`}
            </Text>
          </Box>
        </Box>
      </Box>
    </Surface>
  );
}
