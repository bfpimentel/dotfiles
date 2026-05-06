---
name: wireframe-gallery
description: Preview multiple disposable low-fidelity HTML prototypes side-by-side in a local sandboxed gallery.
license: MIT
compatibility: opencode
metadata:
  audience: designer-agents
  runtime: bun-typescript
---

## Purpose

Use this skill when you create multiple prototype directions and need the user to compare them visually before choosing one.

Generated prototype HTML is disposable. Persist design decisions in `.wireframe-gallery/design-context.md`, not in generated prototype files.

## Workflow

1. Pick a human-readable session slug that describes this design run, for example `checkout-prototype`, `settings-mockup`, or `dashboard-redesign-mockup`.
2. Read `.wireframe-gallery/design-context.md` if it exists, and use it as shared design memory.
3. Start the preview server in the background with Bun from the current working directory.
4. Wait for `.wireframe-gallery/sessions/<session>/server.json`, then read it to find the sandbox path, preview URL, shutdown URL, and refresh URL.
5. Write each option as a standalone `.html` file in the sandbox directory.
6. Use predictable filenames so the option order is stable, for example `01.html`, `02.html`, `03.html`.
7. Call the refresh URL once after writing the initial files. This updates the session metadata and extends the deadline before the user opens the preview.
8. Share the preview URL, shutdown URL, and option index mapping with the user.
9. When iterating on designs, update the sandbox files so they match the intended option set, then call the refresh URL to extend the deadline.
10. Ask the user which option they want to continue with.
11. Update `.wireframe-gallery/design-context.md` with answered questions, design constraints, selected direction, rejected directions, and next-step notes.
12. Close the server as soon as the preview is no longer needed.

The server clears only `.wireframe-gallery/sessions/<session>` every time that session starts. It must not delete `.wireframe-gallery/design-context.md`, `.wireframe-gallery/registry.json`, or other sessions.

## Shared Design Context

`.wireframe-gallery/design-context.md` is shared memory for all design agents in the same workspace.

Use it for:

- User goals and target audience.
- Styling preferences, references, and anti-references.
- Product constraints, required components, content requirements, and accessibility notes.
- Decisions the user already made.
- Directions that were rejected and why.
- Open questions that still need answers.

Do not use it for generated HTML. Generated prototype files belong inside the session sandbox from `server.json`.

## Session Slugs

Session names must be human-readable slugs:

- Use lowercase letters, numbers, and single hyphens.
- Do not use spaces, underscores, timestamps, UUIDs, or opaque names.
- Include enough meaning that another agent can understand the session later.
- Good examples: `checkout-prototype`, `settings-mockup`, `dashboard-redesign-mockup`.
- Bad examples: `test`, `session-123`, `abc`, `mockup-final-final`.

## Operational Contract

Use this skill as the source of truth for preview server lifecycle and sandbox paths.

1. Read `.wireframe-gallery/design-context.md` if it exists.
2. Start the server with a human-readable `--session` slug.
3. Read `.wireframe-gallery/sessions/<session>/server.json`.
4. Write prototypes into the `sandbox` path from `server.json`.
5. Call `refreshUrl` after writing prototypes or making iterations.
6. Share `previewUrl`, `shutdownUrl`, and the option mapping with the user.
7. Include a numbered list of the proposed designs with a brief description of each option, so the user can decide from the chat without relying only on the gallery labels.
8. Reuse the same running server while iterating on the same session.
9. Update `.wireframe-gallery/design-context.md` after design decisions are made.
10. Call `shutdownUrl` when the preview is no longer needed.

## Server

Run the bundled server with:

```bash
bun run ~/.config/opencode/skills/wireframe-gallery/bin/server.ts --session checkout-prototype --cleanup
```

The session `checkout-prototype` creates and serves `.wireframe-gallery/sessions/checkout-prototype/prototypes` in the current working directory.

When using it from an agent workflow, start it in the background so you can keep working:

```bash
nohup bun run ~/.config/opencode/skills/wireframe-gallery/bin/server.ts --session checkout-prototype --cleanup > /dev/null 2>&1 &
```

Then wait for and read `.wireframe-gallery/sessions/checkout-prototype/server.json`. It contains `previewUrl`, `shutdownUrl`, `refreshUrl`, `sandbox`, `root`, `session`, `sessionRoot`, `designContext`, `registry`, `pid`, `expiresAt`, and the current option mapping.

For local repo development, run it from this repository with:

```bash
bun run dotfiles/opencode/skills/wireframe-gallery/bin/server.ts --session checkout-prototype --cleanup
```

The server:

- Binds to `127.0.0.1` only.
- Uses a random free port by default.
- Creates `.wireframe-gallery`, `.wireframe-gallery/design-context.md`, and `.wireframe-gallery/registry.json` inside the current working directory.
- Creates the selected session under `.wireframe-gallery/sessions/<session>`.
- Removes only `.wireframe-gallery/sessions/<session>` on startup before creating that session sandbox.
- Requires the selected session directory to be inside `.wireframe-gallery/sessions`.
- Serves only files inside the selected session sandbox.
- Displays prototypes side-by-side with clear `Option 1`, `Option 2`, etc labels.
- Uses sandboxed iframes for each prototype.
- Shows a visible countdown timer on the page.
- Exits automatically after 5 minutes as a fallback.
- Prints a token-protected shutdown URL. Use it to close the server cleanly when done.
- Prints a token-protected refresh URL. Use it to extend the deadline while iterating.
- Writes `.wireframe-gallery/sessions/<session>/server.json` with all server control URLs and paths.
- Updates `.wireframe-gallery/registry.json` with active session metadata.

## Shutdown Requirement

You MUST close the server when it is not needed anymore.

Prefer the printed shutdown URL because it triggers cleanup when `--cleanup` is set. If that fails, kill the printed PID.

Do not leave preview servers running just because the 5-minute fallback exists. The fallback is only a safety net.

## Iteration Requirement

When the user asks for changes while the gallery is still running, do not restart the server. Update the `.html` files in the sandbox and call the refresh URL from `.wireframe-gallery/sessions/<session>/server.json`.

The sandbox is the source of truth for displayed options. The gallery option count equals the current `.html` files in the sandbox. If the intended option count changes, add or remove `.html` files so the sandbox exactly matches the intended set.

```bash
curl -fsS "<refreshUrl>"
```

The gallery countdown updates automatically after the deadline is refreshed.

Refreshing the deadline does not currently reload prototype iframe content or add newly created option cards in the already-open browser tab. After changing prototype files, tell the user to refresh the preview page if they do not see the update.

## Gallery Style

The gallery itself is intentionally dark, monochrome, flat, squared, and uses the `Iosevka` monospace font when installed.

The skill does not decide prototype fidelity. The calling agent owns whether the files are low-fidelity prototypes or high-fidelity mockups.

## User Prompt

After you start the server, tell the user:

- The preview URL.
- The shutdown URL, in case they need to manually stop the preview server.
- Which file maps to each option index.
- A numbered list of the proposed designs with a brief description of each option.
- That the preview will auto-close in 5 minutes.
- That you can close it sooner once they choose an option.
- That you can keep the same preview open while iterating.

Also include this manual debugging command with the real session slug:

```bash
bun run ~/.config/opencode/skills/wireframe-gallery/bin/server.ts --session checkout-prototype --cleanup
```
