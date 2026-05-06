#!/usr/bin/env bun

import { mkdir, readFile, readdir, rm, stat, writeFile } from "node:fs/promises";
import { basename, extname, isAbsolute, join, relative, resolve } from "node:path";

type Args = {
  session: string;
  root: string;
  ttlMs: number;
  cleanup: boolean;
  host: string;
  port: number;
};

type Prototype = {
  index: number;
  file: string;
  href: string;
};

type ServerMetadata = {
  previewUrl: string;
  shutdownUrl: string;
  refreshUrl: string;
  pid: number;
  workingDir: string;
  root: string;
  session: string;
  sessionRoot: string;
  sandbox: string;
  designContext: string;
  registry: string;
  cleanup: boolean;
  expiresAt: number;
  expiresAtIso: string;
  options: Array<{ index: number; file: string }>;
};

type Registry = {
  updatedAt: string;
  sessions: Record<string, ServerMetadata>;
};

const DEFAULT_TTL_MS = 5 * 60 * 1000;
const DEFAULT_ROOT = ".wireframe-gallery";

function usage(status = 1): never {
  console.error(`Usage: bun run server.ts --session <human-readable-slug> [--root .wireframe-gallery] [--cleanup] [--ttl-ms 300000] [--host 127.0.0.1] [--port 0]

Options:
  --session <slug>   Human-readable session slug, e.g. checkout-prototype or dashboard-mockup.
  --root <path>      Workspace-local root for all wireframe gallery temp files. Defaults to .wireframe-gallery.
  --cleanup          Remove this session directory when the server exits.
  --ttl-ms <number>  Auto-shutdown delay in milliseconds. Defaults to 300000.
  --host <host>      Host to bind. Defaults to 127.0.0.1.
  --port <number>    Port to bind. Defaults to 0, which picks a random free port.
  --help             Show this help.
`);
  process.exit(status);
}

function parseArgs(argv: string[]): Args {
  const args: Args = {
    session: "",
    root: DEFAULT_ROOT,
    ttlMs: DEFAULT_TTL_MS,
    cleanup: false,
    host: "127.0.0.1",
    port: 0,
  };

  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i];

    if (arg === "--help" || arg === "-h") {
      usage(0);
    }

    if (arg === "--cleanup") {
      args.cleanup = true;
      continue;
    }

    const value = argv[i + 1];
    if (!value) {
      usage();
    }

    if (arg === "--session") {
      args.session = value;
      i += 1;
      continue;
    }

    if (arg === "--root") {
      args.root = value;
      i += 1;
      continue;
    }

    if (arg === "--ttl-ms") {
      args.ttlMs = Number(value);
      i += 1;
      continue;
    }

    if (arg === "--host") {
      args.host = value;
      i += 1;
      continue;
    }

    if (arg === "--port") {
      args.port = Number(value);
      i += 1;
      continue;
    }

    usage();
  }

  if (!args.root || !isSessionSlug(args.session) || !Number.isFinite(args.ttlMs) || args.ttlMs <= 0 || !Number.isInteger(args.port) || args.port < 0) {
    usage();
  }

  return args;
}

