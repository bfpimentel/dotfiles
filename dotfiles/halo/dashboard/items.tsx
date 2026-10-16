import { Box, Image, type Element, type Reactive } from "halo";
import type { Accessor } from "halo/signals";
import type { DashboardConfig } from "@/dashboard/types";

export type Theme = DashboardConfig["theme"];

export interface Item {
  id: string;
  title: string;
  subtitle: Reactive<string>;
  icon(selected: Accessor<boolean>): Element;
  badge?(): Element | null;
  run(): void;
  searchable?: boolean;
}

export const alpha = (hex: string, amount: number) =>
  hex.slice(0, 7) +
  Math.round(amount * 255)
    .toString(16)
    .padStart(2, "0");

export function SymbolIcon(symbol: string, theme: Theme) {
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
