import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { CustomEditor } from "@earendil-works/pi-coding-agent";
import { fuzzyFilter } from "@earendil-works/pi-tui";
import { execFile } from "node:child_process";
import { statSync } from "node:fs";
import path from "node:path";

interface AutocompleteItem {
  value: string;
  label: string;
  description?: string;
}

interface AutocompleteProvider {
  getSuggestions(
    lines: string[],
    cursorLine: number,
    cursorCol: number,
    options: { signal: AbortSignal; force?: boolean },
  ): Promise<{ items: AutocompleteItem[]; prefix: string } | null>;
  applyCompletion(lines: string[], cursorLine: number, cursorCol: number, item: AutocompleteItem, prefix: string): unknown;
  shouldTriggerFileCompletion?(lines: string[], cursorLine: number, cursorCol: number): boolean;
}

interface ProjectEntry {
  path: string;
  isDirectory: boolean;
}

const CACHE_TTL_MS = 5_000;
let cache: { cwd: string; timestamp: number; entries: ProjectEntry[] } | undefined;

function normalizePath(value: string): string {
  return value.replace(/\\/g, "/").replace(/^\.\//, "");
}

function shellExecFile(file: string, args: string[], cwd: string, signal: AbortSignal): Promise<string | null> {
  return new Promise((resolve) => {
    if (signal.aborted) return resolve(null);

    const child = execFile(file, args, { cwd, maxBuffer: 10 * 1024 * 1024 }, (error, stdout) => {
      if (error || signal.aborted) return resolve(null);
      resolve(stdout.toString());
    });

    signal.addEventListener("abort", () => child.kill("SIGKILL"), { once: true });
  });
}

function addParentDirs(paths: string[]): ProjectEntry[] {
  const seen = new Map<string, ProjectEntry>();

  for (const filePath of paths) {
    const normalized = normalizePath(filePath);
    if (!normalized || normalized === ".") continue;

    seen.set(normalized, { path: normalized, isDirectory: false });

    let dir = path.posix.dirname(normalized);
    while (dir && dir !== "." && dir !== "/") {
      seen.set(dir, { path: dir, isDirectory: true });
      dir = path.posix.dirname(dir);
    }
  }

  return [...seen.values()];
}

async function listProjectEntries(cwd: string, signal: AbortSignal): Promise<ProjectEntry[]> {
  if (cache && cache.cwd === cwd && Date.now() - cache.timestamp < CACHE_TTL_MS) {
    return cache.entries;
  }

  // Prefer git because it respects .gitignore and is usually much faster/cleaner for projects.
  const gitOutput = await shellExecFile("git", ["ls-files", "-co", "--exclude-standard", "-z"], cwd, signal);
  if (gitOutput !== null) {
    const files = gitOutput.split("\0").filter(Boolean);
    const entries = addParentDirs(files).sort((a, b) => a.path.localeCompare(b.path));
    cache = { cwd, timestamp: Date.now(), entries };
    return entries;
  }

  // Fallback for non-git directories.
  const findOutput = await shellExecFile(
    "find",
    [".", "-path", "./.git", "-prune", "-o", "-path", "./node_modules", "-prune", "-o", "-print"],
    cwd,
    signal,
  );
  if (findOutput === null) return [];

  const entries = findOutput
    .split("\n")
    .filter(Boolean)
    .map((p) => normalizePath(p))
    .filter((p) => p && p !== ".")
    .map((p) => {
      let isDirectory = false;
      try {
        isDirectory = statSync(path.join(cwd, p)).isDirectory();
      } catch {
        // Ignore entries that disappear while scanning.
      }
      return { path: p, isDirectory };
    })
    .sort((a, b) => a.path.localeCompare(b.path));

  cache = { cwd, timestamp: Date.now(), entries };
  return entries;
}

function extractAtPrefix(textBeforeCursor: string): string | null {
  // Matches @foo or @"foo bar, after start/whitespace. Supports an unclosed quote while typing.
  const match = textBeforeCursor.match(/(?:^|\s)(@(?:"[^"]*|\S*))$/);
  return match?.[1] ?? null;
}

function parseAtPrefix(prefix: string): { query: string; quoted: boolean } {
  if (prefix.startsWith('@"')) return { query: prefix.slice(2), quoted: true };
  return { query: prefix.slice(1), quoted: false };
}

function completionValue(entryPath: string, isDirectory: boolean, quoted: boolean): string {
  const displayPath = isDirectory ? `${entryPath}/` : entryPath;
  if (quoted || displayPath.includes(" ")) return `@"${displayPath}"`;
  return `@${displayPath}`;
}

class FuzzyAtEditor extends CustomEditor {
  constructor(tui: any, theme: any, keybindings: any, private readonly cwd: string) {
    super(tui, theme, keybindings);
  }

  setAutocompleteProvider(provider: AutocompleteProvider): void {
    const fuzzyProvider: AutocompleteProvider = {
      ...provider,
      getSuggestions: async (lines, cursorLine, cursorCol, options) => {
        const currentLine = lines[cursorLine] ?? "";
        const prefix = extractAtPrefix(currentLine.slice(0, cursorCol));

        if (!prefix) {
          return provider.getSuggestions(lines, cursorLine, cursorCol, options);
        }

        const { query, quoted } = parseAtPrefix(prefix);
        const entries = await listProjectEntries(this.cwd, options.signal);
        if (options.signal.aborted) return null;

        const matched = query
          ? fuzzyFilter(entries, query, (entry) => `${path.posix.basename(entry.path)} ${entry.path}`)
          : entries;

        const items = matched.slice(0, 20).map((entry) => ({
          value: completionValue(entry.path, entry.isDirectory, quoted),
          label: `${path.posix.basename(entry.path)}${entry.isDirectory ? "/" : ""}`,
          description: entry.path,
        }));

        return items.length > 0 ? { items, prefix } : null;
      },
      applyCompletion: provider.applyCompletion.bind(provider),
      shouldTriggerFileCompletion: provider.shouldTriggerFileCompletion?.bind(provider),
    };

    super.setAutocompleteProvider(fuzzyProvider);
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    if (!ctx.hasUI) return;
    ctx.ui.setEditorComponent((tui, theme, keybindings) => new FuzzyAtEditor(tui, theme, keybindings, ctx.cwd));
  });

  pi.on("session_shutdown", (_event, ctx) => {
    if (!ctx.hasUI) return;
    ctx.ui.setEditorComponent(undefined);
  });
}
