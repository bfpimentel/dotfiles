import { defineWidget } from "halo";
import { getOwner, runWithOwner } from "halo/signals";
import { clipboardPalette } from "@/clipboard/Clipboard";
import { clipboardHistory, type ClipboardHistory } from "@/clipboard/history";
import { aerospace } from "@/dashboard/aerospace";
import config from "@/dashboard/config";
import { launcher } from "@/dashboard/Dashboard";
import { Island } from "@/island/Island";

// Shared by every screen and owned by the module, so they outlive display changes.
const owner = getOwner();
const spaces = aerospace();
let history: ClipboardHistory | undefined;

export default defineWidget({
  props: {
    depth: { type: "number", default: 3, min: 1, max: 10, label: "Search depth" },
    maxResults: { type: "number", default: 8, min: 1, max: 30, label: "Max results" },
    calculator: { type: "boolean", default: true, label: "Calculator" },
    overview: { type: "boolean", default: true, label: "Overview" },
    workspaces: { type: "boolean", default: true, label: "Overview workspaces" },
    overviewRows: { type: "number", default: 5, min: 1, max: 30, label: "Overview rows" },
    clipboardInterval: {
      type: "number",
      default: 1000,
      min: 100,
      step: 100,
      label: "Clipboard poll interval (ms)",
    },
    clipboardSize: {
      type: "number",
      default: 50,
      min: 1,
      max: 500,
      label: "Clipboard history size",
    },
    clipboardRows: {
      type: "number",
      default: 10,
      min: 1,
      max: 30,
      label: "Clipboard rows",
    },
  },
  render: ({ screen, props }) => {
    history ??= runWithOwner(owner, () =>
      clipboardHistory({ intervalMs: props.clipboardInterval, max: props.clipboardSize }),
    );
    const dashboard = launcher(
      {
        ...config,
        depth: props.depth,
        maxResults: props.maxResults,
        calculator: props.calculator,
        overview: {
          enabled: props.overview,
          workspaces: props.workspaces,
          rows: props.overviewRows,
        },
      },
      spaces,
    );
    return (
      <Island
        screen={screen}
        spaces={spaces}
        launcher={dashboard}
        clipboard={clipboardPalette(history, props.clipboardRows)}
      />
    );
  },
});
