#!/usr/bin/env python3

import os
import shutil
import signal
import subprocess
import sys
import getpass
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
    ps = resolve_bin("ps")
    user = os.environ.get("USER") or getpass.getuser()
    output = subprocess.check_output(
        [ps, "-u", user, "-o", "pid=,comm=", "--sort=comm,pid"],
        text=True,
    )

    rows: list[str] = []
    for line in output.splitlines():
        line = line.strip()
        if not line:
            continue
        parts = line.split(maxsplit=1)
        if not parts:
            continue
        pid = parts[0]
        name = parts[1] if len(parts) > 1 else "unknown"
        rows.append(f"{pid}\t{name}")

    if not rows:
        return 0

    selection = run_wofi(rows, "Processes")
    if not selection:
        return 0

    pid_text, _, name = selection.partition("\t")
    if not pid_text.isdigit():
        return 0
    pid = int(pid_text)
    name = name or "unknown"

    action = run_wofi(
        [
            "󰆴 Terminate",
            "󰗼 Details",
            "󰜺 Stop",
            "󰠳 Continue",
            "󰅖 Kill",
        ],
        f"Action: {name} ({pid})",
    )
    if not action:
        return 0

    if action == "󰗼 Details":
        details = subprocess.check_output(
            [ps, "-p", str(pid), "-o", "pid=,ppid=,state=,%cpu=,%mem=,etime=,comm="],
            text=True,
        ).strip()
        if details:
            run_wofi([details], f"Process {pid}")
        return 0

    signals = {
        "󰆴 Terminate": signal.SIGTERM,
        "󰜺 Stop": signal.SIGSTOP,
        "󰠳 Continue": signal.SIGCONT,
        "󰅖 Kill": signal.SIGKILL,
    }
    signum = signals.get(action)
    if signum is None:
        return 0

    action_name = action.split(" ", 1)[1]
    if confirm(f"{action_name} {name} ({pid})?"):
        try:
            os.kill(pid, signum)
        except ProcessLookupError:
            return 0

    return 0


if __name__ == "__main__":
    sys.exit(main())
