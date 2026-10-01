/**
 * Editable replacement for Pi's built-in footer with proper-base's layout and
 * colors. Change FOOTER_SECTIONS or FIELD_COLORS below, then run /reload.
 *
 * This is deliberately a custom footer rather than a patch to proper-base, so
 * package upgrades will not overwrite local changes. proper-base ignores custom
 * replacement footers.
 */

import { basename, sep } from "node:path";

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const FOOTER_SECTIONS = {
  cwd: true,
  gitBranch: true,
  sessionName: true,
  inputTokens: false,
  outputTokens: false,
  cacheRead: false,
  cacheWrite: false,
  cacheHitRate: false,
  cost: true,
  context: true,
  provider: true,
  model: true,
  thinking: true,
  extensionStatuses: false,
} as const;

const FIELD_COLORS = {
  path: [137, 152, 163],
  branch: [134, 165, 128],
  input: [111, 159, 190],
  output: [126, 174, 132],
  cacheRead: [153, 143, 196],
  cacheWrite: [194, 143, 114],
  cacheHit: [115, 176, 160],
  cost: [202, 165, 103],
  context: [181, 143, 168],
  contextWarning: [213, 160, 84],
  contextDanger: [218, 122, 122],
  model: [192, 132, 252],
} as const;

const RAINBOW = [
  [255, 95, 175],
  [255, 215, 95],
  [95, 215, 255],
  [175, 135, 255],
  [95, 215, 135],
] as const;

const ANIMATION_INTERVAL_MS = 120;
const HIGHLIGHT_CYCLE_MS = 4000;

type Theme = ExtensionContext["ui"]["theme"];
type UsageLike = {
  input?: number;
  output?: number;
  cacheRead?: number;
  cacheWrite?: number;
  cost?: { total?: number };
};

type UsageTotals = {
  input: number;
  output: number;
  cacheRead: number;
  cacheWrite: number;
  cost: number;
};

function formatTokens(count: number): string {
  if (count < 1_000) return count.toString();
  if (count < 10_000) return `${(count / 1_000).toFixed(1)}k`;
  if (count < 1_000_000) return `${Math.round(count / 1_000)}k`;
  if (count < 10_000_000) return `${(count / 1_000_000).toFixed(1)}M`;
  return `${Math.round(count / 1_000_000)}M`;
}

function formatCwd(cwd: string): string {
  return basename(cwd) || sep;
}

function addUsage(totals: UsageTotals, usage: UsageLike | undefined): void {
  if (!usage) return;
  totals.input += usage.input ?? 0;
  totals.output += usage.output ?? 0;
  totals.cacheRead += usage.cacheRead ?? 0;
  totals.cacheWrite += usage.cacheWrite ?? 0;
  totals.cost += usage.cost?.total ?? 0;
}

function collectUsage(ctx: ExtensionContext): {
  totals: UsageTotals;
  latestCacheHitRate: number | undefined;
} {
  const totals: UsageTotals = {
    input: 0,
    output: 0,
    cacheRead: 0,
    cacheWrite: 0,
    cost: 0,
  };
  let latestCacheHitRate: number | undefined;

  for (const entry of ctx.sessionManager.getEntries()) {
    if (entry.type === "message" && entry.message.role === "assistant") {
      const usage = entry.message.usage as UsageLike;
      addUsage(totals, usage);
      const promptTokens = (usage.input ?? 0) + (usage.cacheRead ?? 0) + (usage.cacheWrite ?? 0);
      latestCacheHitRate =
        promptTokens > 0 ? ((usage.cacheRead ?? 0) / promptTokens) * 100 : undefined;
    } else if (entry.type === "message" && entry.message.role === "toolResult") {
      addUsage(totals, entry.message.usage as UsageLike | undefined);
    } else if (entry.type === "branch_summary" || entry.type === "compaction") {
      addUsage(totals, entry.usage as UsageLike | undefined);
    }
  }

  return { totals, latestCacheHitRate };
}

function rgb(color: readonly [number, number, number], text: string): string {
  return `\x1b[38;2;${color.join(";")}m${text}\x1b[39m`;
}

