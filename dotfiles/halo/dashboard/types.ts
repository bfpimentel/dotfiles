/// An exclusion rule. Strings match the app name, case-insensitively; `*` is a wildcard, and a rule containing
/// `/` matches the full path instead. Regexes are tested against both the name and the path.
export type Rule = string | RegExp;

export interface DashboardConfig {
  searchPaths: string[];
  depth: number;
  exclude: Rule[];
  pinned: string[];
  aliases: Record<string, string>;
  maxResults: number;
  calculator: boolean;
  overview: {
    enabled: boolean;
    workspaces: boolean;
    rows: number;
  };
  clipboard: {
    intervalMs: number;
    max: number;
    rows: number;
  };
}
