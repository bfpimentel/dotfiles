import type { DashboardConfig } from "@/dashboard/types";

// Edit and save: halo hot-reloads. Toggle the dashboard with `halo toggle dashboard` (alt-space in AeroSpace).
export default {
  // A bundle path adds just that app: Finder lives among system agents in CoreServices.
  searchPaths: [
    "/Applications",
    "/System/Applications",
    "~/Applications",
    "/System/Library/CoreServices/Finder.app",
  ],
  depth: 3,

  exclude: [
    "Claude Code URL Handler",
    "Feedback Assistant",
    "Steam Support Center",
    "*Uninstall*",
    /^Xcode-.*Beta/,
    // A path rule (contains `/`) hides a whole folder, e.g. every CrossOver game:
    // "~/Applications/CrossOver/*",
  ],

  pinned: ["Ghostty", "Helium", "Claude"],

  aliases: {
    term: "Ghostty",
    browser: "Helium",
    web: "Helium",
    ai: "Claude",
    games: "Steam",
  },

  maxResults: 8,
  calculator: true,

  overview: {
    enabled: true,
    workspaces: true,
    rows: 5,
  },

  theme: {
    accent: "#d6d6d6",
    background: "#141414f2",
    foreground: "#e8e8e8",
    muted: "#6b6b6b",
  },
} satisfies DashboardConfig;
