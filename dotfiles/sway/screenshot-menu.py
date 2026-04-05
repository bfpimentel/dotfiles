#!/usr/bin/env python3

import shutil
import subprocess
import sys
from datetime import datetime
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


def screenshot_filename() -> str:
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    return f"screenshot-{timestamp}.png"


def ensure_screenshots_dir() -> Path:
    screenshots_dir = Path.home() / "Documents" / "Screenshots"
    screenshots_dir.mkdir(parents=True, exist_ok=True)
    return screenshots_dir


def get_focused_window_geometry() -> str | None:
    swaymsg = resolve_bin("swaymsg")
    jq = resolve_bin("jq")
    result = subprocess.run(
        [swaymsg, "-t", "get_tree"],
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        return None
    jq_result = subprocess.run(
        [
            jq,
            "-r",
            '.. | select(.focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"',
        ],
        input=result.stdout,
        capture_output=True,
        text=True,
        check=False,
    )
    if jq_result.returncode != 0:
        return None
    return jq_result.stdout.strip() or None


def take_full_screenshot(save: bool = True) -> None:
    grim = resolve_bin("grim")
    if save:
        screenshots_dir = ensure_screenshots_dir()
        filename = screenshot_filename()
        subprocess.run([grim, str(screenshots_dir / filename)], check=False)
    else:
        wl_copy = resolve_bin("wl-copy")
        grim_proc = subprocess.Popen([grim, "-"], stdout=subprocess.PIPE)
        subprocess.run([wl_copy], stdin=grim_proc.stdout, check=False)


def take_area_screenshot(save: bool = True) -> None:
    grim = resolve_bin("grim")
    slurp = resolve_bin("slurp")
    slurp_proc = subprocess.Popen([slurp], stdout=subprocess.PIPE, text=True)
    geometry = slurp_proc.stdout.read().strip()
    if not geometry:
        return

    if save:
        screenshots_dir = ensure_screenshots_dir()
        filename = screenshot_filename()
        subprocess.run(
            [grim, "-g", geometry, str(screenshots_dir / filename)], check=False
        )
    else:
        wl_copy = resolve_bin("wl-copy")
        grim_proc = subprocess.Popen(
            [grim, "-g", geometry, "-"], stdout=subprocess.PIPE
        )
        subprocess.run([wl_copy], stdin=grim_proc.stdout, check=False)


def take_annotated_screenshot(fullscreen: bool = False) -> None:
    grim = resolve_bin("grim")
    slurp = resolve_bin("slurp")
    satty = resolve_bin("satty")

    if fullscreen:
        grim_proc = subprocess.Popen([grim, "-"], stdout=subprocess.PIPE)
    else:
        slurp_proc = subprocess.Popen([slurp], stdout=subprocess.PIPE, text=True)
        geometry = slurp_proc.stdout.read().strip()
        if not geometry:
            return
        grim_proc = subprocess.Popen(
            [grim, "-g", geometry, "-"], stdout=subprocess.PIPE
        )

    screenshots_dir = ensure_screenshots_dir()
    filename = screenshot_filename()
    subprocess.run(
        [
            satty,
            "--filename",
            "-",
            "--output-filename",
            str(screenshots_dir / filename),
        ],
        stdin=grim_proc.stdout,
        check=False,
    )


def take_window_screenshot(save: bool = True) -> None:
    grim = resolve_bin("grim")
    geometry = get_focused_window_geometry()
    if not geometry:
        return

    if save:
        screenshots_dir = ensure_screenshots_dir()
        filename = screenshot_filename()
        subprocess.run(
            [grim, "-g", geometry, str(screenshots_dir / filename)], check=False
        )
    else:
        wl_copy = resolve_bin("wl-copy")
        grim_proc = subprocess.Popen(
            [grim, "-g", geometry, "-"], stdout=subprocess.PIPE
        )
        subprocess.run([wl_copy], stdin=grim_proc.stdout, check=False)


def take_annotated_window_screenshot() -> None:
    grim = resolve_bin("grim")
    satty = resolve_bin("satty")
    geometry = get_focused_window_geometry()
    if not geometry:
        return

    grim_proc = subprocess.Popen([grim, "-g", geometry, "-"], stdout=subprocess.PIPE)
    screenshots_dir = ensure_screenshots_dir()
    filename = screenshot_filename()
    subprocess.run(
        [
            satty,
            "--filename",
            "-",
            "--output-filename",
            str(screenshots_dir / filename),
        ],
        stdin=grim_proc.stdout,
        check=False,
    )


def main() -> int:
    selection = run_wofi(
        [
            "󰆞 Full Screen (Save)",
            "󰆞 Full Screen (Clipboard)",
            "󰇄 Full Screen (Annotate)",
            "󰆿 Area (Save)",
            "󰆿 Area (Clipboard)",
            "󰇄 Area (Annotate)",
            "󰖲 Window (Save)",
            "󰖲 Window (Annotate)",
        ],
        "Screenshot",
    )
    if not selection:
        return 0

    actions = {
        "󰆞 Full Screen (Save)": lambda: take_full_screenshot(save=True),
        "󰆞 Full Screen (Clipboard)": lambda: take_full_screenshot(save=False),
        "󰇄 Full Screen (Annotate)": lambda: take_annotated_screenshot(fullscreen=True),
        "󰆿 Area (Save)": lambda: take_area_screenshot(save=True),
        "󰆿 Area (Clipboard)": lambda: take_area_screenshot(save=False),
        "󰇄 Area (Annotate)": lambda: take_annotated_screenshot(fullscreen=False),
        "󰖲 Window (Save)": lambda: take_window_screenshot(save=True),
        "󰖲 Window (Annotate)": lambda: take_annotated_window_screenshot(),
    }

    action = actions.get(selection)
    if action:
        action()

    return 0


if __name__ == "__main__":
    sys.exit(main())
