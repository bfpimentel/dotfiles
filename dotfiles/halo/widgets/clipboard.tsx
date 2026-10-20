import { defineWidget } from "halo";
import { getOwner, runWithOwner } from "halo/signals";
import { Clipboard } from "@/clipboard/Clipboard";
import { clipboardHistory, type ClipboardHistory } from "@/clipboard/history";

// One history shared by every screen, owned by the module so it outlives display changes.
const owner = getOwner();
let history: ClipboardHistory | undefined;

export default defineWidget({
  props: {
    intervalMs: {
      type: "number",
      default: 1000,
      min: 100,
      step: 100,
      label: "Poll interval (ms)",
    },
    max: {
      type: "number",
      default: 50,
      min: 1,
      max: 500,
      label: "History size",
    },
    rows: {
      type: "number",
      default: 10,
      min: 1,
      max: 30,
      label: "Visible rows",
    },
  },
  render: ({ screen, props }) => {
    history ??= runWithOwner(owner, () =>
      clipboardHistory({ intervalMs: props.intervalMs, max: props.max }),
    );
    return <Clipboard screen={screen} rows={props.rows} history={history} />;
  },
});
