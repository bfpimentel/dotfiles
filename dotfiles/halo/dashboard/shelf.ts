import { readFile, sh, writeFile } from "halo";
import { signal, untrack } from "halo/signals";

const shelfFile = "~/.cache/halo/shelf.json";

const shellQuote = (value: string) => `'${value.replace(/'/g, `'\\''`)}'`;

export function fileShelf() {
  const files = signal<string[]>([]);

  const set = (next: string[]) => {
    files.set(next);
    writeFile(shelfFile, JSON.stringify(next)).catch(() => {});
  };

  readFile(shelfFile)
    .then((text) => files.set(JSON.parse(text)))
    .catch(() => {});

  return {
    files,
    add(paths: string[]) {
      const current = untrack(files);
      set([...current, ...paths.filter((path) => !current.includes(path))]);
    },
    remove(path: string) {
      set(untrack(files).filter((file) => file !== path));
    },
    clear() {
      set([]);
    },
    // Files dragged out with a move, or deleted, no longer exist.
    prune() {
      const current = untrack(files);
      if (!current.length) return;
      sh(
        `for f in ${current.map(shellQuote).join(" ")}; do [ -e "$f" ] && printf '%s\\n' "$f"; done`,
      ).then(({ stdout }) => {
        const existing = new Set(stdout.split("\n").filter(Boolean));
        if (existing.size !== current.length)
          set(untrack(files).filter((file) => existing.has(file)));
      });
    },
  };
}

export type FileShelf = ReturnType<typeof fileShelf>;
