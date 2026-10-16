import { sh } from "halo";
import { onCleanup, signal, untrack } from "halo/signals";

export interface Clip {
  text: string;
  copiedAt: number;
}

const historyFile = "$HOME/.cache/halo/clipboard-history.json";
// Without an explicit locale (as under launchd) pbpaste/pbcopy mangle non-ASCII text.
const utf8 = "LC_ALL=en_US.UTF-8";
const maxLength = 10_000;

const shellQuote = (value: string) => `'${value.replace(/'/g, `'\\''`)}'`;

export function clipboardHistory(options: { intervalMs: number; max: number }) {
  const clips = signal<Clip[]>([]);
  let last: string | undefined;
  let loaded = false;
  let timer = 0;
  let stopped = false;

  const save = () =>
    sh(
      `mkdir -p "$HOME/.cache/halo" && printf %s ${shellQuote(JSON.stringify(clips()))} > "${historyFile}"`,
    );

  const add = (text: string) => {
    if (!text.trim() || text.length > maxLength) return;
    const rest = untrack(clips).filter((clip) => clip.text !== text);
    clips.set([{ text, copiedAt: Date.now() }, ...rest].slice(0, options.max));
    save();
  };

  const check = () =>
    sh(`${utf8} pbpaste`).then(({ stdout, code }) => {
      if (stopped) return;
      if (code === 0 && stdout !== last) {
        if (stdout !== untrack(clips)[0]?.text) add(stdout);
        last = stdout;
      }
      timer = setTimeout(check, options.intervalMs);
    });

  sh(`cat "${historyFile}" 2>/dev/null`).then(({ stdout }) => {
    try {
      if (stdout) clips.set(JSON.parse(stdout));
    } catch {}
    loaded = true;
    check();
  });

  onCleanup(() => {
    stopped = true;
    clearTimeout(timer);
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
      if (loaded) save();
    },
  };
}
