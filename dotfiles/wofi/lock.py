#!/usr/bin/env python3

import os
import shutil
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
    swaylock = resolve_bin("swaylock")
    args = [
        swaylock,
        "--daemonize",
        "--screenshots",
        "--effect-blur",
        "7x5",
        "--clock",
        "--timestr",
        "%H:%M",
        "--datestr",
        "%a %d %b",
        "--font",
        "VictorMono NFM",
        "--font-size",
        "30",
        "--indicator",
        "--indicator-radius",
        "95",
        "--indicator-thickness",
        "6",
        "--line-color",
        "00000000",
        "--separator-color",
        "00000000",
        "--inside-color",
        "000000d9",
        "--ring-color",
        "ffffffcc",
        "--text-color",
        "ffffffee",
        "--key-hl-color",
        "ffffffff",
        "--bs-hl-color",
        "9a9a9aff",
    ]
    os.execv(swaylock, args)


if __name__ == "__main__":
    sys.exit(main())
