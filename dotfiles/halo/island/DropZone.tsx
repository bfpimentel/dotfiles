import { Box, Image, Text, animate } from "halo";
import { onCleanup, type Accessor } from "halo/signals";
import { settle } from "@/island/Body";
import { shelf } from "@/shelf/store";
import { theme } from "@/ui/theme";

const plural = (count: number) => (count === 1 ? "1 file" : `${count} files`);

export function DropZone(props: { over: Accessor<boolean>; incoming: Accessor<number> }) {
  let bob: { cancel(): void } | undefined;
  onCleanup(() => bob?.cancel());
  return (
    <Box style={{ padding: [8, 12, 12, 12] }}>
      <Box
        style={{
          flexDirection: "row",
          align: "center",
          gap: 18,
          height: 98,
          padding: [0, 22],
          radius: 20,
          borderWidth: 1.5,
          borderColor: () => (props.over() ? "#e8e8e8" : "#ffffff26"),
          background: () => (props.over() ? "#ffffff12" : "#ffffff05"),
          scale: () => (props.over() ? 1 : 0.98),
          transition: { borderColor: 160, background: 160, scale: settle },
        }}
      >
        <Box
          style={{
            width: 58,
            height: 58,
            radius: 16,
            justify: "center",
            align: "center",
            background: "#1a1a1a",
            translateY: () => (props.over() ? 4 : 0),
            scale: () => (props.over() ? 1.08 : 1),
            transition: { translateY: settle, scale: settle },
          }}
        >
          <Image
            ref={(node) => {
              bob = animate(
                node,
                { translateY: [0, -4, 0] },
                { duration: 1600, repeat: Infinity, curve: "ease-in-out" },
              );
            }}
            symbol="tray.and.arrow.down.fill"
            size={26}
            color="#ffffff"
          />
        </Box>
        <Box style={{ gap: 3, grow: 1, shrink: 1 }}>
          <Text style={{ fontSize: 16, fontWeight: "bold", color: "#ffffff" }}>
            {() =>
              props.over()
                ? `Release to shelve ${plural(props.incoming())}`
                : "Drop to add to shelf"
            }
          </Text>
          <Text style={{ fontSize: 12, color: theme.muted }}>
            {() =>
              shelf.files().length
                ? `${plural(shelf.files().length)} on the shelf · originals stay put`
                : "Files stay where they are; the shelf keeps a reference"
            }
          </Text>
        </Box>
      </Box>
    </Box>
  );
}
