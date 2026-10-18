import { Box, Image, exec, hide, readFile, sh, writeFile } from "halo";
import type { Accessor } from "halo/signals";
import type { Item } from "@/dashboard/items";
import { theme } from "@/ui/theme";
import type { Rule } from "@/dashboard/types";

export interface App {
  name: string;
  path: string;
  folder: string;
}

const shellQuote = (value: string) => `'${value.replace(/'/g, `'\\''`)}'`;

let home: Promise<string> | undefined;
const homeDirectory = () =>
  (home ??= sh('printf %s "$HOME"').then((result) => result.stdout));

const expandHome = async (path: string) =>
  path.startsWith("~") ? (await homeDirectory()) + path.slice(1) : path;

export async function scanApps(
  paths: string[],
  depth: number,
  exclude: Rule[],
): Promise<App[]> {
  const roots = await Promise.all(paths.map(expandHome));
  const rules = await compile(exclude);
  const command = `find -L ${roots.map(shellQuote).join(" ")} -maxdepth ${depth} -name '*.app' -prune -print 2>/dev/null`;
  const { stdout } = await sh(command);

  const seen = new Set<string>();
  const apps: App[] = [];
  for (const path of stdout.split("\n")) {
    if (!path) continue;
    const parts = path.split("/");
    const name = parts[parts.length - 1].replace(/\.app$/, "");
    const key = name.toLowerCase();
    if (seen.has(key)) continue;
    const app = { name, path, folder: parts[parts.length - 2] ?? "" };
    if (rules(app)) continue;
    seen.add(key);
    apps.push(app);
  }
  return apps.sort((a, b) => a.name.localeCompare(b.name));
}

async function compile(rules: Rule[]): Promise<(app: App) => boolean> {
  const tests = await Promise.all(
    rules.map(async (rule) => {
      if (rule instanceof RegExp)
        return (app: App) => rule.test(app.name) || rule.test(app.path);
      const isPath = rule.includes("/");
      const pattern = wildcard(isPath ? await expandHome(rule) : rule);
      return (app: App) => pattern.test(isPath ? app.path : app.name);
    }),
  );
  return (app) => tests.some((test) => test(app));
}

function wildcard(rule: string): RegExp {
  const escaped = rule.replace(/[.+?^${}()|[\]\\]/g, "\\$&").replace(/\*/g, ".*");
  return new RegExp(`^${escaped}$`, "i");
}

// Bundle names, not paths: Nix apps run from the store, not from where they were found.
export async function runningBundles(): Promise<Set<string>> {
  const { stdout } = await sh("ps -axo comm=");
  const bundles = new Set<string>();
  for (const line of stdout.split("\n")) {
    const match = line.match(/([^/]+\.app)\/Contents\/MacOS\//);
    if (match) bundles.add(match[1]);
  }
  return bundles;
}

export interface Usage {
  count: number;
  last: number;
}

const recentsFile = "~/.cache/halo/dashboard-recents.json";

export async function loadRecents(): Promise<Record<string, Usage>> {
  try {
    return JSON.parse(await readFile(recentsFile));
  } catch {
    return {};
  }
}

export function saveRecents(recents: Record<string, Usage>): void {
  writeFile(recentsFile, JSON.stringify(recents)).catch(() => {});
}

export function appItem(app: App, running: Accessor<Set<string>>): Item {
  const isRunning = () => running().has(`${app.name}.app`);
  return {
    id: app.path,
    title: app.name,
    subtitle: app.folder,
    icon: () => <Image app={app.path} size={32} />,
    badge: () => (
      <Box
        style={{
          position: "absolute",
          right: -2,
          bottom: -2,
          width: 10,
          height: 10,
          radius: 5,
          borderWidth: 2,
          borderColor: theme.background.slice(0, 7),
          background: "#a6e3a1",
          opacity: () => (isRunning() ? 1 : 0),
          scale: () => (isRunning() ? 1 : 0.2),
          transition: { opacity: 120, scale: { curve: { stiffness: 520, damping: 30 } } },
        }}
      />
    ),
    run: () => {
      exec("open", [app.path]);
      setTimeout(() => hide("dashboard"), 170);
    },
  };
}
