import { readFile, rename, unlink, writeFile } from "node:fs/promises";
import { join } from "node:path";
import { compact, getAgentDir, type ExtensionAPI } from "@earendil-works/pi-coding-agent";

const configPath = join(getAgentDir(), "compaction-model.json");
type Choice = { provider: string; model: string };

async function readChoice(): Promise<Choice | undefined> {
  try {
    const value: unknown = JSON.parse(await readFile(configPath, "utf8"));
    if (
      value &&
      typeof value === "object" &&
      "provider" in value &&
      typeof value.provider === "string" &&
      "model" in value &&
      typeof value.model === "string"
    ) {
      return { provider: value.provider, model: value.model };
    }
    throw new Error("Expected { provider, model }");
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === "ENOENT") return undefined;
    throw error;
  }
}

async function saveChoice(choice: Choice | undefined): Promise<void> {
  if (!choice) {
    await unlink(configPath).catch((error: NodeJS.ErrnoException) => {
      if (error.code !== "ENOENT") throw error;
    });
    return;
  }
  const temp = `${configPath}.${process.pid}.tmp`;
  try {
    await writeFile(temp, JSON.stringify(choice, null, 2) + "\n", { mode: 0o600 });
    await rename(temp, configPath);
  } catch (error) {
    await unlink(temp).catch(() => {});
    throw error;
  }
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("compaction-model", {
    description: "Choose the model used for context compaction",
    handler: async (_args, ctx) => {
      if (!ctx.hasUI) {
        ctx.ui.notify("/compaction-model requires an interactive UI", "warning");
        return;
      }
      try {
        const current = await readChoice();
        const available = ctx.modelRegistry
          .getAvailable()
          .filter((model) => model.type === undefined || model.type === "chat");
        const labels = available.map((model) => `${model.provider}/${model.id}`);
        const defaultLabel = "Use conversation model (Pi default)";
        const selected = await ctx.ui.select(
          `Compaction model (current: ${current ? `${current.provider}/${current.model}` : "Pi default"})`,
          [defaultLabel, ...labels],
        );
        if (selected === undefined) return;
        const model = available[labels.indexOf(selected)];
        if (selected !== defaultLabel && !model) return;
        await saveChoice(model ? { provider: model.provider, model: model.id } : undefined);
        ctx.ui.notify(
          `Compaction model: ${model ? `${model.provider}/${model.id}` : "Pi default"}`,
          "info",
        );
      } catch (error) {
        ctx.ui.notify(`Cannot configure compaction model: ${String(error)}`, "error");
      }
    },
  });

  pi.on("session_before_compact", async (event, ctx) => {
    let choice: Choice | undefined;
    try {
      choice = await readChoice();
    } catch (error) {
      ctx.ui.notify(`Cannot read compaction model setting: ${String(error)}`, "warning");
      return;
    }
    if (!choice || event.signal.aborted) return;

    const model = ctx.modelRegistry.find(choice.provider, choice.model);
    if (!model || !ctx.modelRegistry.hasConfiguredAuth(model)) {
      ctx.ui.notify(
        `Compaction model ${choice.provider}/${choice.model} unavailable; using Pi default`,
        "warning",
      );
      return;
    }
    try {
      const fileOps = {
        read: new Set(event.preparation.fileOps.read),
        written: new Set(event.preparation.fileOps.written),
        edited: new Set(event.preparation.fileOps.edited),
      };
      const previous = [...event.branchEntries]
        .reverse()
        .find((entry) => entry.type === "compaction");
      if (
        previous?.type === "compaction" &&
        previous.fromHook &&
        previous.details &&
        typeof previous.details === "object"
      ) {
        const details = previous.details as { readFiles?: unknown; modifiedFiles?: unknown };
        if (Array.isArray(details.readFiles)) {
          for (const path of details.readFiles)
            if (typeof path === "string") fileOps.read.add(path);
        }
        if (Array.isArray(details.modifiedFiles)) {
          for (const path of details.modifiedFiles)
            if (typeof path === "string") fileOps.written.add(path);
        }
      }
      const result = await compact(
        { ...event.preparation, fileOps },
        model,
        undefined,
        undefined,
        event.customInstructions,
        event.signal,
        undefined,
        (m, context, options) => ctx.modelRegistry.streamSimple(m, context, options),
      );
      if (event.signal.aborted) return;
      return { compaction: result };
    } catch (error) {
      if (!event.signal.aborted) {
        ctx.ui.notify(
          `Compaction with ${choice.provider}/${choice.model} failed; using Pi default: ${String(error)}`,
          "warning",
        );
      }
      return;
    }
  });
}
