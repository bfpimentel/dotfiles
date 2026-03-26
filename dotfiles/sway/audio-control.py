#!/usr/bin/env python3

import shutil
import subprocess
import sys
from pathlib import Path


def resolve_bin(name: str) -> str | None:
    candidate = Path.home() / ".nix-profile" / "bin" / name
    if candidate.is_file() and candidate.stat().st_mode & 0o111:
        return str(candidate)
    return shutil.which(name)


def main() -> int:
    pactl = resolve_bin("pactl")
    systemctl = resolve_bin("systemctl")
    if pactl and systemctl:
        try:
            subprocess.run(
                [pactl, "info"],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                timeout=2,
                check=True,
            )
        except (subprocess.SubprocessError, TimeoutError):
            subprocess.run(
                [
                    systemctl,
                    "--user",
                    "restart",
                    "pipewire.service",
                    "pipewire-pulse.service",
                    "wireplumber.service",
                ],
                check=False,
            )

    if binary:
        return subprocess.run([binary], check=False).returncode

    return 1


if __name__ == "__main__":
    sys.exit(main())
