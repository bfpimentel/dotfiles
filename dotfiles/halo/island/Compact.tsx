import { Box, Image, Text } from "halo";
import { battery, clock } from "halo/services";
import { caffeinated } from "@/dashboard/caffeinate";
import type { AeroSpace } from "@/dashboard/aerospace";
import { shelf } from "@/shelf/store";
import { theme } from "@/ui/theme";

const time = clock.format("HH:mm");

function elapsed(since: number) {
  time();
  const minutes = Math.floor((Date.now() - since) / 60_000);
  return minutes < 60 ? `${minutes}m` : `${Math.floor(minutes / 60)}h ${minutes % 60}m`;
}

function Indicator(props: { symbol: string; label: () => string }) {
  return (
    <Box
      style={{ flexDirection: "row", align: "center", gap: 4 }}
      enter={{
        from: { opacity: 0, scale: 0.6 },
        duration: 220,
        curve: [0.2, 0.9, 0.3, 1],
      }}
    >
      <Image symbol={props.symbol} size={12} color={theme.foreground} />
      <Text style={{ fontSize: 11, fontWeight: "semibold", color: theme.foreground }}>
        {props.label}
      </Text>
    </Box>
  );
}

export function Compact(props: { spaces: AeroSpace }) {
  return (
    <Box
      style={{
        flexDirection: "row",
        align: "center",
        gap: 10,
        height: 34,
        padding: [0, 16],
      }}
    >
      <Text style={{ fontSize: 13, fontWeight: "bold", color: theme.foreground }}>
        {time}
      </Text>
      {() => {
        const focused = props.spaces.focused();
        return focused ? (
          <Box
            style={{
              height: 18,
              padding: [0, 6],
              radius: 5,
              justify: "center",
              background: theme.foreground,
            }}
          >
            <Text style={{ fontSize: 10, fontWeight: 800, color: "#000000" }}>
              {focused}
            </Text>
          </Box>
        ) : null;
      }}
      <Box style={{ grow: 1 }} />
      {() => {
        const since = caffeinated();
        return since === undefined ? null : (
          <Indicator symbol="cup.and.saucer.fill" label={() => elapsed(since)} />
        );
      }}
      {() =>
        shelf.files().length ? (
          <Indicator symbol="tray.full.fill" label={() => String(shelf.files().length)} />
        ) : null
      }
      {() =>
        battery.present() ? (
          <Indicator
            symbol={battery.source() === "battery" ? "battery.75" : "bolt.fill"}
            label={() => `${battery.percent() ?? "–"}%`}
          />
        ) : null
      }
    </Box>
  );
}
