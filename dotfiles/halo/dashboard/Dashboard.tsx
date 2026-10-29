import { Box } from "halo";
import { session } from "halo/services";
import { computed, effect, signal } from "halo/signals";
import {
  appItem,
  loadRecents,
  pinnedAndRecent,
  runningBundles,
  saveRecents,
  scanApps,
  usageBoost,
  type App,
  type Usage,
} from "@/dashboard/apps";
import type { AeroSpace } from "@/dashboard/aerospace";
import { checkCaffeinate } from "@/dashboard/caffeinate";
import { calculate, calculatorItem } from "@/dashboard/calculator";
import { commands } from "@/dashboard/commands";
import { Overview } from "@/dashboard/Overview";
import type { DashboardConfig } from "@/dashboard/types";
import { ShelfStrip } from "@/shelf/ShelfStrip";
import { shelf } from "@/shelf/store";
import type { PaletteConfig } from "@/ui/palette/Palette";
import type { Item } from "@/ui/palette/types";

export function launcher(config: DashboardConfig, spaces: AeroSpace): PaletteConfig {
  const apps = signal<App[]>([]);
  const running = signal(new Set<string>());
  const recents = signal<Record<string, Usage>>({});

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

  const items = computed(() => [
    ...apps().map((app) => appItem(app, running)),
    ...commands(),
  ]);

  const remember = (item: Item) => {
    const next = {
      ...recents(),
      [item.id]: { count: (recents()[item.id]?.count ?? 0) + 1, last: Date.now() },
    };
    saveRecents(next);
    recents.set(next);
  };

  return {
    placeholder: "Search apps, or type math…",
    items,
    search: {
      limit: config.maxResults,
      idleLimit: config.overview.enabled ? config.overview.rows : config.maxResults,
      aliases: config.aliases,
      boost: (item) => usageBoost(recents()[item.id]),
      idle: (all) => pinnedAndRecent(all, config.pinned, recents()),
      extras: (query) => {
        const value = config.calculator ? calculate(query) : undefined;
        return value === undefined ? [] : [calculatorItem(value)];
      },
    },
    heading: (ctx) =>
      ctx.results()[0]?.item.id === "calc"
        ? "CALCULATOR"
        : ctx.idle()
          ? "PINNED & RECENT"
          : `${ctx.results().length} OF ${apps().length}`,
    middle: (ctx) =>
      ctx.idle() ? (
        <Box>
          {config.overview.enabled ? (
            <Overview options={config.overview} spaces={spaces} />
          ) : null}
          {() => (shelf.files().length ? <ShelfStrip /> : null)}
        </Box>
      ) : null,
    status: () => `${apps().length} apps`,
    onOpen: () => {
      refresh();
      checkCaffeinate();
    },
    onRun: (item) => {
      if (item.id !== "calc") setTimeout(() => remember(item), 170);
    },
  };
}
