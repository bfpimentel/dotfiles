import { Box, For, Surface, Text, hide, show, type ScreenInfo } from "halo";
import { computed, signal, type Accessor } from "halo/signals";
import type { Clip, clipboardHistory } from "@/dashboard/clipHistory";
import { alpha } from "@/dashboard/items";
import type { DashboardConfig } from "@/dashboard/types";

type History = ReturnType<typeof clipboardHistory>;

function age(time: number) {
  const minutes = Math.floor((Date.now() - time) / 60_000);
  if (minutes < 1) return "now";
  if (minutes < 60) return `${minutes}m`;
  const hours = Math.floor(minutes / 60);
  return hours < 24 ? `${hours}h` : `${Math.floor(hours / 24)}d`;
}

export function Clipboard(props: {
  screen: ScreenInfo;
  config: DashboardConfig;
  history: History;
}) {
  const { theme } = props.config;
  const { history } = props;
  const selected = signal(0);
  const shown = computed(() => history.clips().slice(0, props.config.clipboard.rows));

  const move = (by: number) => {
    const count = shown().length;
    if (count) selected.set((selected() + by + count) % count);
  };

  const pick = (clip: Clip | undefined) => {
    if (!clip) return;
    history.copy(clip.text);
    hide("clipboard");
  };

  function Row(clip: Accessor<Clip>, index: Accessor<number>) {
    const hovered = signal(false);
    const active = () => selected() === index();
    return (
      <Box
        onClick={() => pick(clip())}
        onHover={(value) => {
          hovered.set(value);
          if (value) selected.set(index());
        }}
        style={{
          flexDirection: "row",
          align: "center",
          gap: 12,
          height: 36,
          padding: [0, 12],
          radius: 5,
          background: () => alpha(theme.accent, active() ? 0.16 : hovered() ? 0.08 : 0),
          transition: { background: 100 },
        }}
      >
        <Text style={{ grow: 1, shrink: 1, fontSize: 13, color: theme.foreground }}>
          {clip().text.replace(/\s+/g, " ").trim()}
        </Text>
        <Text style={{ fontSize: 11, color: theme.muted }}>
          {() => age(clip().copiedAt)}
        </Text>
      </Box>
    );
  }

  return (
    <Surface
      name="clipboard"
      defaultHidden
      screen={props.screen}
      anchor={["top"]}
      margins={[Math.round(props.screen.frame.height * 0.18), 0, 0, 0]}
      size={{ width: 560, height: "auto" }}
      layer="overlay"
      input="keyboard"
      onFocus={() => selected.set(0)}
      onBlur={() => hide("clipboard")}
      onKeyDown={({ key }) => {
        if (key === "ArrowDown") move(1);
        else if (key === "ArrowUp") move(-1);
        else if (key === "Enter") pick(shown()[selected()]);
        else if (key === "Escape") hide("clipboard");
        else if (key === "Tab") show("dashboard");
        else if (key === "Backspace") {
          const clip = shown()[selected()];
          if (clip) history.remove(clip.text);
          selected.set(Math.max(0, Math.min(selected(), shown().length - 1)));
        } else return false;
        return true;
      }}
      enter={{
        from: { opacity: 0, scale: 0.95, translateY: -16 },
        curve: { stiffness: 420, damping: 30 },
      }}
      exit={{
        to: { opacity: 0, scale: 0.97, translateY: -8 },
        duration: 120,
        curve: "ease-in",
      }}
    >
      <Box
        style={{
          padding: 8,
          gap: 4,
          background: theme.background,
          radius: 9,
          borderWidth: 1,
          borderColor: "#ffffff12",
        }}
      >
        <Box style={{ flexDirection: "row", align: "center", padding: [6, 12, 4, 12] }}>
          <Text style={{ grow: 1, fontSize: 10, fontWeight: "bold", color: theme.muted }}>
            CLIPBOARD
          </Text>
          <Text style={{ fontSize: 11, color: theme.muted }}>
            {() =>
              `${history.clips().length} items · ↵ copy · ⌫ remove · ⇥ dashboard · esc close`
            }
          </Text>
        </Box>
        <For each={shown} key={(clip) => clip.text}>
          {Row}
        </For>
        {() =>
          shown().length ? null : (
            <Box style={{ padding: [16, 12] }}>
              <Text style={{ fontSize: 13, color: theme.muted }}>
                Nothing copied yet.
              </Text>
            </Box>
          )
        }
      </Box>
    </Surface>
  );
}
