import type { Usage } from "@/dashboard/apps";
import type { Item } from "@/dashboard/items";

export interface Match {
  score: number;
  indices: number[];
}

const isBoundary = (text: string, i: number) =>
  i === 0 ||
  /[\s\-_.]/.test(text[i - 1]) ||
  (text[i] !== text[i].toLowerCase() && text[i - 1] === text[i - 1].toLowerCase());

// Substring matches win (prefix, then word start); otherwise a subsequence scored by consecutive runs and word starts.
export function fuzzy(query: string, text: string): Match | null {
  const q = query.toLowerCase();
  const t = text.toLowerCase();
  if (!q) return { score: 0, indices: [] };

  const at = t.indexOf(q);
  if (at >= 0) {
    const bonus = at === 0 ? 300 : isBoundary(text, at) ? 200 : 100;
    return {
      score: bonus + q.length * 10 - at - (t.length - q.length) * 0.5,
      indices: [...Array(q.length).keys()].map((i) => i + at),
    };
  }

  const indices: number[] = [];
  let score = 0;
  let from = 0;
  for (const char of q) {
    let index = -1;
    for (let i = from; i < t.length; i++) {
      if (t[i] !== char) continue;
      if (index < 0) index = i;
      if (isBoundary(text, i)) {
        index = i;
        break;
      }
      if (indices.length && i === indices[indices.length - 1] + 1) break;
    }
    if (index < 0) return null;
    const previous = indices[indices.length - 1];
    score +=
      10 +
      (isBoundary(text, index) ? 15 : 0) +
      (previous !== undefined && index === previous + 1 ? 12 : 0);
    score -= previous === undefined ? index : index - previous - 1;
    indices.push(index);
    from = index + 1;
  }
  return { score, indices };
}

// A launch counts half as much after a week.
export function usageBoost(usage: Usage | undefined, now = Date.now()): number {
  if (!usage) return 0;
  const days = (now - usage.last) / 86_400_000;
  return Math.min(120, usage.count * 12) * Math.pow(0.5, days / 7);
}

export interface Ranked {
  item: Item;
  match: Match;
}

export function rank(
  items: Item[],
  query: string,
  options: {
    aliases: Record<string, string>;
    pinned: string[];
    recents: Record<string, Usage>;
    limit: number;
  },
): Ranked[] {
  const q = query.trim();
  if (!q) {
    const pinned = options.pinned
      .map((title) => items.find((item) => item.title === title))
      .filter((item): item is Item => !!item);
    const recent = items
      .filter((item) => options.recents[item.id] && !pinned.includes(item))
      .sort((a, b) => options.recents[b.id].last - options.recents[a.id].last);
    return [...pinned, ...recent]
      .slice(0, options.limit)
      .map((item) => ({ item, match: { score: 0, indices: [] } }));
  }

  const aliased = new Set(
    Object.entries(options.aliases)
      .filter(([alias]) => alias.startsWith(q.toLowerCase()))
      .map(([, title]) => title.toLowerCase()),
  );
  return items
    .map((item) => {
      const match = fuzzy(q, item.title);
      const alias = aliased.has(item.title.toLowerCase());
      if (!match && !alias) return null;
      const score =
        (match?.score ?? 0) + (alias ? 500 : 0) + usageBoost(options.recents[item.id]);
      return { item, match: { score, indices: match?.indices ?? [] } };
    })
    .filter((ranked): ranked is Ranked => !!ranked)
    .sort((a, b) => b.match.score - a.match.score)
    .slice(0, options.limit);
}

export function segments(
  text: string,
  indices: number[],
): { text: string; hit: boolean }[] {
  const hits = new Set(indices);
  const runs: { text: string; hit: boolean }[] = [];
  for (let i = 0; i < text.length; i++) {
    const hit = hits.has(i);
    const last = runs[runs.length - 1];
    if (last && last.hit === hit) last.text += text[i];
    else runs.push({ text: text[i], hit });
  }
  return runs;
}

export function calculate(query: string): number | undefined {
  const expression = query.trim();
  if (
    !/^[\d\s+\-*/().,%^]+$/.test(expression) ||
    !/\d/.test(expression) ||
    !/[+\-*/%^]/.test(expression)
  )
    return undefined;
  try {
    const value = Function(
      `"use strict"; return (${expression.replace(/\^/g, "**").replace(/,/g, ".")});`,
    )();
    return typeof value === "number" && Number.isFinite(value) ? value : undefined;
  } catch {
    return undefined;
  }
}
