#!/usr/bin/env python3

import os
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


def main() -> int:
    profiles = {
        "bruno": ("B", "Default"),
        "squibler": ("W", "Profile 1"),
    }
    key = sys.argv[1] if len(sys.argv) > 1 else ""
    if key not in profiles:
        return 1

    workspace, profile_dir = profiles[key]

    swaymsg = resolve_bin("swaymsg")
    brave = resolve_bin("brave")

    env = os.environ.copy()
    env["CHROME_DESKTOP"] = "com.brave.Browser.desktop"
    env["XDG_CURRENT_DESKTOP"] = env.get("XDG_CURRENT_DESKTOP", "sway")
    env["XDG_SESSION_DESKTOP"] = env.get("XDG_SESSION_DESKTOP", "sway")
    env["DESKTOP_SESSION"] = env.get("DESKTOP_SESSION", "sway")
    env["NIXOS_OZONE_WL"] = "1"

    subprocess.run([swaymsg, "workspace", workspace], env=env, check=False)

    args = [
        brave,
        f"--profile-directory={profile_dir}",
        "--new-window",
        "--ignore-gpu-blocklist",
        "--enable-gpu-rasterization",
        "--enable-zero-copy",
    ]
    os.execvpe(brave, args, env)


if __name__ == "__main__":
    sys.exit(main())
