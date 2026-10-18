import { Box, Image } from "halo";
import { alpha, theme } from "@/ui/theme";

export function SymbolIcon(symbol: string) {
  return (
    <Box
      style={{
        width: 32,
        height: 32,
        radius: 4,
        background: alpha(theme.accent, 0.18),
        justify: "center",
        align: "center",
      }}
    >
      <Image symbol={symbol} size={15} color={theme.accent} />
    </Box>
  );
}