function paint(text: string, color: readonly [number, number, number], theme: Theme): string {
  return `${rgb(color, text)}${theme.getFgAnsi("dim")}`;
}

function rainbowHighlight(text: string, now: number): string {
  const characters = [...text];
  const travel = characters.length + 4;
  const highlight = ((now % HIGHLIGHT_CYCLE_MS) / HIGHLIGHT_CYCLE_MS) * travel - 2;
  return characters
    .map((character, index) => {
      const base = RAINBOW[index % RAINBOW.length] ?? RAINBOW[0];
      const strength = Math.max(0, 1 - Math.abs(index - highlight) / 1.15);
      const color = base.map((channel) =>
        Math.round(channel + (255 - channel) * strength * 0.9),
      ) as unknown as readonly [number, number, number];
      return `${strength > 0.6 ? "\x1b[1m" : ""}${rgb(color, character)}${
        strength > 0.6 ? "\x1b[22m" : ""
      }`;
    })
    .join("");
}

function contextColor(percent: number | null) {
  if (percent !== null && percent > 90) return FIELD_COLORS.contextDanger;
  if (percent !== null && percent > 70) return FIELD_COLORS.contextWarning;
  return FIELD_COLORS.context;
}

function sanitizeStatus(text: string): string {
  return text
    .replace(/[\r\n\t]/g, " ")
    .replace(/ +/g, " ")
    .trim();
}

function joinSections(sections: string[], theme: Theme): string {
  return sections.filter(Boolean).join(` ${theme.fg("dim", "•")} `);
}

function rightAlignedLine(left: string, right: string, width: number, theme: Theme): string {
  if (!right) return truncateToWidth(left, width, theme.fg("dim", "..."));
  if (!left) return truncateToWidth(right, width, theme.fg("dim", "..."));

  const availableLeft = Math.max(0, width - visibleWidth(right) - 2);
  const fittedLeft = truncateToWidth(left, availableLeft, theme.fg("dim", "..."));
  const remaining = width - visibleWidth(fittedLeft) - 2;
  if (remaining < 1) return truncateToWidth(left, width, theme.fg("dim", "..."));
  const fittedRight = truncateToWidth(right, remaining, "");
  const padding = " ".repeat(
    Math.max(2, width - visibleWidth(fittedLeft) - visibleWidth(fittedRight)),
  );
  return truncateToWidth(`${fittedLeft}${padding}${fittedRight}`, width, theme.fg("dim", "..."));
}

