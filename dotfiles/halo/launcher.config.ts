import type { LauncherConfig } from "@/launcher/types";

// Edit and save: halo hot-reloads. Toggle the launcher with `halo toggle launcher` (alt-space in AeroSpace).
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

  dashboard: {
    enabled: true,
    workspaces: true,
    rows: 5,
  },

  theme: {
    accent: "#89b4fa",
    background: "#181825f2",
    foreground: "#cdd6f4",
    muted: "#7f849c",
  },
} satisfies LauncherConfig;
