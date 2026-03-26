#!/usr/bin/env python3

import json
import os
import shutil
import subprocess
import sys
from pathlib import Path


SESSION_FILE = (
    Path(os.environ.get("XDG_RUNTIME_DIR", "/tmp")) / f"bw-session-{os.getuid()}"
)


def resolve_bin(name: str) -> str:
    candidate = Path.home() / ".nix-profile" / "bin" / name
    if candidate.is_file() and candidate.stat().st_mode & 0o111:
        return str(candidate)
    found = shutil.which(name)
    if not found:
        raise SystemExit(1)
    return found


def resolve_optional_bin(name: str) -> str | None:
    candidate = Path.home() / ".nix-profile" / "bin" / name
    if candidate.is_file() and candidate.stat().st_mode & 0o111:
        return str(candidate)
    return shutil.which(name)


def wofi_select(options: list[str], prompt: str, password: bool = False) -> str | None:
    wofi = resolve_bin("wofi")
    cmd = [wofi, "--dmenu", "--prompt", prompt, "--insensitive"]
    if password:
        cmd.append("--password")

    proc = subprocess.run(
        cmd,
        input="\n".join(options) + "\n",
        text=True,
        capture_output=True,
        check=False,
    )
    if proc.returncode != 0:
        return None

    value = proc.stdout.strip()
    return value or None


def wofi_prompt_text(prompt: str, password: bool = False) -> str | None:
    return wofi_select([""], prompt, password=password)


def wofi_info(message: str) -> None:
    wofi_select([message], "Bitwarden")


class LoadingMenu:
    def __init__(self, prompt: str, message: str):
        self.prompt = prompt
        self.message = message
        self._proc: subprocess.Popen | None = None

    def _start_proc(self) -> None:
        wofi = resolve_bin("wofi")
        self._proc = subprocess.Popen(
            [wofi, "--dmenu", "--prompt", self.prompt, "--insensitive"],
            stdin=subprocess.PIPE,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            text=True,
        )
        if self._proc.stdin:
            self._proc.stdin.write(f"{self.message}\n")
            self._proc.stdin.close()

    def __enter__(self):
        self._start_proc()
        return self

    def __exit__(self, exc_type, exc, tb):
        if not self._proc:
            return
        if self._proc.poll() is None:
            self._proc.terminate()
            try:
                self._proc.wait(timeout=0.2)
            except subprocess.TimeoutExpired:
                self._proc.kill()


def run_bw(
    args: list[str], session: str | None = None, env_extra: dict[str, str] | None = None
) -> subprocess.CompletedProcess:
    bw = resolve_bin("bw")
    env = os.environ.copy()
    if session:
        env["BW_SESSION"] = session
    if env_extra:
        env.update(env_extra)

    return subprocess.run(
        [bw, *args],
        text=True,
        capture_output=True,
        check=False,
        env=env,
    )


def load_session() -> str | None:
    if not SESSION_FILE.exists():
        return None
    token = SESSION_FILE.read_text(encoding="utf-8").strip()
    return token or None


