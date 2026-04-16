pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io

ShellRoot {
  Dashboard {
    id: dashboard

    onRequestBitwarden: bitwarden.openBitwarden()
    onRequestClipboard: clipboard.openClipboard()
    onRequestLauncher: launcher.openLauncher()
    onRequestProcesses: processes.openProcesses()
    onRequestScreenshot: screenshot.openScreenshot()
    onRequestSession: session.openSession()
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

  Volume {
    id: volume

  }

  IpcHandler {
    function hide() {
      launcher.closeLauncher();
    }

    function show() {
      launcher.openLauncher();
    }

    function toggle() {
      if (launcher.visible)
        launcher.closeLauncher();
      else
        launcher.openLauncher();
    }

    enabled: true
    target: "launcher"
  }

  IpcHandler {
    function hide() {
      bitwarden.closeBitwarden();
    }

    function show() {
      bitwarden.openBitwarden();
    }

    function toggle() {
      if (bitwarden.visible)
        bitwarden.closeBitwarden();
      else
        bitwarden.openBitwarden();
    }

    enabled: true
    target: "bitwarden"
  }

  IpcHandler {
    function activate() {
      dashboard.activateSelection();
    }

    function hide() {
      dashboard.closeDashboard();
    }

    function next() {
      dashboard.move(1);
    }

    function prev() {
      dashboard.move(-1);
    }

    function show() {
      dashboard.openDashboard();
    }

    function toggle() {
      if (dashboard.visible)
        dashboard.closeDashboard();
      else
        dashboard.openDashboard();
    }

    enabled: true
    target: "dashboard"
  }

  IpcHandler {
    function hide() {
      clipboard.closeClipboard();
    }

    function show() {
      clipboard.openClipboard();
    }

    function toggle() {
      if (clipboard.visible)
        clipboard.closeClipboard();
      else
        clipboard.openClipboard();
    }

    enabled: true
    target: "clipboard"
  }

  IpcHandler {
    function hide() {
      session.closeSession();
    }

    function show() {
      session.openSession();
    }

    function toggle() {
      if (session.visible)
        session.closeSession();
      else
        session.openSession();
    }

    enabled: true
    target: "session"
  }

  IpcHandler {
    function hide() {
      processes.closeProcesses();
    }

    function show() {
      processes.openProcesses();
    }

    function toggle() {
      if (processes.visible)
        processes.closeProcesses();
      else
        processes.openProcesses();
    }

    enabled: true
    target: "processes"
  }

  IpcHandler {
    function hide() {
      screenshot.closeScreenshot();
    }

    function show() {
      screenshot.openScreenshot();
    }

    function toggle() {
      if (screenshot.visible)
        screenshot.closeScreenshot();
      else
        screenshot.openScreenshot();
    }

    enabled: true
    target: "screenshot"
  }

  IpcHandler {
    function clear() {
      notifications.clearAll();
    }

    function hide() {
      notifications.closeCenter();
    }

    function show() {
      notifications.openCenter();
    }

    function toggle() {
      notifications.toggleCenter();
    }

    enabled: true
    target: "notifications"
  }

  IpcHandler {
    function lower() {
      volume.lower();
    }

    function raise() {
      volume.raise();
    }

    function toggle() {
      volume.toggle();
    }

    enabled: true
    target: "volume"
  }
}
