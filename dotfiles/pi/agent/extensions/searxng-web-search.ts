import {
  truncateHead,
  type AgentToolResult,
  type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

const SEARXNG_BASE_URL = "https://search.local.jalotopimentel.com";
const SEARCH_TIMEOUT_MS = 15_000;
const MAX_OUTPUT_BYTES = 16_000;

function shorten(text: string, maxLength: number): string {
  return text.length > maxLength ? `${text.slice(0, maxLength)}…` : text;
}

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "web_search",
    label: "Web Search",
    description: "Search the web using the configured SearXNG instance.",
    annotations: { readOnlyHint: true, openWorldHint: true },
    promptSnippet: "Search the web using SearXNG and return relevant results with URLs.",
    promptGuidelines: [
      "Use web_search when current or external information is needed, and cite URLs from the results.",
      "Prefer web_search over ad-hoc shell commands for web searches.",
    ],
    parameters: Type.Object({
      query: Type.String({ description: "Search query" }),
      limit: Type.Optional(
        Type.Number({
          description: "Maximum number of results to return (default 8, max 20)",
        }),
      ),
      language: Type.Optional(
        Type.String({ description: "SearXNG language code, e.g. 'en', 'all'" }),
      ),
      categories: Type.Optional(
        Type.String({
          description: "SearXNG categories, e.g. 'general', 'it', 'science'",
        }),
      ),
      time_range: Type.Optional(
        Type.String({
          description: "Optional time range: day, week, month, year",
        }),
      ),
    }),
    async execute(_toolCallId, params, signal): Promise<AgentToolResult<unknown>> {
      const limit = Math.min(Math.max(Math.floor(params.limit ?? 8), 1), 20);
      const url = new URL("/search", SEARXNG_BASE_URL);
      url.searchParams.set("q", params.query);
      url.searchParams.set("format", "json");
      if (params.language) url.searchParams.set("language", params.language);
      if (params.categories) url.searchParams.set("categories", params.categories);
      if (params.time_range) url.searchParams.set("time_range", params.time_range);

      const response = await fetch(url, {
        headers: { Accept: "application/json" },
        signal: signal
          ? AbortSignal.any([signal, AbortSignal.timeout(SEARCH_TIMEOUT_MS)])
          : AbortSignal.timeout(SEARCH_TIMEOUT_MS),
      });

      if (!response.ok) {
        const body = await response.text().catch(() => "");
        return {
          isError: true,
          content: [
            {
              type: "text",
              text: `SearXNG search failed: HTTP ${response.status}${body ? `\n${body.slice(0, 1000)}` : ""}`,
            },
          ],
          details: { status: response.status, url: url.toString() },
        };
      }

      const data = (await response.json()) as {
        results?: Array<{
          title?: string;
          url?: string;
          content?: string;
          engine?: string;
          score?: number;
          publishedDate?: string;
        }>;
        answers?: string[];
        suggestions?: string[];
        infoboxes?: unknown[];
      };

      if (!Array.isArray(data?.results)) {
        throw new Error("SearXNG returned an invalid search response (missing results)");
      }
      const results = data.results.slice(0, limit).map((result, index) => ({
        rank: index + 1,
        title: shorten(typeof result?.title === "string" ? result.title : "Untitled", 300),
        url: shorten(typeof result?.url === "string" ? result.url : "", 2000),
        snippet: shorten(typeof result?.content === "string" ? result.content : "", 800),
        engine: result?.engine,
        score: result?.score,
        publishedDate: result?.publishedDate,
      }));
      const answerItems = Array.isArray(data.answers)
        ? data.answers
            .filter((item): item is string => typeof item === "string")
            .slice(0, 3)
            .map((item) => shorten(item, 500))
        : [];
      const suggestionItems = Array.isArray(data.suggestions)
        ? data.suggestions
            .filter((item): item is string => typeof item === "string")
            .slice(0, 5)
            .map((item) => shorten(item, 200))
        : [];

      const lines =
        results.length > 0
          ? results
              .map((result) =>
                [
                  `${result.rank}. ${result.title}`,
                  `   ${result.url}`,
                  result.snippet ? `   ${result.snippet}` : undefined,
                ]
                  .filter(Boolean)
                  .join("\n"),
              )
              .join("\n\n")
          : "No results found.";

      const answers = answerItems.length ? `\n\nAnswers:\n${answerItems.join("\n")}` : "";
      const suggestions = suggestionItems.length
        ? `\n\nSuggestions: ${suggestionItems.join(", ")}`
        : "";
      const output = truncateHead(`${lines}${answers}${suggestions}`, {
        maxBytes: MAX_OUTPUT_BYTES,
        maxLines: 120,
      });

      return {
        content: [
          {
            type: "text",
            text: output.content + (output.truncated ? "\n[Search output truncated.]" : ""),
          },
        ],
        details: {
          provider: "searxng",
          baseUrl: SEARXNG_BASE_URL,
          query: params.query,
          results,
          answers: answerItems,
          suggestions: suggestionItems,
        },
      };
    },
  });
}