function htmlEscape(value: string): string {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

function isInside(root: string, target: string): boolean {
  const path = relative(root, target);
  return path === "" || (!path.startsWith("..") && !isAbsolute(path));
}

function isSessionSlug(value: string): boolean {
  return /^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(value) && value.length <= 80;
}

function jsonResponse(value: unknown, status = 200): Response {
  return response(JSON.stringify(value, null, 2), status, { "content-type": "application/json; charset=utf-8" });
}

function response(body: string | Uint8Array, status = 200, headers: Record<string, string> = {}): Response {
  return new Response(body, {
    status,
    headers: {
      "cache-control": "no-store",
      "x-content-type-options": "nosniff",
      ...headers,
    },
  });
}

async function readRegistry(path: string): Promise<Registry> {
  const raw = await readFile(path, "utf8").catch(() => "");

  if (!raw) {
    return { updatedAt: new Date().toISOString(), sessions: {} };
  }

  try {
    const parsed = JSON.parse(raw) as Registry;
    return {
      updatedAt: typeof parsed.updatedAt === "string" ? parsed.updatedAt : new Date().toISOString(),
      sessions: parsed.sessions && typeof parsed.sessions === "object" ? parsed.sessions : {},
    };
  } catch {
    return { updatedAt: new Date().toISOString(), sessions: {} };
  }
}

async function writeRegistry(path: string, update: (registry: Registry) => void) {
  const registry = await readRegistry(path);
  registry.updatedAt = new Date().toISOString();
  update(registry);
  await writeFile(path, `${JSON.stringify(registry, null, 2)}\n`);
}

async function loadPrototypes(root: string): Promise<Prototype[]> {
  const entries = await readdir(root, { withFileTypes: true });

  return entries
    .filter((entry) => entry.isFile() && extname(entry.name).toLowerCase() === ".html")
    .map((entry) => entry.name)
    .sort((a, b) => a.localeCompare(b, undefined, { numeric: true }))
    .map((file, index) => ({
      index: index + 1,
      file,
      href: `/prototype/${encodeURIComponent(file)}`,
    }));
}

function renderGallery(prototypes: Prototype[], expiresAt: number, ttlMs: number): string {
  const cards = prototypes.length
    ? prototypes
        .map(
          (prototype) => `
        <article class="card">
          <header class="card-header">
            <div>
              <div class="option">Option ${prototype.index}</div>
              <div class="filename">${htmlEscape(prototype.file)}</div>
            </div>
            <a href="${prototype.href}" target="_blank" rel="noreferrer">open</a>
          </header>
          <iframe title="Option ${prototype.index}: ${htmlEscape(prototype.file)}" src="${prototype.href}" sandbox="allow-scripts"></iframe>
        </article>`
        )
        .join("\n")
    : `<section class="empty">No .html prototypes found in this sandbox.</section>`;

  const optionCount = `${prototypes.length} option${prototypes.length === 1 ? "" : "s"}`;

  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Wireframe Gallery</title>
  <style>
    :root {
      color-scheme: dark;
      --bg: #000000;
      --fg: #ffffff;
      --muted: #aaaaaa;
      --line: #ffffff;
      --soft: #111111;
    }

    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      background: var(--bg);
      color: var(--fg);
      font-family: Iosevka, "Iosevka Web", "SFMono-Regular", Consolas, monospace;
      font-size: 14px;
      line-height: 1.35;
    }

    a {
      color: inherit;
      text-decoration: none;
      border-bottom: 1px solid var(--fg);
    }

    .topbar {
      position: sticky;
      top: 0;
      z-index: 10;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 16px;
      padding: 14px 16px;
      background: var(--bg);
      border-bottom: 2px solid var(--line);
    }

    h1 {
      margin: 0;
      font-size: 16px;
      font-weight: 700;
      letter-spacing: 0.02em;
      text-transform: uppercase;
    }

    .meta {
      display: flex;
      align-items: center;
      gap: 12px;
      color: var(--muted);
      white-space: nowrap;
    }

    .timer {
      min-width: 82px;
      padding: 4px 7px;
      color: var(--fg);
      text-align: center;
      border: 1px solid var(--line);
    }

    .gallery {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(min(420px, 100%), 1fr));
      gap: 16px;
      padding: 16px;
    }

    .card {
      min-width: 0;
      border: 2px solid var(--line);
      background: var(--bg);
    }

    .card-header {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      gap: 12px;
      padding: 10px;
      border-bottom: 1px solid var(--line);
      background: var(--soft);
    }

    .option {
      font-weight: 700;
      text-transform: uppercase;
    }

    .filename {
      margin-top: 2px;
      color: var(--muted);
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    iframe {
      display: block;
      width: 100%;
      height: min(76vh, 900px);
      min-height: 520px;
      border: 0;
      background: #000000;
    }

    .empty {
      padding: 24px;
      border: 2px solid var(--line);
      background: var(--soft);
    }

    @media (max-width: 720px) {
      .topbar {
        align-items: flex-start;
        flex-direction: column;
      }

      .meta {
        width: 100%;
        justify-content: space-between;
      }

      iframe {
        min-height: 460px;
      }
    }
  </style>
</head>
<body>
  <header class="topbar">
    <h1>Wireframe Gallery</h1>
    <div class="meta">
      <span>${htmlEscape(optionCount)}</span>
      <span class="timer" id="timer">--:--</span>
    </div>
  </header>
  <main class="gallery">
    ${cards}
  </main>
  <script>
    let expiresAt = ${JSON.stringify(expiresAt)};
    let ttlMs = ${JSON.stringify(ttlMs)};
    const timer = document.getElementById("timer");

    async function syncDeadline() {
      try {
        const response = await fetch("/__deadline", { cache: "no-store" });
        if (response.ok) {
          const deadline = await response.json();
          expiresAt = deadline.expiresAt;
          ttlMs = deadline.ttlMs;
        }
      } catch {
        // The server may be closing. The visible countdown will handle it.
      } finally {
        window.setTimeout(syncDeadline, 2000);
      }
    }

    function renderTimer() {
      const remaining = Math.max(0, expiresAt - Date.now());
      const totalSeconds = Math.ceil(remaining / 1000);
      const minutes = Math.floor(totalSeconds / 60);
      const seconds = String(totalSeconds % 60).padStart(2, "0");
      timer.textContent = minutes + ":" + seconds;
      timer.title = "Auto-closes after " + Math.round(ttlMs / 1000) + " seconds";
      if (remaining <= 0) {
        timer.textContent = "closing";
        return;
      }
      window.setTimeout(renderTimer, 250);
    }

    syncDeadline();
    renderTimer();
  </script>
</body>
</html>`;
}

async function main() {
  const args = parseArgs(Bun.argv.slice(2));
  const workingDir = process.cwd();
  const tempRoot = resolve(workingDir, args.root);
  const designContextPath = join(tempRoot, "design-context.md");
  const registryPath = join(tempRoot, "registry.json");
  const sessionsRoot = join(tempRoot, "sessions");
  const sessionRoot = join(sessionsRoot, args.session);
  const root = join(sessionRoot, "prototypes");

  if (!isInside(workingDir, tempRoot) || tempRoot === workingDir) {
    console.error("Wireframe root must be a child directory of the current working directory.");
    console.error(`Working directory: ${workingDir}`);
    console.error(`Root: ${tempRoot}`);
    process.exit(1);
  }

  await mkdir(tempRoot, { recursive: true }).catch((error) => {
    console.error(`Failed to create wireframe root directory: ${tempRoot}`);
    console.error(error);
    process.exit(1);
  });

  await writeFile(
    designContextPath,
    "# Design Context\n\nShared notes for designer-prototype and designer-mockup agents. Preserve this file across preview server sessions.\n",
    { flag: "wx" }
  ).catch((error) => {
    if (error && typeof error === "object" && "code" in error && error.code === "EEXIST") {
      return;
    }
    console.error(`Failed to create design context file: ${designContextPath}`);
    console.error(error);
    process.exit(1);
  });

  await writeRegistry(registryPath, () => {}).catch((error) => {
    console.error(`Failed to initialize registry file: ${registryPath}`);
    console.error(error);
    process.exit(1);
  });

  if (!isInside(tempRoot, sessionRoot) || !isInside(sessionRoot, root)) {
    console.error(`Session directory must be inside the wireframe root.`);
    console.error(`Root: ${tempRoot}`);
    console.error(`Session: ${sessionRoot}`);
    process.exit(1);
  }

  await rm(sessionRoot, { recursive: true, force: true }).catch((error) => {
    console.error(`Failed to cleanup session directory before startup: ${sessionRoot}`);
    console.error(error);
    process.exit(1);
  });

  await mkdir(root, { recursive: true }).catch((error) => {
    console.error(`Failed to create prototype directory: ${root}`);
    console.error(error);
    process.exit(1);
  });

  const rootStat = await stat(root).catch(() => null);

  if (!rootStat?.isDirectory()) {
    console.error(`Prototype directory does not exist: ${root}`);
    process.exit(1);
  }

  let expiresAt = Date.now() + args.ttlMs;
  const controlToken = crypto.randomUUID();
  let server: ReturnType<typeof Bun.serve> | undefined;
  let shutdownTimer: ReturnType<typeof setTimeout> | undefined;
  let cleaned = false;

  async function cleanup() {
    if (cleaned) {
      return;
    }
    cleaned = true;

    if (args.cleanup) {
      await rm(sessionRoot, { recursive: true, force: true }).catch((error) => {
        console.error(`Failed to cleanup ${sessionRoot}:`, error);
      });
    }
  }

  async function buildMetadata(baseUrl: string, shutdownUrl: string, refreshUrl: string): Promise<ServerMetadata> {
    const prototypes = await loadPrototypes(root);
    return {
      previewUrl: baseUrl,
      shutdownUrl,
      refreshUrl,
      pid: process.pid,
      workingDir,
      root: tempRoot,
      session: args.session,
      sessionRoot,
      sandbox: root,
      designContext: designContextPath,
      registry: registryPath,
      cleanup: args.cleanup,
      expiresAt,
      expiresAtIso: new Date(expiresAt).toISOString(),
      options: prototypes.map((prototype) => ({ index: prototype.index, file: prototype.file })),
    };
  }

  async function writeMetadata(baseUrl: string, shutdownUrl: string, refreshUrl: string) {
    const metadata = await buildMetadata(baseUrl, shutdownUrl, refreshUrl);
    await writeFile(join(sessionRoot, "server.json"), `${JSON.stringify(metadata, null, 2)}\n`);
    await writeRegistry(registryPath, (registry) => {
      registry.sessions[args.session] = metadata;
    });
  }

  function scheduleShutdown() {
    if (shutdownTimer) {
      clearTimeout(shutdownTimer);
    }
    shutdownTimer = setTimeout(() => void shutdown("deadline timeout"), Math.max(0, expiresAt - Date.now()));
  }

  async function shutdown(reason: string) {
    console.log(`Shutting down wireframe gallery: ${reason}`);
    if (shutdownTimer) {
      clearTimeout(shutdownTimer);
    }
    server?.stop(true);
    await writeRegistry(registryPath, (registry) => {
      delete registry.sessions[args.session];
    }).catch((error) => {
      console.error(`Failed to update registry during shutdown: ${registryPath}`, error);
    });
    await cleanup();
    process.exit(0);
  }

  server = Bun.serve({
    hostname: args.host,
    port: args.port,
    async fetch(request) {
      const url = new URL(request.url);

      if (url.pathname === "/__shutdown") {
        if (url.searchParams.get("token") !== controlToken) {
          return response("Forbidden", 403, { "content-type": "text/plain; charset=utf-8" });
        }

        setTimeout(() => void shutdown("manual shutdown"), 0);
        return response("Shutting down\n", 200, { "content-type": "text/plain; charset=utf-8" });
      }

      if (url.pathname === "/__refresh") {
        if (url.searchParams.get("token") !== controlToken) {
          return response("Forbidden", 403, { "content-type": "text/plain; charset=utf-8" });
        }

        expiresAt = Date.now() + args.ttlMs;
        scheduleShutdown();

        if (server) {
          const baseUrl = `http://${server.hostname}:${server.port}`;
          await writeMetadata(baseUrl, `${baseUrl}/__shutdown?token=${controlToken}`, `${baseUrl}/__refresh?token=${controlToken}`);
        }

        return jsonResponse({ expiresAt, ttlMs: args.ttlMs, expiresAtIso: new Date(expiresAt).toISOString() });
      }

      if (url.pathname === "/__deadline") {
        return jsonResponse({ expiresAt, ttlMs: args.ttlMs, expiresAtIso: new Date(expiresAt).toISOString() });
      }

      if (url.pathname === "/" || url.pathname === "/index.html") {
        const prototypes = await loadPrototypes(root);
        return response(renderGallery(prototypes, expiresAt, args.ttlMs), 200, {
          "content-type": "text/html; charset=utf-8",
        });
      }

      if (url.pathname.startsWith("/prototype/")) {
        const encodedFile = url.pathname.slice("/prototype/".length);
        let file = "";

        try {
          file = decodeURIComponent(encodedFile);
        } catch {
          return response("Not found", 404, { "content-type": "text/plain; charset=utf-8" });
        }

        if (basename(file) !== file || extname(file).toLowerCase() !== ".html") {
          return response("Not found", 404, { "content-type": "text/plain; charset=utf-8" });
        }

        const filePath = resolve(join(root, file));
        if (!isInside(root, filePath)) {
          return response("Not found", 404, { "content-type": "text/plain; charset=utf-8" });
        }

        const fileStat = await stat(filePath).catch(() => null);
        if (!fileStat?.isFile()) {
          return response("Not found", 404, { "content-type": "text/plain; charset=utf-8" });
        }

        return new Response(Bun.file(filePath), {
          headers: {
            "cache-control": "no-store",
            "content-type": "text/html; charset=utf-8",
            "x-content-type-options": "nosniff",
          },
        });
      }

      return response("Not found", 404, { "content-type": "text/plain; charset=utf-8" });
    },
    error(error) {
      console.error(error);
      return response("Internal server error", 500, { "content-type": "text/plain; charset=utf-8" });
    },
  });

  const baseUrl = `http://${server.hostname}:${server.port}`;
  const shutdownUrl = `${baseUrl}/__shutdown?token=${controlToken}`;
  const refreshUrl = `${baseUrl}/__refresh?token=${controlToken}`;
  const prototypes = await loadPrototypes(root);

  scheduleShutdown();
  await writeMetadata(baseUrl, shutdownUrl, refreshUrl);

  for (const signal of ["SIGINT", "SIGTERM"] as const) {
    process.on(signal, () => void shutdown(signal));
  }

  console.log("Wireframe gallery running");
  console.log(`Preview URL: ${baseUrl}`);
  console.log(`Shutdown URL: ${shutdownUrl}`);
  console.log(`Refresh URL: ${refreshUrl}`);
  console.log(`PID: ${process.pid}`);
  console.log(`Working directory: ${workingDir}`);
  console.log(`Root: ${tempRoot}`);
  console.log(`Design context: ${designContextPath}`);
  console.log(`Registry: ${registryPath}`);
  console.log(`Session: ${args.session}`);
  console.log(`Session directory: ${sessionRoot}`);
  console.log(`Sandbox: ${root}`);
  console.log(`Cleanup: ${args.cleanup ? "enabled" : "disabled"}`);
  console.log(`Expires: ${new Date(expiresAt).toLocaleString()}`);
  console.log(`Metadata: ${join(sessionRoot, "server.json")}`);
  console.log("Options:");

  if (prototypes.length === 0) {
    console.log("  No .html prototypes found");
  } else {
    for (const prototype of prototypes) {
      console.log(`  Option ${prototype.index}: ${prototype.file}`);
    }
  }
}

await main();
