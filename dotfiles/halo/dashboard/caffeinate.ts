import { sh } from "halo";
import { signal } from "halo/signals";

// Detached and tracked by pid file, so it survives halo reloads and restarts.
const state = "$HOME/.cache/halo/caffeinate";

const alive = `read -r pid since 2>/dev/null < "${state}" && ps -p "$pid" -o comm= | grep -q caffeinate`;

/** When caffeinate started (epoch ms), or `undefined` while it isn't running. */
export const caffeinated = signal<number | undefined>(undefined);

export function checkCaffeinate() {
  return sh(`${alive} && echo "$since"`).then(({ stdout, code }) =>
    caffeinated.set(code === 0 ? Number(stdout.trim()) * 1000 : undefined),
  );
}

export function toggleCaffeinate() {
  return sh(
    `if ${alive}; then kill "$pid"; rm -f "${state}"; else ` +
      `mkdir -p "$(dirname "${state}")"; nohup caffeinate -di >/dev/null 2>&1 & ` +
      `echo "$! $(date +%s)" > "${state}"; fi`,
  ).then(checkCaffeinate);
}

checkCaffeinate();
