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


def main() -> int:
    cliphist = resolve_bin("cliphist")
    wofi = resolve_bin("wofi")
    wl_copy = resolve_bin("wl-copy")

    history = subprocess.run([cliphist, "list"], capture_output=True, text=True, check=False)
    if history.returncode != 0 or not history.stdout.strip():
        return 0

    selection = subprocess.run(
        [wofi, "--dmenu", "--prompt", "Clipboard", "--insensitive"],
        input=history.stdout,
        text=True,
        capture_output=True,
        check=False,
    )
    if selection.returncode != 0:
        return 0

    choice = selection.stdout.strip()
    if not choice:
        return 0

    decoded = subprocess.run(
        [cliphist, "decode"],
        input=(choice + "\n").encode(),
        capture_output=True,
        check=False,
    )
    if decoded.returncode != 0:
        return decoded.returncode

    return subprocess.run([wl_copy], input=decoded.stdout, check=False).returncode


if __name__ == "__main__":
    sys.exit(main())
