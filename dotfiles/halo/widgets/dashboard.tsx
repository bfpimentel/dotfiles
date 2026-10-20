import { defineWidget } from "halo";
import config from "@/dashboard/config";
import { Dashboard } from "@/dashboard/Dashboard";

export default defineWidget({
  props: {
    depth: {
      type: "number",
      default: 3,
      min: 1,
      max: 10,
      label: "Search depth",
    },
    maxResults: {
      type: "number",
      default: 8,
      min: 1,
      max: 30,
      label: "Max results",
    },
    calculator: { type: "boolean", default: true, label: "Calculator" },
    overview: { type: "boolean", default: true, label: "Overview" },
    workspaces: {
      type: "boolean",
      default: true,
      label: "Overview workspaces",
    },
    overviewRows: {
      type: "number",
      default: 5,
      min: 1,
      max: 30,
      label: "Overview rows",
    },
  },
  render: ({ screen, props }) => (
    <Dashboard
      screen={screen}
      config={{
        ...config,
        depth: props.depth,
        maxResults: props.maxResults,
        calculator: props.calculator,
        overview: {
          enabled: props.overview,
          workspaces: props.workspaces,
          rows: props.overviewRows,
        },
      }}
    />
  ),
});
