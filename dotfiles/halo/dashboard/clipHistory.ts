import { readFile, sh, writeFile } from "halo";
import { session } from "halo/services";
import { computed, effect, onCleanup, signal, untrack } from "halo/signals";

export interface Clip {
  text: string;
  copiedAt: number;
}

const historyFile = "~/.cache/halo/clipboard-history.json";
// Without an explicit locale (as under launchd) pbpaste/pbcopy mangle non-ASCII text.
const utf8 = "LC_ALL=en_US.UTF-8";
const maxLength = 10_000;

const shellQuote = (value: string) => `'${value.replace(/'/g, `'\\''`)}'`;

export function clipboardHistory(options: { intervalMs: number; max: number }) {
  const clips = signal<Clip[]>([]);
  const loaded = signal(false);
  const away = computed(
    () => session.locked() === true || session.displaysAsleep() === true,
  );
  let last: string | undefined;
  let timer = 0;
  let generation = 0;

  const save = () =>
    writeFile(historyFile, JSON.stringify(untrack(clips))).catch(() => {});

  const add = (text: string) => {
    if (!text.trim() || text.length > maxLength) return;
    const rest = untrack(clips).filter((clip) => clip.text !== text);
    clips.set([{ text, copiedAt: Date.now() }, ...rest].slice(0, options.max));
    save();
  };

  const check = (current: number) =>
    sh(`${utf8} pbpaste`).then(({ stdout, code }) => {
      if (current !== generation) return;
      if (code === 0 && stdout !== last) {
        if (stdout !== untrack(clips)[0]?.text) add(stdout);
        last = stdout;
      }
      timer = setTimeout(() => check(current), options.intervalMs);
    });

  const stop = () => {
    generation++;
    clearTimeout(timer);
  };

  readFile(historyFile)
    .then((text) => clips.set(JSON.parse(text)))
    .catch(() => {})
    .finally(() => loaded.set(true));

  effect(() => {
    if (!loaded() || away()) return;
    check(++generation);
    onCleanup(stop);
  });

  return {
    clips,
    copy(text: string) {
      last = text;
      add(text);
      return sh(`printf %s ${shellQuote(text)} | ${utf8} pbcopy`);
    },
    remove(text: string) {
      clips.set(untrack(clips).filter((clip) => clip.text !== text));
      save();
    },
    clear() {
      clips.set([]);
      if (untrack(loaded)) save();
    },
  };
}
