import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

const SEARXNG_BASE_URL = "https://search.local.jalotopimentel.com";

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "web_search",
    label: "Web Search",
    description: "Search the web using the configured SearXNG instance.",
    promptSnippet:
      "Search the web using SearXNG and return relevant results with URLs.",
    promptGuidelines: [
      "Use web_search when current or external information is needed, and cite URLs from the results.",
      "Prefer web_search over ad-hoc shell commands for web searches.",
    ],
    parameters: Type.Object({
      query: Type.String({ description: "Search query" }),
      limit: Type.Optional(
        Type.Number({
          description:
            "Maximum number of results to return (default 8, max 20)",
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
    async execute(_toolCallId, params, signal) {
      const limit = Math.min(Math.max(Math.floor(params.limit ?? 8), 1), 20);
      const url = new URL("/search", SEARXNG_BASE_URL);
      url.searchParams.set("q", params.query);
      url.searchParams.set("format", "json");
      if (params.language) url.searchParams.set("language", params.language);
      if (params.categories)
        url.searchParams.set("categories", params.categories);
      if (params.time_range)
        url.searchParams.set("time_range", params.time_range);

      const response = await fetch(url, {
        headers: { Accept: "application/json" },
        signal,
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

      const results = (data.results ?? [])
        .slice(0, limit)
        .map((result, index) => ({
          rank: index + 1,
          title: result.title ?? "Untitled",
          url: result.url ?? "",
          snippet: result.content ?? "",
          engine: result.engine,
          score: result.score,
          publishedDate: result.publishedDate,
        }));

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

      const answers = data.answers?.length
        ? `\n\nAnswers:\n${data.answers.join("\n")}`
        : "";
      const suggestions = data.suggestions?.length
        ? `\n\nSuggestions: ${data.suggestions.join(", ")}`
        : "";

      return {
        content: [{ type: "text", text: `${lines}${answers}${suggestions}` }],
        details: {
          provider: "searxng",
          baseUrl: SEARXNG_BASE_URL,
          query: params.query,
          results,
          answers: data.answers ?? [],
          suggestions: data.suggestions ?? [],
        },
      };
    },
  });
}
