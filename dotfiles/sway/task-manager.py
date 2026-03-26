#!/usr/bin/env python3

import json
import shutil
import subprocess
import sys
from pathlib import Path


def resolve_bin(name: str) -> str:
    candidate = Path.home() / ".nix-profile" / "bin" / name
    if candidate.is_file() and candidate.stat().st_mode & 0o111:
        return str(candidate)
    found = shutil.which(name)
    if not found:
        raise SystemExit(1)
    return found


def run_wofi(options: list[str], prompt: str) -> str | None:
    wofi = resolve_bin("wofi")
    proc = subprocess.run(
        [wofi, "--dmenu", "--prompt", prompt, "--insensitive"],
        input="\n".join(options) + "\n",
        text=True,
        capture_output=True,
        check=False,
    )
    if proc.returncode != 0:
        return None
    value = proc.stdout.strip()
    return value or None


def iter_windows(node: dict):
    if node.get("type") == "con":
        app = node.get("app_id") or node.get("window_properties", {}).get("class")
        title = node.get("name") or ""
        if app and title:
            yield {
                "id": node.get("id"),
                "app": app,
                "title": title,
            }

    for key in ("nodes", "floating_nodes"):
        for child in node.get(key, []):
            yield from iter_windows(child)


def main() -> int:
    swaymsg = resolve_bin("swaymsg")
    tree_raw = subprocess.check_output([swaymsg, "-t", "get_tree"], text=True)
    tree = json.loads(tree_raw)

    unique: dict[int, dict] = {}
    for window in iter_windows(tree):
        con_id = window.get("id")
        if isinstance(con_id, int):
            unique[con_id] = window

    windows = sorted(unique.values(), key=lambda w: (w["app"].lower(), w["title"].lower()))
    if not windows:
        return 0

    rows = [f"{w['id']}\t{w['app']} - {w['title']}" for w in windows]
    selection = run_wofi(rows, "Tasks")
    if not selection:
        return 0

    con_id = selection.split("\t", 1)[0]
    action = run_wofi(["focus", "quit"], "Action") or "focus"

    if action == "quit":
        subprocess.run([swaymsg, f"[con_id={con_id}] kill"], check=False)
    else:
        subprocess.run([swaymsg, f"[con_id={con_id}] focus"], check=False)

    return 0


if __name__ == "__main__":
    sys.exit(main())