export default function customFooter(pi: ExtensionAPI): void {
  pi.on("session_start", (_event, ctx) => {
    ctx.ui.setFooter((tui, theme, footerData) => {
      let timer: ReturnType<typeof setInterval> | undefined;
      const unsubscribeBranch = footerData.onBranchChange(() => tui.requestRender());

      const updateAnimation = () => {
        const animated =
          FOOTER_SECTIONS.thinking &&
          (ctx.thinkingLevel === "max" || (ctx.thinkingLevel as string | undefined) === "ultra");
        if (animated && !timer) {
          timer = setInterval(() => tui.requestRender(), ANIMATION_INTERVAL_MS);
          timer.unref?.();
        } else if (!animated && timer) {
          clearInterval(timer);
          timer = undefined;
        }
      };

      return {
        invalidate() {},
        dispose() {
          unsubscribeBranch();
          if (timer) clearInterval(timer);
        },
        render(width: number): string[] {
          updateAnimation();
          const { totals, latestCacheHitRate } = collectUsage(ctx);
          const lines: string[] = [];

          const pathParts: string[] = [];
          if (FOOTER_SECTIONS.cwd) {
            const cwd = formatCwd(ctx.sessionManager.getCwd());
            pathParts.push(paint(cwd, FIELD_COLORS.path, theme));
          }
          const branch = footerData.getGitBranch();
          const sessionName = pi.getSessionName?.();
          if (FOOTER_SECTIONS.sessionName && sessionName) {
            pathParts.push(sessionName);
          }

          const usage: string[] = [];
          if (FOOTER_SECTIONS.inputTokens && totals.input) {
            usage.push(paint(`↑${formatTokens(totals.input)}`, FIELD_COLORS.input, theme));
          }
          if (FOOTER_SECTIONS.outputTokens && totals.output) {
            usage.push(paint(`↓${formatTokens(totals.output)}`, FIELD_COLORS.output, theme));
          }
          if (FOOTER_SECTIONS.cacheRead && totals.cacheRead) {
            usage.push(paint(`R${formatTokens(totals.cacheRead)}`, FIELD_COLORS.cacheRead, theme));
          }
          if (FOOTER_SECTIONS.cacheWrite && totals.cacheWrite) {
            usage.push(
              paint(`W${formatTokens(totals.cacheWrite)}`, FIELD_COLORS.cacheWrite, theme),
            );
          }
          if (
            FOOTER_SECTIONS.cacheHitRate &&
            (totals.cacheRead || totals.cacheWrite) &&
            latestCacheHitRate !== undefined
          ) {
            usage.push(paint(`CH${latestCacheHitRate.toFixed(1)}%`, FIELD_COLORS.cacheHit, theme));
          }
          const subscription =
            ctx.model?.provider === "openai-codex" ||
            ctx.model?.provider === "github-copilot" ||
            ctx.model?.provider === "kimi-coding";
          let cost = "";
          if (FOOTER_SECTIONS.cost && (totals.cost || subscription)) {
            cost = paint(
              `$${totals.cost.toFixed(3)}${subscription ? " (sub)" : ""}`,
              FIELD_COLORS.cost,
              theme,
            );
          }

          const topRight = [...usage];
          if (FOOTER_SECTIONS.gitBranch && branch) {
            const shortBranch = truncateToWidth(branch, 20, "...");
            topRight.push(paint(`git: ${shortBranch}`, FIELD_COLORS.branch, theme));
          }
          const top = rightAlignedLine(
            joinSections(pathParts, theme),
            joinSections(topRight, theme),
            width,
            theme,
          );
          if (top) lines.push(theme.fg("dim", top));

          const contextUsage = ctx.getContextUsage();
          let context = "";
          if (FOOTER_SECTIONS.context) {
            const contextWindow = contextUsage?.contextWindow ?? ctx.model?.contextWindow ?? 0;
            const percent = contextUsage?.percent ?? null;
            const label = `${
              percent === null ? "?" : `${percent.toFixed(1)}%`
            }/${formatTokens(contextWindow)}`;
            context = paint(label, contextColor(percent), theme);
          }

          const modelParts: string[] = [];
          if (FOOTER_SECTIONS.provider && footerData.getAvailableProviderCount() > 1 && ctx.model) {
            modelParts.push(`${ctx.model.provider}`);
          }
          if (FOOTER_SECTIONS.model) {
            modelParts.push(paint(ctx.model?.id ?? "no-model", FIELD_COLORS.model, theme));
          }
          if (FOOTER_SECTIONS.thinking && ctx.model?.reasoning) {
            const level = ctx.thinkingLevel ?? "off";
            const label = level === "off" ? "thinking off" : level;
            const colored =
              level === "max" || (level as string) === "ultra"
                ? rainbowHighlight(label, Date.now())
                : theme.getThinkingBorderColor(level)(label);
            modelParts.push(colored);
          }

          const middleRight = joinSections([context, cost], theme);
          const bottom = rightAlignedLine(
            joinSections(modelParts, theme),
            middleRight,
            width,
            theme,
          );
          if (bottom) lines.push(theme.fg("dim", bottom));

          if (FOOTER_SECTIONS.extensionStatuses) {
            const statuses = [...footerData.getExtensionStatuses().entries()]
              .sort(([a], [b]) => a.localeCompare(b))
              .map(([, text]) => sanitizeStatus(text));
            if (statuses.length) {
              lines.push(
                truncateToWidth(joinSections(statuses, theme), width, theme.fg("dim", "...")),
              );
            }
          }

          return lines;
        },
      };
    });
  });
}
