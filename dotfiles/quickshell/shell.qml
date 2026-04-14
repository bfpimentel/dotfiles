pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io

ShellRoot {
    Dashboard {
        id: dashboard
        onRequestLauncher: launcher.openLauncher()
        onRequestClipboard: clipboard.openClipboard()
    }

    Launcher {
        id: launcher
    }

    Clipboard {
        id: clipboard
    }

    IpcHandler {
        target: "launcher"
        enabled: true

        function show() {
            launcher.openLauncher()
        }

        function hide() {
            launcher.closeLauncher()
        }

        function toggle() {
            if (launcher.visible) launcher.closeLauncher()
            else launcher.openLauncher()
        }
    }

    IpcHandler {
        target: "dashboard"
        enabled: true

        function show() {
            dashboard.openDashboard()
        }

        function hide() {
            dashboard.closeDashboard()
        }

        function toggle() {
            if (dashboard.visible) dashboard.closeDashboard()
            else dashboard.openDashboard()
        }

        function next() {
            dashboard.move(1)
        }

        function prev() {
            dashboard.move(-1)
        }

        function activate() {
            dashboard.activateSelection()
        }
    }

    IpcHandler {
        target: "clipboard"
        enabled: true

        function show() {
            clipboard.openClipboard()
        }

        function hide() {
            clipboard.closeClipboard()
        }

        function toggle() {
            if (clipboard.visible) clipboard.closeClipboard()
            else clipboard.openClipboard()
        }
    }
}
