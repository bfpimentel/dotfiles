import { Box, For, Image, Text, exec } from "halo";
import { signal, type Accessor, type Signal } from "halo/signals";
import { shelf } from "@/shelf/store";
import { theme } from "@/ui/theme";

const ease = [0.2, 0.9, 0.3, 1] as [number, number, number, number];
const shown = 8;
const icon = 28;
const gap = 6;
const label = 120;
const name = (path: string) => path.split("/").filter(Boolean).pop() ?? path;
const plural = (count: number) => (count === 1 ? "1 file" : `${count} files`);
const short = (text: string) => (text.length > 18 ? `${text.slice(0, 17)}…` : text);

/** Grows with each file shown, never narrower than the compact pill. */
export const shelfWidth = (count: number) =>
  Math.max(300, 12 + 16 + 10 + Math.min(count, shown) * (icon + gap) + label + 12);

function File(props: { path: Accessor<string>; hovered: Signal<string | undefined> }) {
  const over = () => props.hovered() === props.path();
  return (
    <Box
      onHover={(hovered) => {
        if (hovered) props.hovered.set(props.path());
        else if (over()) props.hovered.set(undefined);
      }}
      onClick={({ clicks }) => clicks > 1 && exec("open", [props.path()])}
      draggable={() => ({ files: [props.path()] })}
      enter={{ from: { opacity: 0, scale: 0.6 }, duration: 240, curve: ease }}
      exit={{ to: { opacity: 0, scale: 0.6 }, duration: 120, curve: "ease-in" }}
      style={{
        width: icon,
        height: icon,
        justify: "center",
        align: "center",
        radius: 7,
        background: () => (over() ? "#ffffff1c" : "#ffffff00"),
        transition: { background: 100 },
      }}
    >
      <Image app={props.path()} size={22} />
      <Box
        onClick={() => shelf.remove(props.path())}
        style={{
          position: "absolute",
          top: -3,
          right: -3,
          width: 13,
          height: 13,
          radius: 7,
          justify: "center",
          align: "center",
          background: "#3a3a3a",
          opacity: () => (over() ? 1 : 0),
          transition: { opacity: 100 },
        }}
      >
        <Image symbol="xmark" size={7} color={theme.foreground} />
      </Box>
    </Box>
  );
}

export function Shelf() {
  const hovered = signal<string | undefined>(undefined);
  return (
    <Box
      style={{
        flexDirection: "row",
        align: "center",
        gap: 10,
        height: 40,
        padding: [0, 12],
      }}
    >
      <Image symbol="tray.full.fill" size={14} color={theme.muted} />
      <Box style={{ flexDirection: "row", gap }}>
        <For each={() => shelf.files().slice(-shown)}>
          {(path) => <File path={path} hovered={hovered} />}
        </For>
      </Box>
      <Box style={{ grow: 1 }} />
      <Text style={{ fontSize: 11, fontWeight: "semibold", color: theme.muted }}>
        {() => {
          const current = hovered();
          return current ? short(name(current)) : plural(shelf.files().length);
        }}
      </Text>
    </Box>
  );
}
