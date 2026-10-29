import { Box, Image, Text } from "halo";
import { feedback } from "@/island/state";
import { theme } from "@/ui/theme";

export function Toast() {
  const current = feedback();
  if (!current) return null;
  return (
    <Box
      style={{
        flexDirection: "row",
        align: "center",
        gap: 12,
        height: 58,
        padding: [0, 18, 0, 12],
      }}
    >
      <Box
        style={{
          width: 36,
          height: 36,
          radius: 10,
          justify: "center",
          align: "center",
          background: "#1c1c1c",
        }}
      >
        {current.app ? (
          <Image app={current.app} size={30} />
        ) : (
          <Image
            symbol={current.symbol ?? "checkmark"}
            size={17}
            color={theme.foreground}
          />
        )}
      </Box>
      <Box style={{ grow: 1, shrink: 1, gap: 1 }}>
        <Text style={{ fontSize: 13, fontWeight: "semibold", color: "#ffffff" }}>
          {current.title}
        </Text>
        {current.subtitle ? (
          <Text style={{ fontSize: 11, color: theme.muted }}>{current.subtitle}</Text>
        ) : null}
      </Box>
      <Image symbol="checkmark.circle.fill" size={16} color="#a6e3a1" />
    </Box>
  );
}
