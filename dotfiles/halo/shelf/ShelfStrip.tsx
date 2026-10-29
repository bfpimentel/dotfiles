import { Box, For, Image, Text, exec } from "halo";
import { signal, type Accessor } from "halo/signals";
import { shelf } from "@/shelf/store";
import { theme } from "@/ui/theme";

const ease = [0.2, 0.9, 0.3, 1] as [number, number, number, number];
const name = (path: string) => path.split("/").filter(Boolean).pop() ?? path;

function Chip(path: Accessor<string>) {
  const hovered = signal(false);
  return (
    <Box
      onHover={hovered.set}
      onClick={({ clicks }) => clicks > 1 && exec("open", [path()])}
      draggable={() => ({ files: [path()] })}
      enter={{ from: { opacity: 0, scale: 0.8 }, duration: 240, curve: ease }}
      exit={{ to: { opacity: 0, scale: 0.8 }, duration: 120, curve: "ease-in" }}
      style={{
        flexDirection: "row",
        align: "center",
        gap: 6,
        height: 30,
        padding: [0, 4, 0, 8],
        radius: 8,
        background: () => (hovered() ? "#ffffff1c" : "#ffffff0d"),
        transition: { background: 100 },
      }}
    >
      <Image app={path()} size={18} />
      <Text style={{ fontSize: 12, color: theme.foreground }}>{name(path())}</Text>
      <Box
        onClick={() => shelf.remove(path())}
        style={{
          padding: 5,
          radius: 5,
          opacity: () => (hovered() ? 1 : 0),
          transition: { opacity: 100 },
        }}
      >
        <Image symbol="xmark" size={9} color={theme.muted} />
      </Box>
    </Box>
  );
}

export function ShelfStrip() {
  const clearHovered = signal(false);
  return (
    <Box
      enter={{ from: { opacity: 0, translateY: -6 }, duration: 200, curve: ease }}
      style={{ flexDirection: "row", align: "center", gap: 6, padding: [8, 12, 4, 12] }}
    >
      <Image symbol="tray.full" size={13} color={theme.muted} />
      <Text style={{ fontSize: 10, fontWeight: "bold", color: theme.muted }}>SHELF</Text>
      <Box
        style={{
          flexDirection: "row",
          gap: 6,
          grow: 1,
          shrink: 1,
          padding: [0, 0, 0, 4],
        }}
      >
        <For each={() => shelf.files().slice(-4)}>{Chip}</For>
      </Box>
      <Box
        onHover={clearHovered.set}
        onClick={() => shelf.clear()}
        style={{
          padding: [4, 8],
          radius: 6,
          background: () => (clearHovered() ? "#ffffff14" : "#ffffff00"),
          transition: { background: 100 },
        }}
      >
        <Text style={{ fontSize: 11, fontWeight: "semibold", color: theme.muted }}>
          {() => `Clear ${shelf.files().length}`}
        </Text>
      </Box>
    </Box>
  );
}
