import {
  Box,
  For,
  Image,
  Input,
  Text,
  animate,
  type Element,
  type KeyEvent,
  type NativeNode,
  type Reactive,
} from "halo";
import {
  computed,
  effect,
  onCleanup,
  signal,
  untrack,
  type Accessor,
} from "halo/signals";
import { Row } from "@/ui/palette/Row";
import { rank, type SearchOptions } from "@/ui/palette/search";
import type { Binding, Feedback, Item, PaletteContext, Ranked } from "@/ui/palette/types";
import { theme } from "@/ui/theme";

export interface PaletteConfig {
  placeholder: string;
  items: Accessor<Item[]>;
  search: SearchOptions;
  compact?: boolean;
  /** What ↵ does, for the hints footer. Default "open". */
  enterHint?: string;
  heading?: (ctx: PaletteContext) => string;
  /** Rendered between the search bar and the list. */
  middle?: (ctx: PaletteContext) => Element | null;
  keys?: Binding[];
  status?: Reactive<string>;
  empty?: (query: string) => string;
  onOpen?: () => void;
  onRun?: (item: Item) => void;
}

export interface PaletteProps extends PaletteConfig {
  /** Rendered at the right of the search field. */
  accessory?: Element;
  onClose: (feedback?: Feedback) => void;
}

const matches = (binding: Binding, event: KeyEvent) =>
  binding.key === event.key &&
  !!binding.meta === event.meta &&
  !!binding.ctrl === event.ctrl &&
  !!binding.alt === event.alt &&
  (binding.shift === undefined || binding.shift === event.shift);

function Hint(keys: string, label: string) {
  return (
    <Box style={{ flexDirection: "row", align: "center", gap: 6 }}>
      <Box style={{ padding: [2, 6], radius: 3, background: "#ffffff12" }}>
        <Text style={{ fontSize: 11, fontWeight: "semibold", color: theme.foreground }}>
          {keys}
        </Text>
      </Box>
      <Text style={{ fontSize: 11, color: theme.muted }}>{label}</Text>
    </Box>
  );
}

export function Palette(props: PaletteProps) {
  const query = signal("");
  const selectedIndex = signal(0);
  const rows = new Map<string, NativeNode>();

  const idle = computed(() => !query().trim());
  const results = computed<Ranked[]>(() => rank(props.items(), query(), props.search));
  const selected = computed(() => results()[selectedIndex()]?.item);
  const close = () => props.onClose();
  const ctx: PaletteContext = { query, idle, results, selected, close };
  props.onOpen?.();

  effect(() => {
    const count = results().length;
    if (untrack(selectedIndex) >= count) selectedIndex.set(Math.max(0, count - 1));
  });

  const move = (delta: number) => {
    const count = results().length;
    if (count) selectedIndex.update((index) => (index + delta + count) % count);
  };

  // Unmounted before its close fired (e.g. the launched app took focus): finish now, never on a later palette.
  let closing: { timer: ReturnType<typeof setTimeout>; finish: () => void } | undefined;
  onCleanup(() => {
    if (!closing) return;
    clearTimeout(closing.timer);
    queueMicrotask(closing.finish);
  });

  const choose = (entry: Ranked | undefined) => {
    if (!entry) return;
    const { item } = entry;
    const row = rows.get(item.id);
    if (row)
      animate(row, { scale: [1, 0.95, 1.02, 1] }, { duration: 280, curve: "ease-out" });
    const feedback = item.feedback?.();
    item.run();
    props.onRun?.(item);
    const delay = item.closeAfter ?? 170;
    if (delay === false) return;
    clearTimeout(closing?.timer);
    const finish = () => {
      closing = undefined;
      props.onClose(feedback);
    };
    closing = { timer: setTimeout(finish, delay), finish };
  };

  const onKeyDown = (event: KeyEvent) => {
    const binding = [...(selected()?.actions ?? []), ...(props.keys ?? [])].find(
      (candidate) => matches(candidate, event),
    );
    if (binding) {
      binding.run();
      return true;
    }
    const { key, ctrl } = event;
    if (key === "ArrowDown" || (ctrl && key === "n")) move(1);
    else if (key === "ArrowUp" || (ctrl && key === "p")) move(-1);
    else if (key === "Enter") choose(results()[selectedIndex()]);
    else if (key === "Escape") {
      if (query()) {
        query.set("");
        selectedIndex.set(0);
      } else close();
    } else return false;
    return true;
  };

  function Empty() {
    let icon: NativeNode | undefined;
    const view = (
      <Box
        style={{ height: 104, justify: "center", align: "center", gap: 10 }}
        enter={{ from: { opacity: 0, scale: 0.94 }, duration: 180 }}
      >
        <Image
          ref={(node) => (icon = node)}
          symbol="questionmark.app.dashed"
          size={28}
          color={theme.muted}
        />
        <Text style={{ fontSize: 13, color: theme.muted }}>
          {props.empty?.(query().trim()) ?? `Nothing matches “${query().trim()}”`}
        </Text>
      </Box>
    );
    if (icon)
      animate(
        icon,
        { rotate: [0, -14, 11, -6, 3, 0] },
        { duration: 560, curve: "ease-out" },
      );
    return view;
  }

  return (
    <Box style={{ width: "100%", padding: [0, 8, 10, 8] }}>
      <Box style={{ flexDirection: "row", align: "center", gap: 12, padding: [12, 12] }}>
        <Image
          symbol="magnifyingglass"
          size={20}
          color={() => (query() ? theme.accent : theme.muted)}
        />
        <Input
          autofocus
          value={query}
          placeholder={props.placeholder}
          style={{ grow: 1, shrink: 1, width: 40, fontSize: 22, color: theme.foreground }}
          onInput={(value) => {
            query.set(value);
            selectedIndex.set(0);
          }}
          onKeyDown={onKeyDown}
        />
        {props.accessory ?? null}
      </Box>
      <Box style={{ height: 1, background: "#ffffff10" }} />
      {() => props.middle?.(ctx) ?? null}
      {props.heading ? (
        <Box style={{ padding: [10, 12, 6, 12] }}>
          <Text style={{ fontSize: 10, fontWeight: "bold", color: theme.muted }}>
            {() => props.heading!(ctx)}
          </Text>
        </Box>
      ) : null}
      <Box style={{ gap: 2 }}>
        <For each={results} key={(entry) => entry.item.id}>
          {(entry, index) => {
            const id = entry().item.id;
            onCleanup(() => rows.delete(id));
            return (
              <Row
                entry={entry}
                index={index}
                selected={() => selectedIndex() === index()}
                compact={!!props.compact}
                ref={(node) => rows.set(id, node)}
                onHover={() => selectedIndex.set(index())}
                onClick={() => {
                  selectedIndex.set(index());
                  choose(entry());
                }}
              />
            );
          }}
        </For>
        {() => (results().length ? null : Empty())}
      </Box>
      <Box
        style={{
          flexDirection: "row",
          align: "center",
          gap: 14,
          padding: [12, 12, 2, 12],
        }}
      >
        {Hint("↑↓", "select")}
        {Hint("↵", props.enterHint ?? "open")}
        {() =>
          (selected()?.actions ?? []).map((action) => Hint(action.label, action.hint))
        }
        {(props.keys ?? []).map((binding) => Hint(binding.label, binding.hint))}
        {Hint("esc", "clear / close")}
        <Box style={{ grow: 1 }} />
        {props.status === undefined ? null : (
          <Text style={{ fontSize: 11, color: theme.muted }}>{props.status}</Text>
        )}
      </Box>
    </Box>
  );
}
