import { Box, Text, type NativeNode } from "halo";
import type { Accessor } from "halo/signals";
import { segments } from "@/ui/palette/search";
import type { Ranked } from "@/ui/palette/types";
import { alpha, theme } from "@/ui/theme";

const snappy = { stiffness: 520, damping: 30 };

const read = <T,>(value: T | (() => T)) =>
  typeof value === "function" ? (value as () => T)() : value;

export function Row(props: {
  entry: Accessor<Ranked>;
  index: Accessor<number>;
  selected: Accessor<boolean>;
  compact: boolean;
  ref: (node: NativeNode) => void;
  onHover: () => void;
  onClick: () => void;
}) {
  const { entry, selected, compact } = props;
  const { item } = entry();

  return (
    <Box
      ref={props.ref}
      style={{
        flexDirection: "row",
        align: "center",
        gap: 12,
        height: compact ? 36 : 48,
        padding: [0, 12],
        radius: 5,
        background: () => alpha(theme.accent, selected() ? 0.16 : 0),
        transition: { background: 140 },
      }}
      enter={{
        from: { opacity: 0, translateY: 10 },
        duration: 200,
        delay: props.index() * 22,
        curve: [0.2, 0.9, 0.3, 1],
      }}
      onHover={(hovered) => hovered && props.onHover()}
      onClick={props.onClick}
    >
      {item.icon ? (
        <Box
          style={{
            width: 32,
            height: 32,
            scale: () => (selected() ? 1.1 : 1),
            transition: { scale: { curve: snappy } },
          }}
        >
          {item.icon(selected)}
          {item.badge?.() ?? null}
        </Box>
      ) : null}
      <Box style={{ grow: 1, shrink: 1, gap: 1 }}>
        <Box style={{ flexDirection: "row" }}>
          {() => {
            const title = entry().item.title.slice(0, compact ? 76 : 60);
            const parts = segments(
              title,
              entry().match.indices.filter((index) => index < title.length),
            );
            const fontSize = compact ? 13 : 14;
            // Text drops whitespace at its edges, so spaces between highlighted runs become gaps.
            const gap = (spaces: number) =>
              spaces ? <Box style={{ width: spaces * fontSize * 0.28 }} /> : null;
            return parts.map((part, index) => [
              gap(part.text.length - part.text.trimStart().length),
              <Text
                style={{
                  shrink: index === parts.length - 1 ? 1 : 0,
                  fontSize,
                  fontWeight: part.hit ? "bold" : "medium",
                  color: part.hit ? theme.accent : theme.foreground,
                }}
              >
                {part.text.trim()}
              </Text>,
              gap(part.text.length - part.text.trimEnd().length),
            ]);
          }}
        </Box>
        {item.subtitle === undefined ? null : (
          <Text style={{ fontSize: 11, color: theme.muted }}>
            {() => read(entry().item.subtitle ?? "")}
          </Text>
        )}
      </Box>
      {item.accessory === undefined ? null : (
        <Text style={{ fontSize: 11, color: theme.muted }}>
          {() => read(entry().item.accessory ?? "")}
        </Text>
      )}
      <Text
        style={{
          fontSize: 13,
          fontWeight: "semibold",
          color: theme.accent,
          opacity: () => (selected() ? 1 : 0),
          translateX: () => (selected() ? 0 : -8),
          transition: { opacity: 120, translateX: { curve: snappy } },
        }}
      >
        ↵
      </Text>
    </Box>
  );
}
