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


def confirm(prompt: str) -> bool:
    return run_wofi(["󰄬 No", "󰄭 Yes"], prompt) == "󰄭 Yes"


def main() -> int:
    selection = run_wofi(
        [
            "󰍃 Sign out",
            "󰌾 Lock",
            "󰜉 Reboot",
            "󰐥 Shutdown",
        ],
        "Session",
    )
    if not selection:
        return 0

    hyprctl = resolve_bin("hyprctl")
    systemctl = resolve_bin("systemctl")
    hyprlock = resolve_bin("hyprlock")

    if selection == "󰍃 Sign out":
        if confirm("Sign out?"):
            subprocess.run([hyprctl, "dispatch", "exit"], check=False)
    elif selection == "󰌾 Lock":
        subprocess.run([hyprlock], check=False)
    elif selection == "󰜉 Reboot":
        if confirm("Reboot?"):
            subprocess.run([systemctl, "reboot"], check=False)
    elif selection == "󰐥 Shutdown":
        if confirm("Shutdown?"):
            subprocess.run([systemctl, "poweroff"], check=False)

    return 0


if __name__ == "__main__":
    sys.exit(main())
