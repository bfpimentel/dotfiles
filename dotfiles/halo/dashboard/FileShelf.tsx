import {
  Box,
  For,
  Image,
  Surface,
  Text,
  exec,
  type Element,
  type ScreenInfo,
} from "halo";
import { drag } from "halo/services";
import { computed, effect, signal, type Accessor } from "halo/signals";
import { SymbolIcon, alpha, type Theme } from "@/dashboard/items";
import type { FileShelf as Store } from "@/dashboard/shelf";

const ease = [0.2, 0.9, 0.3, 1] as [number, number, number, number];

const name = (path: string) => path.split("/").filter(Boolean).pop() ?? path;
const folder = (path: string) => path.split("/").slice(-2, -1)[0] ?? "/";
const plural = (count: number) => (count === 1 ? "1 file" : `${count} files`);

export function FileShelf(props: { screen: ScreenInfo; theme: Theme; shelf: Store }) {
  const { theme, shelf } = props;
  const over = signal(false);
  const incoming = signal(0);
  const expanded = signal(false);
  const selected = signal(new Set<string>());
  const dropping = computed(() => drag.active() && !drag.outgoing());
  const mode = computed(() =>
    dropping() ? "drop" : expanded() && shelf.files().length ? "list" : "tab",
  );

  effect(() => {
    const files = new Set(shelf.files());
    const kept = [...selected()].filter((path) => files.has(path));
    if (kept.length !== selected().size) selected.set(new Set(kept));
  });

  // Moved-out files vanish from disk a moment after the drop; prune then, so an emptied shelf hides itself.
  let leaving = false;
  effect(() => {
    if (drag.active() && drag.outgoing()) {
      leaving = true;
    } else if (!drag.active() && leaving) {
      leaving = false;
      setTimeout(shelf.prune, 400);
      setTimeout(shelf.prune, 1500);
    }
  });

  const toggle = (path: string) => {
    const next = new Set(selected());
    if (next.has(path)) next.delete(path);
    else next.add(path);
    selected.set(next);
  };

  const outgoingFiles = (path: string) =>
    selected().has(path) ? shelf.files().filter((file) => selected().has(file)) : [path];

  function Header(hint: () => string) {
    return (
      <Box style={{ flexDirection: "row", align: "center", padding: [6, 10, 4, 10] }}>
        <Text style={{ grow: 1, fontSize: 10, fontWeight: "bold", color: theme.muted }}>
          SHELF
        </Text>
        <Text style={{ fontSize: 10, color: theme.muted }}>{hint}</Text>
      </Box>
    );
  }

  function Chip(props: {
    label: () => string;
    symbol: string;
    onClick?: () => void;
    files?: () => string[];
  }) {
    const hovered = signal(false);
    return (
      <Box
        onHover={hovered.set}
        onClick={props.onClick}
        draggable={props.files && (() => ({ files: props.files?.() ?? [] }))}
        style={{
          flexDirection: "row",
          align: "center",
          gap: 5,
          padding: [3, 7],
          radius: 3,
          background: () => (hovered() ? "#ffffff1a" : "#ffffff0a"),
          transition: { background: 100 },
        }}
      >
        <Image symbol={props.symbol} size={11} color={theme.muted} />
        <Text
          style={{
            fontSize: 11,
            color: () => (hovered() ? theme.foreground : theme.muted),
          }}
        >
          {props.label}
        </Text>
      </Box>
    );
  }

  function Row(path: Accessor<string>) {
    const hovered = signal(false);
    const isSelected = () => selected().has(path());
    return (
      <Box
        onHover={hovered.set}
        onClick={({ clicks }) => (clicks > 1 ? exec("open", [path()]) : toggle(path()))}
        draggable={() => ({ files: outgoingFiles(path()) })}
        enter={{ from: { opacity: 0, translateY: -6 }, duration: 180, curve: ease }}
        exit={{ to: { opacity: 0 }, duration: 120, curve: "ease-in" }}
        style={{
          flexDirection: "row",
          align: "center",
          gap: 12,
          height: 44,
          padding: [0, 10],
          radius: 5,
          background: () =>
            alpha(theme.accent, isSelected() ? 0.16 : hovered() ? 0.08 : 0),
          transition: { background: 100 },
        }}
      >
        <Image app={path()} size={28} />
        <Box style={{ grow: 1, shrink: 1, gap: 1 }}>
          <Text style={{ fontSize: 13, fontWeight: "medium", color: theme.foreground }}>
            {name(path())}
          </Text>
          <Text style={{ fontSize: 11, color: theme.muted }}>{folder(path())}</Text>
        </Box>
        <Box
          onClick={() => shelf.remove(path())}
          style={{
            padding: 4,
            radius: 3,
            opacity: () => (hovered() ? 1 : 0),
            transition: { opacity: 100 },
          }}
        >
          <Image symbol="xmark" size={10} color={theme.muted} />
        </Box>
      </Box>
    );
  }

  const panel = (children: () => Element, hint: () => string) => (
    <Box
      enter={{ from: { opacity: 0, translateY: -8 }, duration: 180, curve: ease }}
      style={{
        width: 300,
        padding: 6,
        gap: 2,
        background: theme.background,
        radius: 9,
        borderWidth: 1,
        borderColor: "#ffffff12",
      }}
    >
      {Header(hint)}
      {children()}
    </Box>
  );

  const drop = () =>
    panel(
      () => [
        <Box
          style={{
            flexDirection: "row",
            align: "center",
            gap: 12,
            height: 48,
            padding: [0, 10],
            radius: 5,
            background: () => alpha(theme.accent, over() ? 0.16 : 0.06),
            transition: { background: 120 },
          }}
        >
          {SymbolIcon("tray.and.arrow.down", theme)}
          <Box style={{ gap: 1 }}>
            <Text style={{ fontSize: 13, fontWeight: "medium", color: theme.foreground }}>
              {() => (over() ? "Release to shelve" : "Drop here")}
            </Text>
            <Text style={{ fontSize: 11, color: theme.muted }}>
              {() =>
                over()
                  ? plural(incoming())
                  : `${plural(shelf.files().length)} on the shelf`
              }
            </Text>
          </Box>
        </Box>,
      ],
      () => "drop to add",
    );

  const list = () =>
    panel(
      () => [
        <For each={shelf.files}>{Row}</For>,
        <Box style={{ flexDirection: "row", gap: 6, padding: [6, 4, 2, 4] }}>
          <Chip
            label={() =>
              selected().size ? `drag ${plural(selected().size)}` : "drag all"
            }
            symbol="hand.draw"
            files={() =>
              selected().size
                ? shelf.files().filter((file) => selected().has(file))
                : shelf.files()
            }
          />
          <Box style={{ grow: 1 }} />
          <Chip
            label={() => (selected().size ? "remove selected" : "clear")}
            symbol="trash"
            onClick={() => {
              if (!selected().size) return shelf.clear();
              for (const path of selected()) shelf.remove(path);
            }}
          />
        </Box>,
      ],
      () => "click select · double-click open",
    );

  const tab = () => (
    <Box
      enter={{ from: { opacity: 0, translateY: -8 }, duration: 180, curve: ease }}
      style={{
        flexDirection: "row",
        align: "center",
        gap: 4,
        padding: 6,
        background: theme.background,
        radius: 9,
        borderWidth: 1,
        borderColor: "#ffffff12",
      }}
    >
      <Image symbol="tray.full" size={13} color={theme.muted} />
      {() =>
        shelf
          .files()
          .slice(-4)
          .map((path) => <Image app={path} size={20} />)
      }
    </Box>
  );

  return (
    <Surface
      name="shelf"
      screen={props.screen}
      anchor={["top", "right"]}
      margins={[8, 8, 0, 0]}
      avoid={["menuBar"]}
      layer="overlay"
      input="interactive"
      visible={() => dropping() || shelf.files().length > 0}
    >
      <Box
        onDragEnter={({ files }) => {
          incoming.set(files.length);
          over.set(true);
        }}
        onDragLeave={() => over.set(false)}
        onDrop={({ files }) => {
          over.set(false);
          shelf.add(files);
        }}
        onHover={(value) => {
          expanded.set(value);
          if (value) shelf.prune();
        }}
        style={{ align: "end" }}
      >
        {() => (mode() === "drop" ? drop() : mode() === "list" ? list() : tab())}
      </Box>
    </Surface>
  );
}
