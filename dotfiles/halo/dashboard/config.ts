import type { DashboardConfig } from "@/dashboard/types";

export default {
  searchPaths: [
    "/Applications",
    "/System/Applications",
    "~/Applications",
    "/System/Library/CoreServices/Finder.app",
  ],

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
} satisfies Pick<DashboardConfig, "searchPaths" | "exclude" | "pinned" | "aliases">;
