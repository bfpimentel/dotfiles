pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io

ShellRoot {
    Dashboard {
        id: dashboard
        onRequestLauncher: launcher.openLauncher()
        onRequestBitwarden: bitwarden.openBitwarden()
        onRequestClipboard: clipboard.openClipboard()
        onRequestSession: session.openSession()
        onRequestProcesses: processes.openProcesses()
        onRequestScreenshot: screenshot.openScreenshot()
    }

    Launcher {
        id: launcher
    }

    Bitwarden {
        id: bitwarden
    }

    Clipboard {
        id: clipboard
    }

    Session {
        id: session
    }

    Processes {
        id: processes
    }

    Screenshot {
        id: screenshot
    }

    Notifications {
        id: notifications
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
        target: "bitwarden"
        enabled: true

        function show() {
            bitwarden.openBitwarden()
        }

        function hide() {
            bitwarden.closeBitwarden()
        }

        function toggle() {
            if (bitwarden.visible) bitwarden.closeBitwarden()
            else bitwarden.openBitwarden()
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

    IpcHandler {
        target: "session"
        enabled: true

        function show() {
            session.openSession()
        }

        function hide() {
            session.closeSession()
        }

        function toggle() {
            if (session.visible) session.closeSession()
            else session.openSession()
        }
    }

    IpcHandler {
        target: "processes"
        enabled: true

        function show() {
            processes.openProcesses()
        }

        function hide() {
            processes.closeProcesses()
        }

        function toggle() {
            if (processes.visible) processes.closeProcesses()
            else processes.openProcesses()
        }
    }

    IpcHandler {
        target: "screenshot"
        enabled: true

        function show() {
            screenshot.openScreenshot()
        }

        function hide() {
            screenshot.closeScreenshot()
        }

        function toggle() {
            if (screenshot.visible) screenshot.closeScreenshot()
            else screenshot.openScreenshot()
        }
    }

    IpcHandler {
        target: "notifications"
        enabled: true

        function show() {
            notifications.openCenter()
        }

        function hide() {
            notifications.closeCenter()
        }

        function toggle() {
            notifications.toggleCenter()
        }

        function clear() {
            notifications.clearAll()
        }
    }
}
