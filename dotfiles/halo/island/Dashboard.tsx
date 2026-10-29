import { Box, Text } from "halo";
import { untrack } from "halo/signals";
import { settle } from "@/island/Body";
import { closeDashboard, notify, tab, type Tab } from "@/island/state";
import { Palette, type PaletteConfig } from "@/ui/palette/Palette";
import { theme } from "@/ui/theme";

const tabs: { id: Tab; label: string }[] = [
  { id: "launcher", label: "Launcher" },
  { id: "clipboard", label: "Clipboard" },
];

function Tabs() {
  const pill = 78;
  return (
    <Box style={{ flexDirection: "row", padding: 3, radius: 10, background: "#141414" }}>
      <Box
        style={{
          position: "absolute",
          top: 3,
          left: 3,
          width: pill,
          height: 26,
          radius: 7,
          background: theme.foreground,
          translateX: () => (tab() === "launcher" ? 0 : pill),
          transition: { translateX: settle },
        }}
      />
      {tabs.map((entry) => {
        const active = () => tab() === entry.id;
        return (
          <Box
            onClick={() => tab.set(entry.id)}
            style={{ width: pill, height: 26, justify: "center", align: "center" }}
          >
            <Text
              style={{
                fontSize: 12,
                fontWeight: "semibold",
                color: () => (active() ? "#000000" : theme.muted),
              }}
            >
              {entry.label}
            </Text>
          </Box>
        );
      })}
    </Box>
  );
}

export function Dashboard(props: { launcher: PaletteConfig; clipboard: PaletteConfig }) {
  const other = () => (tab() === "launcher" ? "clipboard" : "launcher");
  const switchTab = {
    key: "Tab",
    label: "⇥",
    get hint() {
      return untrack(other);
    },
    run: () => tab.set(untrack(other)),
  };

  return (
    <Box style={{ width: "100%" }}>
      {() => {
        const config = tab() === "launcher" ? props.launcher : props.clipboard;
        return (
          <Box
            style={{ width: "100%" }}
            enter={{
              from: { opacity: 0, scale: 0.97, translateY: -10 },
              duration: 240,
              delay: 60,
              curve: [0.2, 0.9, 0.3, 1],
            }}
            exit={{ to: { opacity: 0, scale: 0.98 }, duration: 90, curve: "ease-in" }}
          >
            <Palette
              {...config}
              keys={[switchTab]}
              accessory={<Tabs />}
              onClose={(feedback) => (feedback ? notify(feedback) : closeDashboard())}
            />
          </Box>
        );
      }}
    </Box>
  );
}
