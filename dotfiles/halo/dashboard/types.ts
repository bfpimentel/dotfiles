/// An exclusion rule. Strings match the app name, case-insensitively; `*` is a wildcard, and a rule containing
/// `/` matches the full path instead. Regexes are tested against both the name and the path.
export type Rule = string | RegExp;

export interface DashboardConfig {
  /// Folders to scan for `.app` bundles. `~` is your home folder. Symlinks are followed.
  searchPaths: string[];
  /// How many folder levels to descend into (1 = only the folders themselves).
  depth: number;
  /// Apps to leave out.
  exclude: Rule[];
  /// Shown first, in this order, when the search is empty (by app name).
  pinned: string[];
  /// Typing an alias (or its prefix) ranks the app first: `{ term: "Ghostty" }`.
  aliases: Record<string, string>;
  /// Rows shown at once.
  maxResults: number;
  /// Evaluate math like `12*3+4` and copy the result with Enter.
  calculator: boolean;
  /// A strip with the time, date and AeroSpace workspaces above the pinned/recent list while the search is empty.
  overview: {
    enabled: boolean;
    /// Workspace chips with the apps open in each (click one to switch).
    workspaces: boolean;
    /// Pinned/recent rows under the strip.
    rows: number;
  };
  theme: {
    accent: string;
    background: string;
    foreground: string;
    muted: string;
  };
}