def save_session(token: str) -> None:
    SESSION_FILE.parent.mkdir(parents=True, exist_ok=True)
    fd = os.open(str(SESSION_FILE), os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
    with os.fdopen(fd, "w", encoding="utf-8") as handle:
        handle.write(token)


def clear_session() -> None:
    try:
        SESSION_FILE.unlink()
    except FileNotFoundError:
        pass


def session_is_valid(token: str) -> bool:
    proc = run_bw(["unlock", "--check"], session=token)
    return proc.returncode == 0


def needs_reauth(proc: subprocess.CompletedProcess) -> bool:
    text = (proc.stdout + proc.stderr).lower()
    checks = [
        "vault is locked",
        "invalid session",
        "session key",
        "not logged in",
        "log in",
    ]
    return any(check in text for check in checks)


def unlock_with_password() -> str | None:
    password = wofi_prompt_text("Bitwarden master password", password=True)
    if not password:
        return None

    with LoadingMenu("Bitwarden", "Authenticating..."):
        proc = run_bw(
            ["unlock", "--raw", "--passwordenv", "BW_WOFI_MASTER_PASSWORD"],
            env_extra={"BW_WOFI_MASTER_PASSWORD": password},
        )
    if proc.returncode != 0:
        return None

    token = proc.stdout.strip()
    if not token:
        return None

    save_session(token)
    return token


def ensure_session() -> str | None:
    token = load_session()
    if token and session_is_valid(token):
        return token

    clear_session()
    for _ in range(3):
        token = unlock_with_password()
        if token and session_is_valid(token):
            return token

    return None


def run_bw_with_reauth(
    args: list[str], session: str
) -> tuple[subprocess.CompletedProcess, str | None]:
    proc = run_bw(args, session=session)
    if proc.returncode == 0:
        return proc, session

    if not needs_reauth(proc):
        return proc, session

    clear_session()
    refreshed = ensure_session()
    if not refreshed:
        return proc, None

    retry = run_bw(args, session=refreshed)
    return retry, refreshed


def format_item(item: dict) -> str:
    name = item.get("name") or "(unnamed)"
    login = item.get("login") or {}
    username = login.get("username") or ""

    parts = [name]
    if username:
        parts.append(f"[{username}]")
    return " - ".join(parts)


def copy_to_clipboard(value: str) -> int:
    wl_copy = resolve_bin("wl-copy")
    return subprocess.run([wl_copy], input=value, text=True, check=False).returncode


def notify_copied(item_name: str, field: str) -> None:
    notify_send = resolve_optional_bin("notify-send")
    if not notify_send:
        return
    subprocess.run(
        [notify_send, f"{item_name} {field} copied to clipboard!"],
        check=False,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def main() -> int:
    session = ensure_session()

    if not session:
        wofi_info("Unable to unlock Bitwarden. Run 'bw login' in terminal if needed.")
        return 1

    items_proc: subprocess.CompletedProcess | None = None
    with LoadingMenu("Bitwarden", "Loading vault..."):
        items_proc, session = run_bw_with_reauth(["list", "items"], session)

    if not items_proc or items_proc.returncode != 0 or not session:
        wofi_info("Failed to read vault items.")
        return 1

    try:
        items = json.loads(items_proc.stdout)
    except json.JSONDecodeError:
        wofi_info("Failed to parse vault items.")
        return 1

    if not isinstance(items, list) or not items:
        wofi_info("No vault items found.")
        return 0

    entries: list[tuple[str, str, dict]] = []
    for item in items:
        if not isinstance(item, dict):
            continue
        item_id = item.get("id")
        if not isinstance(item_id, str):
            continue
        entries.append((format_item(item), item_id, item))

    entries.sort(key=lambda entry: entry[0].lower())
    if not entries:
        wofi_info("No vault items found.")
        return 0

    counts: dict[str, int] = {}
    rows: list[str] = []
    selection_map: dict[str, tuple[str, dict]] = {}
    for label, item_id, item in entries:
        seen = counts.get(label, 0) + 1
        counts[label] = seen
        display = label if seen == 1 else f"{label} ({seen})"
        rows.append(display)
        selection_map[display] = (item_id, item)

    selection = wofi_select(rows, "Bitwarden")
    if not selection:
        return 0

    selected = selection_map.get(selection)
    if not selected:
        return 0
    item_id, item = selected

    login = item.get("login") or {}
    username = login.get("username") or ""
    password = login.get("password") or ""
    has_totp = bool(login.get("totp"))

    options: list[str] = []
    if username:
        options.append("Copy username")
    if password:
        options.append("Copy password")
    if has_totp:
        options.append("Copy TOTP")

    if not options:
        wofi_info("Selected item has no username/password/TOTP.")
        return 0

    action = wofi_select(options, item.get("name") or "Bitwarden")
    if not action:
        return 0

    if action == "Copy username":
        code = copy_to_clipboard(username)
        if code == 0:
            notify_copied(item.get("name") or "item", "username")
        return code

    if action == "Copy password":
        code = copy_to_clipboard(password)
        if code == 0:
            notify_copied(item.get("name") or "item", "password")
        return code

    if action == "Copy TOTP":
        with LoadingMenu("Bitwarden", "Generating TOTP..."):
            totp_proc, session = run_bw_with_reauth(["get", "totp", item_id], session)
        if totp_proc.returncode != 0:
            wofi_info("Failed to generate TOTP.")
            return 1
        code = copy_to_clipboard(totp_proc.stdout.strip())
        if code == 0:
            notify_copied(item.get("name") or "item", "totp")
        return code

    return 0


if __name__ == "__main__":
    sys.exit(main())
