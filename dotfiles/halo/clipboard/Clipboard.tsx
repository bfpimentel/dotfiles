import { computed } from "halo/signals";
import type { Clip, ClipboardHistory } from "@/clipboard/history";
import type { PaletteConfig } from "@/ui/palette/Palette";
import type { Item } from "@/ui/palette/types";

const searchLength = 300;

function age(time: number) {
  const minutes = Math.floor((Date.now() - time) / 60_000);
  if (minutes < 1) return "now";
  if (minutes < 60) return `${minutes}m`;
  const hours = Math.floor(minutes / 60);
  return hours < 24 ? `${hours}h` : `${Math.floor(hours / 24)}d`;
}

// A fresh clip outranks a slightly better match; the bonus halves every day.
const recency = (copiedAt: number | undefined) =>
  copiedAt === undefined ? 0 : 40 * Math.pow(0.5, (Date.now() - copiedAt) / 86_400_000);

function clipItem(clip: Clip, history: ClipboardHistory): Item {
  return {
    id: clip.text,
    title: clip.text.replace(/\s+/g, " ").trim().slice(0, searchLength),
    accessory: () => age(clip.copiedAt),
    run: () => history.copy(clip.text),
    closeAfter: 0,
    feedback: () => ({
      title: "Copied",
      subtitle: clip.text.replace(/\s+/g, " ").trim().slice(0, 80),
      symbol: "doc.on.clipboard",
    }),
    actions: [
      {
        key: "Backspace",
        meta: true,
        label: "⌘⌫",
        hint: "remove",
        run: () => history.remove(clip.text),
      },
    ],
  };
}

export function clipboardPalette(history: ClipboardHistory, rows: number): PaletteConfig {
  const items = computed(() => history.clips().map((clip) => clipItem(clip, history)));
  const copiedAt = computed(
    () => new Map(history.clips().map((clip) => [clip.text, clip.copiedAt])),
  );

  return {
    placeholder: "Search clipboard…",
    items,
    compact: true,
    enterHint: "copy",
    search: { limit: rows, boost: (item) => recency(copiedAt().get(item.id)) },
    heading: (ctx) =>
      ctx.idle() ? "CLIPBOARD" : `${ctx.results().length} OF ${history.clips().length}`,
    status: () => `${history.clips().length} items`,
    empty: (query) => (query ? `Nothing matches “${query}”` : "Nothing copied yet."),
  };
}
