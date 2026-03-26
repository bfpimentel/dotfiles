#!/usr/bin/env python3

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


def resolve_python() -> str:
    return resolve_bin("python3")


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


def main() -> int:
    menu = [
        "󰀻 Applications",
        "󰟵 Bitwarden",
        "󰅌 Clipboard",
        "󰕾 Audio",
        " Windows",
        "󰖲 Tasks",
        "󰍹 Processes",
        "󰐥 Session",
    ]

    selection = run_wofi(menu, "Menu")
    if not selection:
        return 0

    sway_path = Path.home() / ".config" / "sway"
    python = resolve_python()
    routes: dict[str, list[str]] = {
        "󰀻 Applications": [resolve_bin("wofi"), "--show", "drun"],
        "󰟵 Bitwarden": [python, str(sway_path / "bitwarden-menu.py")],
        "󰅌 Clipboard": [python, str(sway_path / "clipboard-menu.py")],
        "󰕾 Audio": [python, str(sway_path / "audio-control.py")],
        " Windows": [python, str(sway_path / "windows-menu.py")],
        "󰖲 Tasks": [python, str(sway_path / "task-manager.py")],
        "󰍹 Processes": [python, str(sway_path / "processes-menu.py")],
        "󰐥 Session": [python, str(sway_path / "session-menu.py")],
    }

    cmd = routes.get(selection)
    if not cmd:
        return 0

    return subprocess.run(cmd, check=False).returncode


if __name__ == "__main__":
    sys.exit(main())
