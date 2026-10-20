import type { Item, Match, Ranked } from "@/ui/palette/types";

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

export interface SearchOptions {
  limit: number;
  /** The limit while the query is empty. Defaults to `limit`. */
  idleLimit?: number;
  /** Alias → item title: typing a prefix of the alias ranks that item first. */
  aliases?: Record<string, string>;
  /** Extra score for an item that matched, e.g. how often or how recently it was used. */
  boost?: (item: Item) => number;
  /** What to list while the query is empty. Defaults to every item, in order. */
  idle?: (items: Item[]) => Item[];
  /** Items computed from the query itself, listed above the matches. */
  extras?: (query: string) => Item[];
}

const unmatched = (item: Item): Ranked => ({ item, match: { score: 0, indices: [] } });

export function rank(items: Item[], query: string, options: SearchOptions): Ranked[] {
  const q = query.trim();
  if (!q)
    return (options.idle?.(items) ?? items)
      .slice(0, options.idleLimit ?? options.limit)
      .map(unmatched);

  const aliased = new Set(
    Object.entries(options.aliases ?? {})
      .filter(([alias]) => alias.startsWith(q.toLowerCase()))
      .map(([, title]) => title.toLowerCase()),
  );
  const matches = items
    .map((item) => {
      const match = fuzzy(q, item.title);
      const alias = aliased.has(item.title.toLowerCase());
      if (!match && !alias) return null;
      const score =
        (match?.score ?? 0) + (alias ? 500 : 0) + (options.boost?.(item) ?? 0);
      return { item, match: { score, indices: match?.indices ?? [] } };
    })
    .filter((ranked): ranked is Ranked => !!ranked)
    .sort((a, b) => b.match.score - a.match.score);
  return [...(options.extras?.(q) ?? []).map(unmatched), ...matches].slice(
    0,
    options.limit,
  );
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
