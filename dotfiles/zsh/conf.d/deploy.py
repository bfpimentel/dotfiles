#!/usr/bin/env python3

from __future__ import annotations

import argparse
import getpass
import os
import re
import shutil
import signal
import subprocess
import sys
import time
from pathlib import Path

import pexpect


VALID_TARGETS = ("powers", "thronos")
ACTIONS = ("switch", "boot", "test", "build")
SUDO_PROMPT = re.compile(r"\[sudo\] password for [^:\r\n]+:")
ANSI_ESCAPE = re.compile(r"\x1b\[[0-?]*[ -/]*[@-~]")


def paint(text: str, code: str) -> str:
    if not sys.stdout.isatty() or "NO_COLOR" in os.environ:
        return text
    return f"\033[{code}m{text}\033[0m"


def heading(host: str, label: str) -> None:
    print(paint(f"\n▸ {host} :: {label}", "1;36"), flush=True)


def sync_dotfiles(repo: Path, host: str) -> bool:
    command = [
        "rsync",
        "-az",
        "--delete",
        "--filter=:- .gitignore",
        "--exclude=.git/",
        "--exclude=.cache/",
        f"{repo}/",
        f"{host}:~/.dotfiles/",
    ]
    return subprocess.run(command).returncode == 0


def spawn_with_password(command: list[str], password: str) -> int:
    columns, rows = shutil.get_terminal_size()
    child = pexpect.spawn(
        command[0], command[1:], timeout=None, dimensions=(rows, columns)
    )
    previous_handler = signal.signal(
        signal.SIGWINCH,
        lambda *_: child.setwinsize(*reversed(shutil.get_terminal_size())),
    )
    tail = ""
    answered = False

    def answer_sudo(data: bytes) -> bytes:
        nonlocal tail, answered
        if not answered:
            tail = (tail + data.decode(errors="replace"))[-512:]
            if SUDO_PROMPT.search(ANSI_ESCAPE.sub("", tail)):
                answered = True
                child.send(f"{password}\r")
        return data

    try:
        child.interact(escape_character=None, output_filter=answer_sudo)
    finally:
        signal.signal(signal.SIGWINCH, previous_handler)
        child.close()

    if child.exitstatus is None:
        return 128 + (child.signalstatus or 0)
    return child.exitstatus


def rebuild(
    repo: Path,
    host: str,
    action: str,
    *,
    remote_build: bool,
    password: str | None,
    extra: list[str],
) -> bool:
    command = ["nh", "os", action, str(repo), "-H", host, "--target-host", host]
    if remote_build:
        command += ["--build-host", host]
    command += extra

    if password is None:
        return subprocess.run(command).returncode == 0
    return spawn_with_password(command, password) == 0


def deploy(
    repo: Path,
    host: str,
    action: str,
    *,
    remote_build: bool,
    password: str | None,
    extra: list[str],
) -> str | None:
    if action != "build":
        heading(host, "sync dotfiles")
        if not sync_dotfiles(repo, host):
            return "rsync failed"

    heading(host, f"nh os {action}")
    if not rebuild(
        repo,
        host,
        action,
        remote_build=remote_build,
        password=password,
        extra=extra,
    ):
        return f"{action} failed"
    return None


def format_duration(seconds: float) -> str:
    minutes, seconds = divmod(int(seconds), 60)
    return f"{minutes}m{seconds:02d}s" if minutes else f"{seconds}s"


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Deploy the NixOS fleet",
        usage="%(prog)s [options] [targets ...] [-- nh options]",
        epilog="arguments after -- are passed to nh (e.g. -- --ask -L)",
    )
    parser.add_argument("targets", nargs="*", choices=VALID_TARGETS)
    parser.add_argument("--action", choices=ACTIONS, default="switch")
    parser.add_argument(
        "-r",
        "--remote-build",
        action="store_true",
        help="build on each target host instead of locally",
    )
    argv = sys.argv[1:]
    split = argv.index("--") if "--" in argv else len(argv)
    args = parser.parse_args(argv[:split])
    extra = argv[split + 1 :]
    targets = args.targets or list(VALID_TARGETS)
    repo = Path(os.environ.get("DOTFILES", Path.home() / ".dotfiles")).expanduser()

    interactive = sys.stdin.isatty() and sys.stdout.isatty()
    password = (
        getpass.getpass("sudo password for remote hosts: ")
        if interactive and args.action != "build"
        else None
    )

    results: dict[str, tuple[str | None, float]] = {}
    try:
        for host in targets:
            started = time.monotonic()
            error = deploy(
                repo,
                host,
                args.action,
                remote_build=args.remote_build,
                password=password,
                extra=extra,
            )
            results[host] = (error, time.monotonic() - started)
            if error:
                break
    except KeyboardInterrupt:
        print()
    finally:
        password = None

    print()
    for host in targets:
        if host not in results:
            print(paint(f"○ {host:<12} skipped", "2"))
            continue
        error, elapsed = results[host]
        if error:
            print(paint(f"✗ {host:<12} {error}", "31"))
        else:
            print(paint(f"✓ {host:<12} {format_duration(elapsed)}", "32"))

    succeeded = len(results) == len(targets) and not any(
        error for error, _ in results.values()
    )
    return 0 if succeeded else 1


if __name__ == "__main__":
    raise SystemExit(main())
