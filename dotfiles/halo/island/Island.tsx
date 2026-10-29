import { Box, Surface, type ScreenInfo } from "halo";
import { drag } from "halo/services";
import { effect, signal, untrack } from "halo/signals";
import type { AeroSpace } from "@/dashboard/aerospace";
import { Body, geometry, reveal as content, type Geometry } from "@/island/Body";
import { Compact } from "@/island/Compact";
import { Dashboard } from "@/island/Dashboard";
import { DropZone } from "@/island/DropZone";
import { Shelf, shelfWidth } from "@/island/Shelf";
import {
  closeDashboard,
  conceal,
  idle,
  mode,
  notify,
  openDashboard,
  reveal,
  setResting,
  stayOpen,
} from "@/island/state";
import { Toast } from "@/island/Toast";
import { shelf } from "@/shelf/store";
import type { PaletteConfig } from "@/ui/palette/Palette";

// Room for the dashboard at its tallest, plus the body's shadow.
const width = 760;
const height = 820;
const plural = (count: number) => (count === 1 ? "1 file" : `${count} files`);
const name = (path: string) => path.split("/").filter(Boolean).pop() ?? path;

export function Island(props: {
  screen: ScreenInfo;
  spaces: AeroSpace;
  launcher: PaletteConfig;
  clipboard: PaletteConfig;
}) {
  const over = signal(false);
  const incoming = signal(0);

  effect(() => {
    const dropping = drag.active() && !drag.outgoing();
    const current = untrack(mode);
    if (dropping && current !== "drop" && current !== "toast") setResting("drop");
    if (!dropping && current === "drop") setResting(idle());
  });

  effect(() => {
    const target = shelf.files().length ? "shelf" : "hidden";
    const current = untrack(mode);
    if ((current === "hidden" || current === "shelf") && current !== target)
      setResting(target);
  });

  const shape = (): Geometry => {
    const current = mode();
    return current === "shelf"
      ? { ...geometry.shelf, width: shelfWidth(shelf.files().length) }
      : geometry[current];
  };

  // Files dragged out of the shelf with a move vanish from disk a moment after the drop.
  let leaving = false;
  effect(() => {
    if (drag.active() && drag.outgoing()) leaving = true;
    else if (!drag.active() && leaving) {
      leaving = false;
      setTimeout(shelf.prune, 400);
      setTimeout(shelf.prune, 1500);
    }
  });

  return (
    <Surface
      name="island"
      screen={props.screen}
      anchor={["top"]}
      size={{ width, height }}
      layer="overlay"
      input={() => {
        const current = mode();
        return current === "hidden"
          ? "hover"
          : current === "dashboard"
            ? "keyboard"
            : "interactive";
      }}
      onKeyDown={(event) => {
        if (event.key !== "Escape") return false;
        closeDashboard();
        return true;
      }}
      onBlur={() => closeDashboard()}
      onClickOutside={() => closeDashboard()}
    >
      <Box style={{ width, height, align: "center" }}>
        {() =>
          mode() === "hidden" ? (
            <Box
              onHover={(hovered) => hovered && reveal()}
              style={{
                position: "absolute",
                top: 0,
                left: (width - 360) / 2,
                width: 360,
                height: 3,
              }}
            />
          ) : null
        }
        <Body
          geometry={shape}
          onHover={(hovered) => {
            if (hovered) stayOpen();
            else if (untrack(mode) === "compact") conceal();
          }}
          onClick={() => {
            const current = untrack(mode);
            if (current !== "drop" && current !== "dashboard") openDashboard();
          }}
          onDragEnter={({ files }) => {
            incoming.set(files.length);
            over.set(true);
          }}
          onDragLeave={() => over.set(false)}
          onDrop={({ files }) => {
            over.set(false);
            shelf.add(files);
            notify({
              title:
                files.length === 1
                  ? name(files[0] ?? "")
                  : `${plural(files.length)} shelved`,
              subtitle: `On the shelf · ${plural(shelf.files().length)}`,
              app: files.length === 1 ? files[0] : undefined,
              symbol: "tray.full.fill",
            });
          }}
        >
          {() => {
            const current = mode();
            if (current === "dashboard")
              return <Dashboard launcher={props.launcher} clipboard={props.clipboard} />;
            const view =
              current === "compact" ? (
                <Compact spaces={props.spaces} />
              ) : current === "toast" ? (
                <Toast />
              ) : current === "shelf" ? (
                <Shelf />
              ) : current === "drop" ? (
                <DropZone over={over} incoming={incoming} />
              ) : null;
            return view ? (
              <Box style={{ width: "100%" }} enter={content.enter} exit={content.exit}>
                {view}
              </Box>
            ) : null;
          }}
        </Body>
      </Box>
    </Surface>
  );
}
