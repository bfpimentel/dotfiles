pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io

ShellRoot {
    Dashboard {
        id: dashboard
    }

    Launcher {
        id: launcher
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
}
