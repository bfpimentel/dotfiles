import type { DashboardConfig } from "@/dashboard/types";

export default {
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

  clipboard: {
    intervalMs: 1000,
    max: 50,
    rows: 10,
  },
} satisfies DashboardConfig;
